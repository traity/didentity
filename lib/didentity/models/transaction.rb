module Didentity
  class Transaction < Base
    attr_accessor :id, :description, :user1_id, :user2_id, :started_at

    def as_json(options = {})
     super(id: id,
          description: description,
          user1_id: user1_id,
          user2_id: user2_id,
          started_at: started_at)
    end
  end
end
