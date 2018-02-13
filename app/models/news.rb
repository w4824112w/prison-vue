class News < ApplicationRecord
  default_scope { order 'is_focus desc '}
  default_scope { where("sys_flag =1")}
  
  belongs_to :jail

  has_many :news_comments
  has_many :families, :through => :news_comments

  validates :title,    presence: true
  validates :contents, presence: true

#  has_attached_file :image, styles: { medium: '680x400>', thumb: '480x320>' },
#                    default_url: '/images/:style/missing.png'

#  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

#  def image_url
#    image.url(:thumb)
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