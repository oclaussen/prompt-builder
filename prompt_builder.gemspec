# encoding: UTF-8
# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name         = 'prompt_builder'
  spec.version      = '0.0.1'
  spec.author       = 'Ole Claussen'
  spec.email        = 'claussen.ole@gmail.com'
  spec.license      = 'Apache 2.0'
  spec.summary      = 'A ruby DSL to build shell prompts'
  spec.description  = 'A ruby DSL to build shell prompts'
  spec.homepage     = 'https://github.com/oclaussen/prompt_builder'

  spec.required_ruby_version = '>= 2.0'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'rubocop', '~> 0.37'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'yard', '~> 0.8'
end
