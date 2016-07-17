# encoding: UTF-8
# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rake/clean'
CLEAN.include 'pkg'

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'yard'
YARD::Rake::YardocTask.new(:doc)

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'prompt_builder/version'

desc 'Install gem into cookbook'
task install: [:build] do
  file = File.join('pkg', "prompt_builder-#{::PromptBuilder::VERSION}.gem")
  sh "gem install --install-dir files/default/vendor --no-document #{file}"
end

task default: [:clean, :rubocop, :spec, :build, :install]
