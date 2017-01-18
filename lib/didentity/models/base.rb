require 'active_model'

module Didentity
  class Base
    include ActiveModel::Model

    attr_accessor :format_version
    validates :format_version, format: { with: /\A\d+(.\d+(.\d+)?)?\z/ }

    def validate!
      raise Didentity::ModelError, self.errors.full_messages.to_json if self.invalid?
    end

    def as_json(options = {})
      options.merge(format_version: format_version)
    end
  end
end
