require 'bitcoin'

class Didentity::Ledger
  REVIEWS_KEY = 'reviews'

  attr_reader :blockchain_client

  def initialize(blockchain_client)
    @blockchain_client = blockchain_client
  end

  def sign_reviews(reviews, privs)
    reviews.map { |review| sign_review(review, privs) }
  end

  def hash_reviews(signed_reviews)
    validate_signed_reviews(signed_reviews)
    Digest::SHA2.hexdigest(signed_reviews.to_json)
  end

  def store_signed_reviews(provider, signed_reviews, user_priv)
    identifier = reviews_identifier(provider, user_priv)
    hash       = hash_reviews(signed_reviews)
    value      = stored_value(hash, user_priv)
    response   = blockchain_client.add_reviews(identifier, value.to_json)
    { response: response, identifier: identifier, value: value }
  end

  def store_reviews(provider, reviews, user_priv, privs = [])
    privs      = (privs + [user_priv]).uniq
    hash       = hash_reviews(sign_reviews(reviews, privs))
    identifier = reviews_identifier(provider, user_priv)
    value      = stored_value(hash, user_priv)
    response   = blockchain_client.add_reviews(identifier, value.to_json)
    { response: response, identifier: identifier, value: value }
  end

  def reviews_identifier(provider, priv)
    key              = Bitcoin::Key.new(priv)
    address          = key.addr
    hashed_signature = Bitcoin.hash160("#{REVIEWS_KEY}_#{provider}_#{priv}")
    "#{address}_#{hashed_signature}"
  end

  def random_priv
    Bitcoin::Key.generate.priv
  end

  def address_from_priv(priv)
    Bitcoin::Key.new(priv).addr
  end

  private
  def stored_value(hash, priv)
    { hash: hash, signature: sign(hash, user_priv, false) }
  end

  def sign_review(review, privs)
    validate_review(review)
    {
      'review' => review,
      'signatures' => signatures(review, privs)
    }
  end

  def signatures(review, privs)
    privs.map do |priv|
      {
        'address'   => address_from_private(priv),
        'signature' => sign(review.to_json, priv)
      }
    end
  end

  def sign(payload, priv, digest = true)
    key = Bitcoin::Key.new(priv)
    payload = Digest::SHA2.hexdigest(payload) if digest
    key.sign_message(payload)
  end

  def address_from_private(priv)
    Bitcoin::Key.new(priv).addr
  end

  def pub_from_private(priv)
    Bitcoin::Key.new(priv).priv
  end

  def validate_signed_reviews(signed_reviews)
    signed_reviews.each { |signed_review| validate_signed_review(signed_review) }
  end

  def validate_signed_review(signed_review)
    Didentity::SignedReview.new(signed_review).validate!
  end

  def validate_review(review)
    Didentity::Review.new(review).validate!
  end

  def blockchain_client
    @blockchain_client
  end
end
