module Didentity
  class Review < Base
    attr_accessor :created_at, :name, :text, :provider, :profile, :picture, :ratings
    validates :created_at, :name, :text, :provider, presence: true
    validates :created_at, numericality: true
    validate  :valid_ratings

    def initialize(args)
      super
      self.ratings = (args['ratings'] || []).map { |rating| Didentity::Rating.new(rating)}
    rescue NoMethodError => e
      raise Didentity::ModelError, e.message
    end

    def as_json(options = {})
     super(name: name,
           text: text,
           provider: provider,
           profile: profile,
           picture: picture,
           ratings: ratings,
           created_at: created_at)
    end

    def valid_ratings
      return true if self.ratings.blank?
      self.ratings.each do |rating|
        errors.add(:ratings) if !rating.valid?
      end
    end
  end
end
