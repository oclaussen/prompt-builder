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
  module Vim
    class Segment
      def initialize(*args, highlight: nil)
        @children = []
        @highlight = highlight
        args.each do |arg|
          @children << arg if arg.is_a?(String) || arg.is_a?(Segment)
        end
      end

      attr_reader :highlight

      def highlight?
        !@highlight.nil? || @children.any? do |child|
          child.is_a?(Segment) && child.highlight?
        end
      end

      def colored(highlight: nil)
        @highlight = highlight unless highlight.nil?
        self
      end

      def highlight(group)
        colored(highlight: group)
      end

      def to_s
        segments = []
        segments << "%##{@highlight}#" unless @highlight.nil?
        segments << @children.map(&:to_s)
        segments << "%*" unless @highlight.nil?
        segments.join
      end
    end
  end
end
