# The barcode `A`, `B` means recharge and remittance
class Item < ApplicationRecord
  default_scope { order 'created_at desc' }

  belongs_to :jail
  belongs_to :category

  has_many :line_items
  has_many :orders, :through => :line_items
  
  validates :title, :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  
  has_attached_file :avatar, styles: { medium: '100x100>', thumb: '50x50>' },
	default_url: '/images/:style/missing.png'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def avatar_url
    avatar.url(:original)
  end
end