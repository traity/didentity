require 'spec_helper'

describe Didentity::Review do

  before { @review = Didentity::Review.new(load_fixture('reviews_airbnb.json')[0]) }

  describe 'attributes validation' do
    it { expect(@review).to be_valid }

    it 'is not valid without a name' do
      @review.name = nil
      expect(@review).not_to be_valid
    end

    it 'is not valid without a created_at' do
      @review.created_at = nil
      expect(@review).not_to be_valid
    end

    it 'is not valid without a text' do
      @review.text = nil
      expect(@review).not_to be_valid
    end

    it 'is not valid without a provider' do
      @review.provider = nil
      expect(@review).not_to be_valid
    end

    it 'is not valid without a version' do
      @review.format_version = nil
      expect(@review).not_to be_valid
    end

    it 'is not valid with a not numeric created_at' do
      @review.created_at = '2015-01-27T10:59:29.742Z'
      expect(@review).not_to be_valid
    end

    it 'is not valid with a version that does not follow the defined pattern' do
      @review.format_version = '1..0.0'
      expect(@review).not_to be_valid
    end

    it 'is not valid with invalid ratings' do
      @review.ratings = [Didentity::Rating.new(score: nil)]
      expect(@review).not_to be_valid
    end
  end

end
