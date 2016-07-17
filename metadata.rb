# encoding: UTF-8
# frozen_string_literal: true

$LOAD_PATH.unshift(
  *Dir[File.expand_path('../../files/default/vendor/gems/**/lib', __FILE__)]
)
require 'prompt_builder/version'

name 'prompt-builder'
description 'A ruby DSL to build shell prompts'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version ::PromptBuilder::VERSION

maintainer 'Ole Claussen'
maintainer_email 'claussen.ole@gmail.com'
source_url 'https://github.com/oclaussen/prompt-builder'
issues_url 'https://github.com/oclaussen/prompt-builder/issues'
license 'Apache 2.0'
