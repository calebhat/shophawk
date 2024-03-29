require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Shophawk
  class Application < Rails::Application

    #load enviroment variables from defined files
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'env_variable_secrets.yml')
      YAML.load(File.open(env_file)).each do |key, value|
      ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
    config.autoload_paths += %W(#{config.root}/lib) #enables use of "resuable.rb" to work with methods accross controllers/models that include "Reusable" module

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.secret_key_base = 'edgertongear'
  end
end
