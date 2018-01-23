
require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'csv'
require 'roo'
require 'roo-xls'
require 'spreadsheet'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Prison
  class Application < Rails::Application
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', 
            :headers => :any, 
            :methods => [:get, :post, :delete, :put, :patch, :options, :head]
      end
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end
    #config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :sidekiqsss

    config.logger = Logger.new(STDOUT)

    config.active_job.queue_adapter = :sidekiq

    ActionMailer::Base.delivery_method = :smtp

    ActionMailer::Base.smtp_settings = { 
      :address => 'smtp.qq.com', 
      :port => 25,
      :domain => 'qq.com',
      :user_name => '2681636355@qq.com', 
      :password => 'cqwdbxdmmcpcebcc',
      :authentication => :login, 
      :enable_starttls_auto => true
     }

  end
end
