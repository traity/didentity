require 'didentity'
require 'byebug'

DUMMY_ADDRESS           = 'MzgmkqvuhZtVxY7Ni5ytgxRMGF4wtdaD1G'
DUMMY_PRIV_KEY          = 'f278550976dbe8cee36bd9bed2faa4170d8cee467e41b97e7ee557bd407bef7c'
DUMMY_HASHED_REVIEW     = '2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae'
DUMMY_IDENTIFIER        = 'MzgmkqvuhZtVxY7Ni5ytgxRMGF4wtdaD1G_2c7f0b55c7c63a66c8b5ef84702cd2b5d61e7b9f'
DUMMY_NAME_NEW_RESPONSE = { result: ['1e2e7d5a10c80eb1d347a22c450f2373dae55ae473d6c2388b0215a0b13a6a5c','e54def60bdfb807b'] }
DUMMY_NAME_NEW_RAND     = DUMMY_NAME_NEW_RESPONSE[:result][1]
DUMMY_NAME_FIRSTUPDATE_RESPONSE = {result: "1458df0d9e61b416cd954f0e4d250971cce7fe0ad99e6d230f978142b117c065", error:nil }
DUMMY_VALUE             = { }

module Helpers
  def load_fixture(file)
    JSON.parse(File.read(File.join(__dir__, "/fixtures/#{file}")))
  end
end

RSpec.configure do |config|
  config.include Helpers
end
