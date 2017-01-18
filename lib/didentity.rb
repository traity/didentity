require 'json'
require 'bitcoin'
require 'active_support/json'
require_relative './didentity/version'

module Didentity
  autoload :Signature,        'didentity/signature'
  autoload :Ledger,           'didentity/ledger'
  autoload :Base,             'didentity/models/base'
  autoload :Review,           'didentity/models/review'
  autoload :Transaction,      'didentity/models/transaction'
  autoload :Claim,            'didentity/models/claim'
  autoload :SignedDocument,   'didentity/models/signed_document'
  autoload :Rating,           'didentity/models/rating'
  autoload :Error,            'didentity/error'
  autoload :ModelError,       'didentity/models/error'
  autoload :NamecoinClient,   'didentity/namecoin_client'
  autoload :BlockchainClient, 'didentity/blockchain_client'
  autoload :Web,              'didentity/web/web'

  def self.ledger(endpoint = nil)
    namecoin_client   = Didentity::NamecoinClient.new(endpoint)
    blockchain_client = Didentity::BlockchainClient.new(namecoin_client)
    Didentity::Ledger.new(blockchain_client)
  end
end

Bitcoin.network = :namecoin
