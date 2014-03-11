# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_eancom/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-eancom"
  spec.version       = EANCOM::VERSION
  spec.authors       = ["David Bennett"]
  spec.email         = ["davidbennett@bravevision.com"]
  spec.summary       = "Translates EANCOM to/from Ruby Objects"
  spec.description   = "Translates EANCOM to/from Ruby Objects"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'edi4r'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
