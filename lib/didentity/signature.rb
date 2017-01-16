module Didentity
  module Signature
    def sign(payload, priv_key, digest = true)
      key     = Bitcoin::Key.new(priv_key)
      payload = Digest::SHA2.hexdigest(payload) if digest
      key.sign_message(payload)
    end

    def address_from_private_key(priv_key)
      Bitcoin::Key.new(priv_key).addr
    end
  end
end
