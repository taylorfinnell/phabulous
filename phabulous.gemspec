# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phabulous/version'

Gem::Specification.new do |spec|
  spec.name          = 'phabulous'
  spec.version       = Phabulous::VERSION
  spec.authors       = ['Taylor Finnell']
  spec.email         = ['tmfinnell@gmail.com']
  spec.summary       = %q{Provides access to Phabricator}
  spec.description   = %q{Provides access to Phabricator}
  spec.homepage      = 'http://github.com/taylorfinnell/phabulous'
  spec.license       = 'MIT'

  spec.files         = Dir.glob("lib/**/*.rb")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir.glob("spec/**/*_spec.rb")
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'

  spec.add_dependency 'httparty'
end
