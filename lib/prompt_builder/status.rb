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

module PromptBuilder
  class Status
    attr_reader :lines

    def initialize(*args, &blk)
      @lines = []
      @segments = []
      @decorators = { before: '', after: '', join: '', wrap: nil }
      segment(args) unless args.empty?
      instance_eval(&blk) if block_given?
    end

    def decorate_segments(before: nil, after: nil, join: nil, wrap: nil, &blk)
      @decorators[:before] = before unless before.nil?
      @decorators[:after] = after unless after.nil?
      @decorators[:join] = join unless join.nil?
      @decorators[:wrap] = wrap unless wrap.nil?
      @decorators[:wrap] = blk if block_given?
    end

    def segment(*args)
      @segments += args
    end

    def script(text)
      @lines << text unless @lines.include? text
    end

    def compile
      seg = @segments
      seg = seg.map(&:to_s)
      seg = seg.map(&@decorators[:wrap]) unless @decorators[:wrap].nil?
      seg = seg.join(@decorators[:join])
      @decorators[:before] + seg + @decorators[:after]
    end
  end
end
