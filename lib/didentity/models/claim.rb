module Didentity
  class Claim < Base
    attr_accessor :id, :text, :user_id, :transaction_id, :created_at

    def as_json(options = {})
      super(id: id,
            text: text,
            user_id: user_id,
            transaction_id: transaction_id,
            created_at: created_at,
            format_version: format_version)
    end
  end
end
