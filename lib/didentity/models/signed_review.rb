require 'active_model'
require 'bitcoin'

class Didentity::SignedReview
  include ActiveModel::Model
  attr_accessor :review, :signatures
  validates :review, :signatures, :presence => true
  validate  :valid_review
  validate  :valid_signatures

  def valid_review
    begin
      review_model = Didentity::Review.new(self.review)
    rescue NoMethodError => e
      raise Didentity::ModelError, e.message
    end
    self.errors.add(:review) if !review_model.is_a?(Didentity::Review) || review_model.invalid?
  end

  def valid_signatures
    signatures.each do |signature|
      self.errors.add(:signatures) unless verify_message(signature['address'], signature['signature'], review.to_json)
    end
  end

  def validate!
    raise Didentity::ModelError, self.errors.full_messages.to_json if self.invalid?
  end

  private
  def verify_message(address, signature, document)
    Bitcoin::Key.verify_message(address, signature, Digest::SHA2.hexdigest(document))
  end
end
