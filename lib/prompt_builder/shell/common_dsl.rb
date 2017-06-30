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

require 'prompt_builder/shell/constants'
require 'prompt_builder/shell/segment'

module PromptBuilder
  module Shell
    module CommonDSL
      def clear
        Segment.new(noprint('\033[0m'))
      end

      def colored(*args, **kwargs)
        Segment.new(*args, **kwargs, noprint: method(:noprint))
      end

      FOREGROUNDS[:enable].each do |name, _|
        define_method name do |*args|
          colored(*args, foreground: name)
        end
      end

      BACKGROUNDS[:enable].each do |name, _|
        define_method "#{name}_background".to_sym do |*args|
          colored(*args, background: name)
        end
      end

      ATTRIBUTES[:enable].each do |name, _|
        define_method name do |*args|
          colored(*args, attribute: name)
        end
      end
    end
  end
end
