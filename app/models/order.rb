#encoding = utf-8

# At first, Order model creates an order instance with trade_no, amount
# and then return this order to response.
#
# Second, return prepay_id which request from third party payment platform.
# There are three statuse of an order, which are `WAIT_FOR_PAYMENT`, `WAIT_FOR_NOTIFY`, `TRADE_SUCCESS`
require "#{Rails.root}/lib/payment/wexin"

class Order < ApplicationRecord
  include Wexin

  default_scope { order 'created_at desc ' }

  before_update :remit_or_recharge, unless: Proc.new { |order| order.payment_type.nil? }

  belongs_to :family

  has_many :line_items, inverse_of: :order
  has_many :items, through: :line_items

  accepts_nested_attributes_for :line_items, allow_destroy: true

  validates_presence_of :amount, :jail_id, :family_id, :trade_no, :line_items

  validates :amount, numericality: { greater_than: 0 }
  
  # Check remittance and consumption restrictions unless recharge
  validate :upper_balance?, on: :create

  def process_payment_callback(status, payment_time)
    update_attributes({ status: status, gmt_payment: payment_time })
  end
  
  # Request a prepay id from the third party payment platform
  # For now, It is required only uses Weixin platform.
  #
  # @param payment_type [String]
  # @return [Hash<Symbol => Integer, String >]
  def prepay(payment_type)
    result = request_prepay_id(payment_type)

    if result[:code] == 200
      unless update_attributes({ payment_type: payment_type })
        logger.error "update order: #{self.id} payment type error #{self.errors}"
        return { code: 500, msg: 'update payment type failed', errors: self.errors }
      end
    end

    result
  end

  # Return orders that traded success which category id was not equals 5 
  #
  # @param jail [Integer] 
  # @param limit [Integer]
  # @param offset [Integer]
  # @return [Hash]
  def self.success_orders(jail, limit, offset)
    Order.joins(:items).
      where(" `orders`.jail_id = #{jail} AND `items`.category_id != 5 AND `orders`.status = 'TRADE_SUCCESS' ").
      limit(limit).
      offset(offset)
  end

  private
  
  # Check remittance and consumption restrictions before create order.
  def upper_balance?
    now = Time.now
    sql = "SELECT l.quantity, i.price, i.barcode 
            FROM line_items l 
            INNER JOIN orders o ON o.id = l.order_id 
            INNER JOIN items i ON i.id = l.item_id 
            WHERE o.family_id = #{family.id} AND status = 'TRADE_SUCCESS' 
            AND o.created_at BETWEEN '#{now.beginning_of_month}' AND '#{now.end_of_month}'"

    case line_items.first.item.barcode
    when 'A'  # recharge has no restriction
    when 'B'
      restrictions = family.prisoner.jail.configuration.settings["restrictions"]["remittance"]
      sql << " AND i.barcode = 'B'"
      is_restrict?(sql, restrictions)
    else
      restrictions = family.prisoner.jail.configuration.settings["restrictions"]["consumption"]
      sql << " AND i.barcode NOT IN ('A', 'B')"
      is_restrict?(sql, restrictions)
    end
  end

  def is_restrict?(sql, restrictions)
    if Order.find_by_sql(sql).sum(0){ |r| r.price * r.quantity } + self.amount > restrictions
      self.errors.add(:restriction, "limit restriction")
      return false 
    end

    true
  end

  # 根据 item_id 判断是否是汇款或者充值
  def remit_or_recharge
    case line_items.first.item.barcode
    when 'A'
      if family.last_trade_no != self.trade_no && status == 'TRADE_SUCCESS'
        logger.debug 'ssssssss'
        family.update_attributes!({ balance: family.balance + amount, last_trade_no: trade_no })
      end
    when 'B'
      # TODO: add amount to prisoner's account
    else  
    end
  end

  # Apply a prepay number from third party payment platform
  # then returns a hash that contains result `code`, signed key 
  # string that responed from payment platform and the signed params
  # within `appId`, `nonceStr`, `package`, `partnerId` and `timeStamp`
  #
  # @param payment_type [String]
  # @return [Hash<Symbol => Integer, Hash, String>]
  def request_prepay_id(payment_type)
    case payment_type.upcase
    when 'WEIXIN' then apply_prepay(trade_no, amount, ip)
    when 'ALIPAY' then { code: 200, prepay_id: '0' }
    when 'UNIONPAY' then { code: 200, prepay_id: '123456' }
    else
      { code: 501, msg: 'Unsupported payment type' }
    end
  end

end