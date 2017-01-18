require 'digest'
require 'bitcoin'

class Didentity::BlockchainClient

  def initialize(blockchain)
    @blockchain = blockchain
  end

  def store_documents(identifier, documents)
    txid, rand = blockchain_call(:name_new, identifier)[:result]
    blockchain_call(:name_firstupdate, identifier, rand, documents)[:result]
  end

  private

  def blockchain_call(method, *args)
    blockchain.call(method, *args).tap do |response|
      raise Didentity::Error, response[:error] if response[:error]
    end
  end

  def blockchain
    @blockchain
  end
end
