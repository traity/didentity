require 'faraday'
require 'json'
require 'uri'

class Didentity::NamecoinClient
  DEFAULT_ENDPOINT = 'http://localhost:8336'
  def initialize(endpoint)
    endpoint ||= DEFAULT_ENDPOINT
    uri = URI.parse(endpoint)
    @user     = uri.user
    @password = uri.password
    @endpoint = endpoint
  end

  def call(method, *params)
    connection.basic_auth(user, password)

    response = connection.post do |req|
      req.url '/'
      req.headers['Content-Type'] = 'application/json'
      req.body = request_body(method, params)
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  private
  def connection
    Faraday.new(url: endpoint)
  end

  def request_body(method, params)
    { jsonrpc: '1.0', id: 'traity', method: method, params: params }.to_json
  end

  def endpoint
    @endpoint
  end

  def user
    @user
  end

  def password
    @password
  end
end
