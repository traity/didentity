require 'json'
module Helpers
  def pretty_json(json)
    json = JSON.parse(json) if json.is_a?(String)
    JSON.pretty_generate(json)
  end
end
