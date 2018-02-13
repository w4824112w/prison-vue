class Jail < ApplicationRecord
#  before_save :skip_for_audio

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

#  has_attached_file :image, styles: { medium: '680x400>', thumb: '480x320>' },
#                    default_url: '/images/:style/missing.png'

#  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

#  private

#  def skip_for_audio
#    ! %w(audio/ogg application/ogg).include?(image_content_type)
#  end

  def self.upload(file)
  #  puts file.inspect
    begin
    name = file.original_filename
    content_type = file.content_type
  #  puts 'name----'+name+'--content_type--'+content_type
    directory="public/upload"
    FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
    path=File.join(directory,name)
    File.open(path,"wb") { |f| f.write(file.read) }

    rescue =>error
      return { code: 500, msg: "文件错误，请重新上传" }
    end
    { code: 200, msg: "文件上传成功", path: path, name: name, content_type: content_type}
  end

end