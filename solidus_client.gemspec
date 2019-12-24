# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'solidus_client/version'

Gem::Specification.new do |s|
  s.name = 'solidus_client'
  s.version = SolidusClient::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.0'
  s.authors = ['Team Nebulab']
  s.description = 'Solidus eCommerce API Ruby client'

  s.email = 'hello@nebulab.it'
  s.files = `git ls-files assets exe lib LICENSE.txt README.md`.split($RS)
  s.bindir = 'exe'
  s.executables = ['solidus']
  s.require_path = 'lib'
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  s.homepage = 'https://github.com/nebulab/solidus_client'
  s.licenses = ['MIT']
  s.summary = 'Solidus API Ruby client'

  s.add_runtime_dependency('faraday', '~> 0.17')
  s.add_runtime_dependency('faraday_middleware', '~> 0.13')

  s.add_development_dependency('rake', '~> 13.0')
  s.add_development_dependency('rspec', '~> 3.9')
end
