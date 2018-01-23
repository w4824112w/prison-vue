require "#{Rails.root}/lib/yunxin"

class SendMessageWorker
  include Sidekiq::Worker
  include YunXin

  def perform(*args)
    logger.info send_message(args[0], args[1], args[2])
  end
  
end
