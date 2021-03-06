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
          raise InvalidColor, spec
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
        raise InvalidColor, spec unless 0 <= spec && spec <= 255
        Color.new spec, TERMCOLORS[spec]
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

    TERMCOLORS = %w[
      000000 800000 008000 808000 000080 800080 008080 C0C0C0
      808080 FF0000 00FF00 FFFF00 0000FF FF00FF 00FFFF FFFFFF
      000000 00005F 000087 0000AF 0000D7 0000FF 005F00 005F5F
      005F87 005FAF 005FD7 005FFF 008700 00875F 008787 0087AF
      0087D7 0087FF 00AF00 00AF5F 00AF87 00AFAF 00AFD7 00AFFF
      00D700 00D75F 00D787 00D7AF 00D7D7 00D7FF 00FF00 00FF5F
      00FF87 00FFAF 00FFD7 00FFFF 5F0000 5F005F 5F0087 5F00AF
      5F00D7 5F00FF 5F5F00 5F5F5F 5F5F87 5F5FAF 5F5FD7 5F5FFF
      5F8700 5F875F 5F8787 5F87AF 5F87D7 5F87FF 5FAF00 5FAF5F
      5FAF87 5FAFAF 5FAFD7 5FAFFF 5FD700 5FD75F 5FD787 5FD7AF
      5FD7D7 5FD7FF 5FFF00 5FFF5F 5FFF87 5FFFAF 5FFFD7 5FFFFF
      870000 87005F 870087 8700AF 8700D7 8700FF 875F00 875F5F
      875F87 875FAF 875FD7 875FFF 878700 87875F 878787 8787AF
      8787D7 8787FF 87AF00 87AF5F 87AF87 87AFAF 87AFD7 87AFFF
      87D700 87D75F 87D787 87D7AF 87D7D7 87D7FF 87FF00 87FF5F
      87FF87 87FFAF 87FFD7 87FFFF AF0000 AF005F AF0087 AF00AF
      AF00D7 AF00FF AF5F00 AF5F5F AF5F87 AF5FAF AF5FD7 AF5FFF
      AF8700 AF875F AF8787 AF87AF AF87D7 AF87FF AFAF00 AFAF5F
      AFAF87 AFAFAF AFAFD7 AFAFFF AFD700 AFD75F AFD787 AFD7AF
      AFD7D7 AFD7FF AFFF00 AFFF5F AFFF87 AFFFAF AFFFD7 AFFFFF
      D70000 D7005F D70087 D700AF D700D7 D700FF D75F00 D75F5F
      D75F87 D75FAF D75FD7 D75FFF D78700 D7875F D78787 D787AF
      D787D7 D787FF D7AF00 D7AF5F D7AF87 D7AFAF D7AFD7 D7AFFF
      D7D700 D7D75F D7D787 D7D7AF D7D7D7 D7D7FF D7FF00 D7FF5F
      D7FF87 D7FFAF D7FFD7 D7FFFF FF0000 FF005F FF0087 FF00AF
      FF00D7 FF00FF FF5F00 FF5F5F FF5F87 FF5FAF FF5FD7 FF5FFF
      FF8700 FF875F FF8787 FF87AF FF87D7 FF87FF FFAF00 FFAF5F
      FFAF87 FFAFAF FFAFD7 FFAFFF FFD700 FFD75F FFD787 FFD7AF
      FFD7D7 FFD7FF FFFF00 FFFF5F FFFF87 FFFFAF FFFFD7 FFFFFF
      080808 121212 1C1C1C 262626 303030 3A3A3A 444444 4E4E4E
      585858 626262 6C6C6C 767676 808080 8A8A8A 949494 9E9E9E
      A8A8A8 B2B2B2 BCBCBC C6C6C6 D0D0D0 DADADA E4E4E4 EEEEEE
    ].freeze
  end
end
