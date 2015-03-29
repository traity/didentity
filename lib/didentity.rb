require 'json'
require 'bitcoin'
require 'didentity/version'

module Didentity
  autoload :Ledger,           'didentity/ledger'
  autoload :Review,           'didentity/review'
  autoload :SignedReview,     'didentity/signed_review'
  autoload :Rating,           'didentity/rating'
  autoload :ModelError,       'didentity/model_error'
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
