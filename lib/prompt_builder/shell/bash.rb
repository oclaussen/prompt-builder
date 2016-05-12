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

      provide_escape_sequence :date, '\d'
      provide_escape_sequence :hostname_short, '\h'
      provide_escape_sequence :hostname_long, '\H'
      provide_escape_sequence :hostname, '\H'
      provide_escape_sequence :jobs, '\j'
      provide_escape_sequence :tty, '\l'
      provide_escape_sequence :shell, '\s'
      provide_escape_sequence :time, '\t'
      provide_escape_sequence :time_24h, '\t'
      provide_escape_sequence :time_12h, '\T'
      provide_escape_sequence :time_am_pm, '\@'
      provide_escape_sequence :user, '\u'
      provide_escape_sequence :version, '\v'
      provide_escape_sequence :version_long, '\V'
      provide_escape_sequence :cwd, '\w'
      provide_escape_sequence :cwd_base, '\W'
      provide_escape_sequence :history, '\!'
      provide_escape_sequence :command, '\#'
      provide_escape_sequence :pound, '\$'

      # rubocop:disable Metrics/LineLength
      provide_escape_sequence :if_success do |text, otherwise: ''|
        "\\`if [ \\$? = 0 ]; then echo '#{text}'; else echo '#{otherwise}';fi\\`"
      end
    end
  end
end
