require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fesdy
  class Application < Rails::Application
    # UTC+09:00
    config.time_zone = 'Tokyo'
    # japanese
    config.i18n.default_locale = :ja
  end
end
