require 'active_model'

class Didentity::Rating
  include ActiveModel::Model
  attr_accessor :version, :score, :provider
  validates :score, numericality: true
  validates :version, format: { with: /\A\d+(.\d+(.\d+)?)?\z/ }, unless: -> { self.version.blank? }
end
