require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'haml'
require 'omniauth'
require 'omniauth-traity'
require 'rack-flash'
require 'rack/ssl-enforcer'
require 'rack/session/cookie'
require 'didentity'
require_relative 'config'
require_relative 'api_client'
require_relative 'asset_pipeline'
require_relative 'helpers'
require_relative 'routes'

module Didentity
  class Web < Sinatra::Base
    include Routes

    set :app_prefix, ''

    register AssetPipeline

    helpers do
      include Sinatra::ContentFor
      include Helpers
      include Routes
    end

    use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
    use Rack::Flash
    use Rack::SslEnforcer
    use OmniAuth::Builder do
      provider :traity, Didentity::Config.traity[:app_key],
                        Didentity::Config.traity[:app_secret],
                        client_options: Didentity::Config.traity[:client_options]
    end

    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      @random_priv    = ledger.random_priv
      @random_address = ledger.address_from_priv(@random_priv)
      @sample_reviews = sample_reviews
      haml :'index'
    end

    post '/reviews' do
      begin
        reviews         = JSON.parse(params[:reviews])
        @random_priv    = params[:random_priv]
        @random_address = ledger.address_from_priv(@random_priv)
        @signed_reviews = ledger.sign_reviews(reviews, [@random_priv])
        @stored_reviews = ledger.store_reviews('sample', reviews, @random_priv)
        # @transaction    = namecoin_client.call(:gettransaction, @stored_reviews[:response][:result])[:result]
        @transaction    = {}
        haml :'sample_reviews'
      rescue Didentity::ModelError => e
        flash[:errors] = e.message
        redirect web_path('/')
      end
    end

    get '/auth/traity/callback' do
      session[:auth] = request.env['omniauth.auth'].credentials
      redirect web_path('/connect-provider')
    end

    get '/connect-provider' do
      haml :'connect_provider'
    end

    get '/reviews/:provider' do
      @reviews     = traity_api_client.request(session[:auth].token, :get, '/me/reviews/signed', provider: params[:provider])
      @transaction = namecoin_client.call(:name_show, @reviews[:identifier])
      haml :imported_reviews
    end

    get '/logout' do
      session.clear
      redirect web_path('/')
    end

    private
    def logged_in?
      session[:auth] && session[:auth].expires_at.to_i >= Time.now.to_i
    end

    def ledger
      @ledger ||= Didentity.ledger(Config.didentity[:endpoint_url])
    end

    def namecoin_client
      @namecoin_client ||= Didentity::NamecoinClient.new(Config.didentity[:endpoint_url])
    end

    def traity_api_client
      @api_client ||= Didentity::ApiClient.new(Config.traity[:client_options][:site])
    end

    def reviews
      if logged_in?
        traity_api_client.request(session[:auth].token, :get, '/me/reviews/signed')
      else
      end
    end

    def sample_reviews
      File.read(File.join(__dir__, '../../../spec/fixtures/reviews_airbnb.json'))
    end
  end
end

