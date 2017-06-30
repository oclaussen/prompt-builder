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
  module Shell
    FOREGROUNDS = {
      enable: {
        black: 30, red: 31, green: 32, yellow: 33,
        blue: 34, magenta: 35, cyan: 36, white: 37
      },
      disable: 38
    }.freeze

    BACKGROUNDS = {
      enable: {
        black: 40, red: 41, green: 42, yellow: 43,
        blue: 44, magenta: 45, cyan: 46, white: 47
      },
      disable: 48
    }.freeze

    ATTRIBUTES = {
      enable: { bold: 1, underline: 4, blink: 5, reverse: 7, concealed: 8 },
      disable: { bold: 22, underline: 24, blink: 25, reverse: 27, concealed: 28 }
    }.freeze
  end
end
