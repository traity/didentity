if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

module Didentity
  module Config
    extend self

    def didendity
      {
        endpoint_url: ENV['DIDENTITY_ENDPOINT_URL']
      }
    end

    def traity
      {
        app_key:    ENV['TRAITY_APP_KEY'],
        app_secret: ENV['TRAITY_APP_SECRET'],
        host:       (ENV['TRAITY_HOST'] || 'https://traity.com'),
        client_options: {
          site: (ENV['TRAITY_CLIENT_SITE'] || 'https://api.traity.com'),
          authorize_url: ENV['TRAITY_CLIENT_AUTHORIZE_URL']
        }
      }
    end
  end
end
