require File.expand_path('../boot', __FILE__)

require 'csv'

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module HQ
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Moscow'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:ru, :en]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :ru

    config.autoload_paths += Dir["#{config.root}/app/reports"]
    config.autoload_paths += Dir["#{config.root}/lib"]

    config.assets.paths << "#{Rails.root}/app/assets/docs"

    require "#{Rails.root}/lib/custom_public_exceptions"
    config.exceptions_app = CustomPublicExceptions.new(Rails.public_path)
  end
end
