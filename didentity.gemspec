# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'didentity/version'

Gem::Specification.new do |spec|
  spec.name          = "didentity"
  spec.version       = Didentity::VERSION
  spec.authors       = ["Borja Martin"]
  spec.email         = ["borja@traity.com"]
  spec.summary       = "Library to store reputation information in the blockchain"
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "bitcoin-ruby", "0.0.6"
  spec.add_dependency "activemodel",  "~> 4.2.0"
  spec.add_dependency "faraday",      "0.9.0"
  spec.add_dependency "aes",          "0.5.0"
  spec.add_dependency "ffi",          "1.9.6"
  spec.add_dependency "rack-flash3"
  spec.add_dependency "omniauth"
  spec.add_dependency "omniauth-traity"
  spec.add_dependency "omniauth-ebay"
  spec.add_dependency "omniauth-linkedin"
end
