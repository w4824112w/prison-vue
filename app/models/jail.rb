class Jail < ApplicationRecord
  before_save :skip_for_audio

  has_one :configuration
  
  has_many :news, :dependent => :destroy
  has_many :items, :dependent => :destroy
  has_many :users, :dependent => :destroy

  has_many :laws, :dependent => :destroy
  has_many :mail_boxes, :dependent => :destroy
  has_many :terminals

  has_many :registrations

  validates :title, :description, :zipcode, :state, :city, :district, :street, :presence => true
  validates :zipcode, uniqueness: true

  has_attached_file :image, styles: { medium: '680x400>', thumb: '480x320>' },
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  private

  def skip_for_audio
    ! %w(audio/ogg application/ogg).include?(image_content_type)
  end

end