# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polyanalyst6api/version'

Gem::Specification.new do |spec|
  spec.name          = 'polyanalyst6api'
  spec.version       = PolyAnalyst6API::VERSION
  spec.authors       = ['Oleg Ivanov']
  spec.email         = ['ivanov@megaputer.ru', 'gluk.main+github@gmail.com']

  spec.summary       = 'A tool for interaction with PolyAnalyst 6.x API'
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'addressable'
  spec.add_dependency "json", ">= 2.3.0"
  spec.add_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
  spec.add_dependency 'clientus'

  spec.add_development_dependency 'bundler', '~> 2.0', '>= 2.0.1'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.63.1'
  spec.add_development_dependency 'yard', '~> 0.9.20'
end
