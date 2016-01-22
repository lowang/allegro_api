# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'allegro_api/version'

Gem::Specification.new do |spec|
  spec.name          = "allegro_api"
  spec.version       = AllegroApi::VERSION
  spec.authors       = ["Przemyslaw Wroblewski","Zbigniew Probulski"]
  spec.email         = ["przemyslaw.wroblewski@gmail.com", "zbigniew.probulski@nokaut.pl"]
  spec.summary       = %q{The gem for Allegro API interaction}
  spec.description   = %q{The gem for Allegro API interaction}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "savon", "~> 2.11.0"
  spec.add_dependency "enumerator-memoizing"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "activemodel"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'terminal-notifier-guard'
  spec.add_development_dependency 'pry'
end
