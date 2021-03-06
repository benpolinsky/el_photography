require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ElPhotography
  class Application < Rails::Application

    config.autoload_paths += %W( 
    #{config.root}/lib 
    #{config.root}/app/validators 
    #{config.root}/app/services 
    #{config.root}/app/view_models 
    #{config.root}/app/payment_processors
    #{config.root}/app/liquid
    #{config.root}/app/liquid/drops
    #{config.root}/app/uploaders  
    )
    config.time_zone = 'Eastern Time (US & Canada)'
    
    config.active_job.queue_adapter = :sidekiq
  end
end
