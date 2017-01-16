require 'active_support/json'

module Didentity
  class SignedDocument
    include Signature

    def initialize(document, priv_keys)
      document.validate!
      @document  = document
      @priv_keys = priv_keys
    end

    def type
      @document.class
    end

    def as_json(opts = {})
      {
        document: @document.as_json,
        signatures: signatures
      }
    end

    def method_missing(method, *args)
      if @document.respond_to?(method)
        @document.send(method, *args)
      else
        super
      end
    end

    private

    def signatures
      @priv_keys.map do |priv_key|
        { address: address_from_private_key(priv_key), signature: sign(@document.to_json, priv_key) }
      end
    end
  end
end
