require "#{Rails.root}/lib/payment/sign_utils"

module Wexin

  MCH_ID       = '1320273701'
  APP_ID       = 'wx4973a8b575999262'
  PARTNER_ID   = '1320273701'
  TRADE_TYPE   = 'APP'
  CALLBACK_URL = 'https://www.fushuile.com/api/v1/weixin'
  PAYMENT_URL  = 'https://api.mch.weixin.qq.com/pay/unifiedorder'
  KEY          = 'key=d75699d893882dea526ea05e9c7a4090'

  # Send request for applying a prepay id
  # In fact that is only used for wexin payment now
  # @param url [String] of the third party payment platform
  # @param params[Hash<Symbol => String, Integer>] 
  # @param content_type[Hash<String => String>]
  #
  # @return [XML] within prepay id 
  def apply_prepay(trade_no, amount, ip)
    params = { appid: APP_ID,
               body: 'weixin',
               mch_id: MCH_ID,
               nonce_str: SecureRandom.hex(16),
               notify_url: CALLBACK_URL,
               out_trade_no: trade_no,
               prepay_id: nil,
               spbill_create_ip: ip,
               total_fee: (amount * 100).to_i,
               trade_type: TRADE_TYPE }

    # send request to weixin
    http_request(params) do | body |
      response = Hash.from_xml(body)['xml']

      if response['return_code'] == 'SUCCESS' && response['result_code'] == 'SUCCESS'
        logger.debug "get prepay_id: #{response['prepay_id']}"

        hash = { appId: APP_ID,
                 nonceStr: SecureRandom.hex(16),
                 package: 'Sign=WXPay',
                 partnerId: PARTNER_ID,
                 prepayId: response['prepay_id'],
                 timeStamp: Time.now.to_i }

        return { code: 200, signed_params: hash, sign: response['sign'] }
      end

      { code: 400, msg: response['return_msg'] }
    end
  end

  private

  def create_body(params)
    signed_string = SignUtils.generate_sign(params, KEY)

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.xml {
        params.reject{ |k, v| v.nil? }.each{ |key, value| xml.send "#{key}_", value }
        xml.sign signed_string
      }
    end

    builder.to_xml
  end

  def http_request(params)
    uri = URI.parse(PAYMENT_URL)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/xml'})
    req.body = create_body(params)

    return yield http.request(req).body if block_given?

    http.request(req).body
  end

end
