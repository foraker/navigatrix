# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'navigatrix/version'

Gem::Specification.new do |spec|
  spec.name          = "navigatrix"
  spec.version       = Navigatrix::VERSION
  spec.authors       = ["Ben Eddy"]
  spec.email         = ["bae@foraker.com"]
  spec.description   = %q{Navigation Generation}
  spec.summary       = %q{Navigation generation for Rails and Sinatra}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "i18n"
  spec.add_dependency "activesupport"
  spec.add_dependency "actionpack"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.0"
  spec.add_development_dependency "capybara"
end
