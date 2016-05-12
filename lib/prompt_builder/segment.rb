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

# TODO: make this nice
# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
module PromptBuilder
  class Segment
    def initialize(*args, noprint: nil, foreground: nil, background: nil, attribute: nil)
      @children = []
      @foreground = foreground
      @background = background
      @attribute = attribute
      @noprint = noprint
      args.each do |arg|
        @children << arg if arg.is_a?(String) || arg.is_a?(Segment)
      end
    end

    attr_reader :foreground
    attr_reader :background
    attr_reader :attribute

    def foreground?
      !@foreground.nil? || @children.any? do |child|
        child.is_a?(Segment) && child.foreground?
      end
    end

    def background?
      !@background.nil? || @children.any? do |child|
        child.is_a?(Segment) && child.background?
      end
    end

    def colored(foreground: nil, background: nil, attribute: nil)
      @foreground = foreground unless foreground.nil?
      @background = background unless background.nil?
      @attribute = attribute unless attribute.nil?
      self
    end

    FOREGROUNDS[:enable].each do |name, _|
      define_method name do
        colored(foreground: name)
      end
    end

    BACKGROUNDS[:enable].each do |name, _|
      define_method "#{name}_background".to_sym do
        colored(background: name)
      end
    end

    ATTRIBUTES[:enable].each do |name, _|
      define_method name do
        colored attribute: name
      end
    end

    def to_s
      segments = []
      segments << enable_code
      segments << @children.map { |child| child.to_s + rescue_code(child) }
      segments << disable_code
      segments.join
    end

    private

    def enable_code
      codes = []
      codes << FOREGROUNDS[:enable][@foreground] unless @foreground.nil?
      codes << BACKGROUNDS[:enable][@background] unless @background.nil?
      codes << ATTRIBUTES[:enable][@attribute] unless @attribute.nil?
      return '' if codes.empty?
      @noprint.call "\\033[#{codes.join ';'}m"
    end

    def disable_code
      codes = []
      codes << FOREGROUNDS[:disable] unless @foreground.nil?
      codes << BACKGROUNDS[:disable] unless @background.nil?
      codes << ATTRIBUTES[:disable][@attribute] unless @attribute.nil?
      return '' if codes.empty?
      @noprint.call "\\033[#{codes.join ';'}m"
    end

    def rescue_code(child)
      return '' if child.is_a?(String)
      codes = []
      codes << FOREGROUNDS[:enable][@foreground] if !@foreground.nil? && child.foreground?
      codes << BACKGROUNDS[:enable][@background] if !@background.nil? && child.background?
      return '' if codes.empty?
      @noprint.call "\\033[#{codes.join ';'}m"
    end
  end
end
