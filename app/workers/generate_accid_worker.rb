require "#{Rails.root}/lib/yunxin"

class GenerateAccidWorker
  include Sidekiq::Worker
  include YunXin

  def perform(*args)
    generate_accid(args[0], args[1], args[2])
  end
  
end
