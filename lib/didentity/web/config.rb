if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

module Didentity
  module Config
    extend self

    def app_prefix
    end

    def traity
      {
        app_key:    ENV['TRAITY_APP_KEY'],
        app_secret: ENV['TRAITY_APP_SECRET'],
        host:       (ENV['TRAITY_HOST'] || 'https://traity.com'),
        client_options: {
          site: ENV['TRAITY_CLIENT_SITE'],
          authorize_url: ENV['TRAITY_CLIENT_AUTHORIZE_URL']
        }
      }
    end

    def ebay
      {
        runame: ENV['EBAY_RUNAME'],
        devid:  ENV['EBAY_DEVID'],
        appid:  ENV['EBAY_APPID'],
        certid: ENV['EBAY_CERTID'],
        env:    (ENV['EBAY_ENV'] || :sandbox).to_sym
      }
    end
  end
end
