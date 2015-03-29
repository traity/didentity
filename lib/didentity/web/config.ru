require 'bundler/setup'
require 'omniauth'
require 'omniauth-traity'
require 'omniauth-ebay'
require 'rack/ssl-enforcer'
require_relative 'web/web'



# use OmniAuth::Builder do
#   provider :traity, Ditentity::Config.traity[:app_key],
#                     Ditentity::Config.traity[:app_secret],
#                     client_options: Ditentity::Config.traity[:client_options]
# 
#   provider :ebay,   Ditentity::Config.ebay[:runame], Ditentity::Config.ebay[:devid],
#                     Ditentity::Config.ebay[:appid],  Ditentity::Config.ebay[:certid],
#                     0, :sandbox, OmniAuth::Strategies::Ebay::AuthType::Simple
# end


run Ditentity::Web
