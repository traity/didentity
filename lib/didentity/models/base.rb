require 'active_model'

module Didentity
  class Base
    include ActiveModel::Model

    attr_accessor :version
    validates :version, format: { with: /\A\d+(.\d+(.\d+)?)?\z/ }

    def validate!
      raise Didentity::ModelError, self.errors.full_messages.to_json if self.invalid?
    end
  end
end
