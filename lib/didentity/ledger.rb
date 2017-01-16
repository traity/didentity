require 'bitcoin'
require 'active_support/core_ext/string/inflections'

module Didentity
  class Ledger
    include Signature

    REVIEWS_KEY     = 'reviews'.freeze
    TRANSACTION_KEY = 'transaction'.freeze
    CLAIM_KEY       = 'claim'.freeze

    attr_reader :blockchain_client

    def initialize(blockchain_client)
      @blockchain_client = blockchain_client
    end

    def store_documents(type, documents, priv_key, priv_keys = [])
      documents = documents.is_a?(Array) ? documents : [documents]
      signed_documents = sign_documents(type, documents, priv_keys + [priv_key])
      hashed_documents = hash_documents(signed_documents)
      value            = stored_value(hashed_documents, priv_key)
      identifier       = identifier_for(type, signed_documents, priv_key)
      response         = blockchain_client.store_documents(identifier, value.to_json)
      { response: response, identifier: identifier, value: value }
    end

    private

    def sign_documents(type, documents, priv_keys)
      signed_documents = documents.map do |document|
        obj = class_from_type(type).new(document)
        SignedDocument.new(obj, priv_keys)
      end
    end

    def hash_documents(documents)
      Digest::SHA2.hexdigest(documents.to_json)
    end

    def stored_value(hash, priv)
      { hash: hash, signature: sign(hash, priv, false) }
    end

    def class_from_type(type)
      "Didentity::#{type.to_s.classify}".constantize
    end

    def identifier_for(type, documents, priv_key)
      suffix = case type
      when :review
        "#{REVIEWS_KEY}_#{priv_key}"
      when :transaction
        "#{TRANSACTION_KEY}_#{documents.first.id}"
      when :claim
        "#{CLAIM_KEY}_#{documents.first.id}"
      end

      "#{address_from_private_key(priv_key)}_#{Bitcoin.hash160(suffix)}"
    end
  end
end
