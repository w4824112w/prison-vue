class UuidImage < ApplicationRecord
  belongs_to :registration

  attr_accessor :image, :image_data
  before_save   :decode_image_data

  has_attached_file :image, styles: { medium: '200x100>', thumb: '100x50>' },
  default_url: '/images/default/missing.jpeg'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def image_url
    image.url(:original)
  end
  
  private
    def decode_image_data
      if image_data
        logger.debug "decode_image_data"
      	data = StringIO.new(Base64.decode64(image_data))
      	data.class.class_eval { attr_accessor :original_filename, :content_type }
      	data.original_filename = "#{self.registration.id}-#{DateTime.now.to_i}.png"
      	data.content_type = 'image/png'

      	self.image = data
      end
    end
end
