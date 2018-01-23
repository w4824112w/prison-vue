require "#{Rails.root}/lib/yunxin"

class SendSmsWorker
  include Sidekiq::Worker
  include YunXin

  def perform(*args)
    
  end
  
end
