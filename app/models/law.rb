class Law < ApplicationRecord
  default_scope { where("sys_flag =1")}
  
  belongs_to :jail
  
  validates :title ,presence: true
  validates :contents ,presence: true
  
  has_attached_file :image, styles: { medium: '680x400>', thumb: '480x320>' },
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/


  def image_url
    image.url(:thumb)
  end
end
