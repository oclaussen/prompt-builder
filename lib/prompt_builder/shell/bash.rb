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

require 'prompt_builder/prompt'
require 'prompt_builder/segment'

## Bash Prompt
# * `date`: The date in "Weekday Month Date" format (e.g., "Tue May 26")
# * `hostname_short`: The hostname up to the first `.'
# * `hostname_long`: The full hostname
# * `hostname`: The full hostname (equivalent to `hostname_long`)
# * `jobs`: The number of jobs currently managed by the shell
# * `tty`: The basename of the shell's terminal device name
# * `shell`: The name of the shell
# * `time`: The current time in 24-hour HH:MM:SS format
# * `time_24h`: The current time in 24-hour HH:MM:SS format
# * `time_12h`: The current time in 12-hour HH:MM:SS format
# * `time_am_pm`: The current time in 12-hour am/pm format
# * `user`: The username of the current user
# * `version`: The version of bash (e.g., 2.00)
# * `version_long`: The release of bash, version + patch level (e.g., 2.00.0)
# * `cwd`: The current working directory, with $HOME abbreviated with a tilde
# * `cwd_base`: The basename of the current working directory, with $HOME
# abbreviated with a tilde
# * `history`: The history number of this command
# * `command`: The command number of this command
# * `pound`: If the effective UID is 0, a #, otherwise a $
#
module PromptBuilder
  module Shell
    class BashPrompt < Prompt
      def noprint(text)
        "\\[#{text}\\]"
      end

      def to_s
        "export PS1=\"#{super}\""
      end

      {
        date:           '\d',
        hostname_short: '\h',
        hostname_long:  '\H',
        hostname:       '\H',
        jobs:           '\j',
        tty:            '\l',
        shell:          '\s',
        time:           '\t',
        time_24h:       '\t',
        time_12h:       '\T',
        time_am_pm:     '\@',
        user:           '\u',
        version:        '\v',
        version_long:   '\V',
        cwd:            '\w',
        cwd_base:       '\W',
        history:        '\!',
        command:        '\#',
        pound:          '\$'
      }.each do |name, sequence|
        define_method name do
          Segment.new sequence
        end
      end

      def if_success(text, otherwise: '')
        "\\`if [ \\$? = 0 ]; then echo '#{text}'; else echo '#{otherwise}';fi\\`"
      end
    end
  end
end
