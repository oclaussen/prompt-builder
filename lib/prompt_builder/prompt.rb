# encoding: UTF-8
# frozen_string_literal: true
#
# Copyright 2016, Ole Claussen <claussen.ole@gmail.com>
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

require 'prompt_builder/segment'

module PromptBuilder
  class Prompt
    def initialize(*args)
      @segments = []
      segment(args) unless args.empty?
    end

    def segment(*args, **kwargs)
      @segments << Segment.new(*args, **kwargs, noprint: method(:noprint))
    end

    def to_s
      @segments.map(&:to_s).join
    end

    def noprint(_text)
      raise 'No noprint escape sequence defined for prompt.'
    end
  end
end
