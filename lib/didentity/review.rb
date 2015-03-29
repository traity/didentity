require 'active_model'

class Didentity::Review
  include ActiveModel::Model
  attr_accessor :created_at, :name, :text, :provider, :profile, :picture, :ratings, :version
  validates :created_at, :name, :text, :provider, :version, :presence => true
  validates :created_at, numericality: true
  validates :version, format: { with: /\A\d+(.\d+(.\d+)?)?\z/ }
  validate  :valid_ratings

  def initialize(args)
    super
    self.ratings = (args['ratings'] || []).map { |rating| Didentity::Rating.new(rating)}
  rescue NoMethodError => e
    raise Didentity::ModelError, e.message
  end

  def valid_ratings
    return true if self.ratings.blank?
    self.ratings.each do |rating|
      errors.add(:ratings) if !rating.valid?
    end
  end

  def validate!
    raise Didentity::ModelError, self.errors.full_messages.to_json if self.invalid?
  end
end
