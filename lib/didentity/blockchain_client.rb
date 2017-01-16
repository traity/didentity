require 'digest'
require 'bitcoin'

class Didentity::BlockchainClient

  def initialize(blockchain)
    @blockchain = blockchain
  end

  def store_documents(identifier, documents)
    txid, rand = blockchain.call(:name_new, identifier)[:result]
    blockchain.call(:name_firstupdate, identifier, rand, documents)
  end

  private
  def blockchain
    @blockchain
  end
end
