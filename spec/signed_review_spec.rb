require 'spec_helper'

describe Didentity::SignedReview do
  let('signed_review') { Didentity::SignedReview.new(load_fixture('signed_reviews_airbnb.json')[0]) }

  it { expect(signed_review).to be_valid }

  it 'raises and error if the data was tampered' do
    signed_review.review['profile'] = 'http://example.com/other-profile'
    expect { signed_review.validate! }.to raise_error(Didentity::ModelError)
  end
end
