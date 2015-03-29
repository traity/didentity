require 'spec_helper'
describe Didentity::Ledger do
  let(:blockchain_client) { double('BlockchainClient', add_reviews: true) }
  let(:ledger)    { Didentity::Ledger.new(blockchain_client) }
  let(:privs)     { [ DUMMY_PRIV_KEY ] }
  let(:user_priv) { privs.first }
  let(:reviews)   { load_fixture('reviews_airbnb.json') }
  let(:provider)  { 'airbnb' }
  let(:signed_reviews) { ledger.sign_reviews(reviews, privs) }

  it {
    expect(signed_reviews.map { |review| review['review']}).to eq(reviews)
  }

  it 'signs the reviews' do
    signed_reviews.each do |signed_review|
      signed_review['signatures'].each do |signature|
        expect(Bitcoin::Key.verify_message(signature['address'], signature['signature'], Digest::SHA2.hexdigest(signed_review[:review].to_json)))
      end
    end
  end

  it 'generates the hash of the reviews' do
    expect(ledger.hash_reviews(signed_reviews)).to eq Digest::SHA2.hexdigest(signed_reviews.to_json)
  end

  xit 'stores the reviews' do
    allow(ledger).to receive(:hash_reviews).and_return(DUMMY_HASHED_REVIEW)
    ledger.store_reviews(provider, reviews, user_priv)
    expect(blockchain_client).to have_received(:add_reviews).with(DUMMY_IDENTIFIER, DUMMY_HASHED_REVIEW)
  end

  private
  def address(priv)
    Bitcoin::Key.new(priv).addr
  end
end
