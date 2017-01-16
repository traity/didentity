module Didentity
  class Transaction < Base
    attr_accessor :id, :description, :user1_id, :user2_id, :started_at
  end
end
