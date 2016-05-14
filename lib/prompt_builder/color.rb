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

require 'prompt_builder/constants'

module PromptBuilder
  class Color
    attr_reader :term
    attr_reader :rgb

    def initialize(term, rgb)
      @term = term
      @rgb = rgb
    end

    def to_i
      @term
    end

    def to_s
      @rgb
    end

    class InvalidColor < StandardError
      def initialize(name)
        super "Unable to create a color from specification: #{name}."
      end
    end

    class << self
      def from_spec(spec)
        if spec.is_a?(Color)
          spec
        elsif spec.is_a?(String)
          from_string spec
        elsif spec.is_a?(Integer)
          from_int spec
        else
          raise InvalidColor, color
        end
      end

      private

      def from_string(spec)
        if spec =~ /^#?(0x)?([0-9a-fA-F]{6})$/
          rgb = /^#?(0x)?([0-9a-fA-F]{6})$/.match(spec)[2].upcase
          term = TERMCOLORS.find_index(find_nearest_color_code(rgb))
        elsif spec =~ /^([0-9]{1,3})$/
          term = /^([0-9]{1,3})$/.match(spec)[1].to_i
          rgb = TERMCOLORS[term]
        else
          raise InvalidColor, spec
        end
        Color.new term, rgb
      end

      def from_int(spec)
        raise InvalidColor, color unless 0 <= spec && spec <= 255
        Color.new spec, TERMCOLORS[term]
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def find_nearest_color_code(rgbcolor)
        steps = [0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF]
        m = /(.{2})(.{2})(.{2})/.match(rgbcolor)
        values = [m[1], m[2], m[3]]
        values.map! { |part| part.to_i(16) }
        values.map! do |part|
          value = nil
          steps.each_with_index do |step, index|
            next if index == steps.length - 1
            smaller = step
            bigger = steps[index + 1]
            next unless smaller <= part && part <= bigger
            left = part - smaller
            right = bigger - part
            value = (left < right ? smaller : bigger).to_s(16)
            break
          end
          value
        end
        values.map! { |part| part.to_s.rjust(2, '0') }
        values.join.upcase
      end
    end
  end
end
