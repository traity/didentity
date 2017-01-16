require 'spec_helper'

describe Didentity::BlockchainClient do
  let(:blockchain_client) { Didentity::BlockchainClient.new(namecoin_client) }
  let(:namecoin_client)   { double('NameCoin') }

  before do
    allow(namecoin_client).to receive(:call).with(:name_new, DUMMY_IDENTIFIER).and_return(DUMMY_NAME_NEW_RESPONSE)
    allow(namecoin_client).to receive(:call).with(:name_firstupdate, DUMMY_IDENTIFIER, DUMMY_NAME_NEW_RAND, DUMMY_HASHED_REVIEW).and_return(DUMMY_NAME_FIRSTUPDATE_RESPONSE)
  end

  it {
    expect(blockchain_client.store_documents(DUMMY_IDENTIFIER, DUMMY_HASHED_REVIEW)).to eq(DUMMY_NAME_FIRSTUPDATE_RESPONSE)
  }
end
