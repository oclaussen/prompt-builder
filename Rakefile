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

task default: %i[clean rubocop spec build]
