require 'spec_helper'

describe Didentity::Rating do

  before { @rating = Didentity::Rating.new(load_fixture('reviews_airbnb.json')[0]['ratings'][0]) }

  describe 'attributes validation' do
    it 'is valid with valid attributes' do
      expect(@rating).to be_valid
    end

    it 'is valid without a version' do
      @rating.version = nil
      expect(@rating).to be_valid
    end

    it 'is not valid with an invalid score' do
      @rating.score = nil
      expect(@rating).not_to be_valid
    end
  end
end
