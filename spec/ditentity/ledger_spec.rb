require 'spec_helper'

describe Didentity::Ledger do
  let(:blockchain_client) { double('BlockchainClient', store_documents: true) }
  let(:ledger)            { Didentity::Ledger.new(blockchain_client) }
  let(:priv_keys)         { [DUMMY_PRIV_KEY] }
  let(:priv_key)          { priv_keys.first }

  shared_examples 'stored blockchain documents' do
    let(:blockchain_docs)   { ledger.store_documents(type, docs, priv_key) }
    it { expect(blockchain_docs[:response]).to eq(true) }
    it do
      expect(verify_message(blockchain_docs[:value][:signature], blockchain_docs[:value][:hash])).to be
    end
  end

  describe 'reviews' do
    let(:type) { :review }
    let(:docs) { load_fixture('reviews_airbnb.json') }
    it_behaves_like 'stored blockchain documents'
  end

  describe 'transaction' do
    let(:type) { :transaction }
    let(:docs) { load_fixture('transaction.json') }
    it_behaves_like 'stored blockchain documents'
  end

  describe 'claim' do
    let(:type) { :claim }
    let(:docs) { load_fixture('claim.json') }
    it_behaves_like 'stored blockchain documents'
  end

  def verify_message(signature, message)
    Bitcoin::Key.new(priv_key).verify_message(signature, message)
  end
end
