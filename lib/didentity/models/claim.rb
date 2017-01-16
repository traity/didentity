module Didentity
  class Claim < Base
    attr_accessor :id, :text, :user_id, :transaction_id, :created_at, :version

    def as_json(options = {})
      {
        id: id,
        text: text,
        user_id: user_id,
        transaction_id: transaction_id,
        created_at: created_at,
        version: version
      }
    end
  end
end
