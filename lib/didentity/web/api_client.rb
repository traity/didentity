require 'oauth2'
module Didentity
  class ApiClient
    VERSION = '1.0'

    def initialize(endpoint)
      @client = OAuth2::Client.new(:traity, nil, site: endpoint, max_redirects: 0) do |stack|
        stack.request :multipart
        stack.request :url_encoded
        stack.adapter  Faraday.default_adapter
      end
    end

    def request(token, method, path, params = {})
      url = "/#{VERSION}#{path}"
      headers = { 'Content-type' => 'application/json' }
      body = params.to_json
      format_response access_token(token).request(method, url, body: body, headers: headers)
    end

    private
    def format_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def client
      @client
    end

    def access_token(token)
      OAuth2::AccessToken.new(client, token)
    end
  end
end
