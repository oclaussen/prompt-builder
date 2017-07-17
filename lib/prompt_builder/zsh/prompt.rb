# encoding: UTF-8
# frozen_string_literal: true

#
# Copyright 2017, Ole Claussen <claussen.ole@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'prompt_builder/status'
require 'prompt_builder/shell/common_dsl'
require 'prompt_builder/shell/segment'
require 'prompt_builder/zsh/dsl'

module PromptBuilder
  module Zsh
    class Prompt < Status
      include Shell::CommonDSL
      include Zsh::DSL

      def initialize(*args, &blk)
        @prompts = {}
        super
      end

      def prompt(name = :default, *args, &blk)
        @prompts[lookup_variable_name(name)] = self.class.new(*args, &blk)
      end

      def segment(*args, **kwargs)
        super(Shell::Segment.new(*args, **kwargs, noprint: method(:noprint)))
      end

      def to_s
        default_variable = lookup_variable_name(:default)
        @prompts[default_variable] = self unless @prompts.key?(default_variable)
        lines = []
        @prompts.each do |name, p|
          p.script "export #{name}=$'#{p.compile}'"
          lines += p.lines
        end
        lines.join "\n"
      end

      def noprint(text)
        "%{#{text}%}"
      end

      def lookup_variable_name(name)
        {
          'PS1' => %i[default primary left],
          'PS2' => %i[secondary],
          'PS3' => %i[select],
          'PS4' => %i[trace],
          'RPS1' => %i[right],
          'SPROMPT' => %i[spelling]
        }.find(proc { super }) { |_, names| names.include? name }[0]
      end
    end
  end
end
