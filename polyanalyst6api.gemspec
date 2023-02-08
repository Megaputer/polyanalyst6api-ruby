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

  spec.add_dependency 'addressable', '~> 2.8', '>= 2.8.1'
  spec.add_dependency 'json', '~> 2.6', '>= 2.6.2'
  spec.add_dependency 'rest-client', '~> 2.1'
  spec.add_dependency 'clientus', '~> 0.1.1.dev'

  spec.add_development_dependency 'bundler', '~> 2.3', '>= 2.3.26'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.39'
  spec.add_development_dependency 'yard', '~> 0.9.28'
end
