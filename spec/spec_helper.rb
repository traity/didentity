require 'didentity'
require 'byebug'

require_relative 'dummies'

module Helpers
  def load_fixture(file)
    JSON.parse(File.read(File.join(__dir__, "/fixtures/#{file}")))
  end
end

RSpec.configure do |config|
  config.include Helpers
end
