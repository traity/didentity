require 'digest'
require 'bitcoin'

class Didentity::BlockchainClient


  def initialize(blockchain)
    @blockchain = blockchain
  end

  def add_reviews(identifier, hashed_reviews)
    txid, rand = blockchain.call(:name_new, identifier)[:result]
    blockchain.call(:name_firstupdate, identifier, rand, hashed_reviews)
  end

  private
  def blockchain
    @blockchain
  end
end
