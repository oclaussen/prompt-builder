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

## Zsh Prompt
# * `tty`: The basename of the shell's terminal device name
# * `tty_long`: The full name of the shell's terminal device name
# * `hostname_short`: The hostname up to the first `.'
# * `hostname_long`: The full hostname
# * `hostname`: The full hostname (equivalent to `hostname_long`)
# * `user`: The username of the current user
# * `pound`: If the effective UID is 0, a #, otherwise a $
# * `return_code`: The return status of the last command executed
# * `parser_state`: The status of the parser
# * `parser_state_rev`: The status of the parser in reverse
# * `cwd`: The current working directory, with $HOME abbreviated with a tilde
# * `cwd_full`: The current working directory
# * `eval_depth`: Evaluation depth of the current sourced file,
# shell function, or eval
# * `history`: Current history event number
# * `line`: The line number currently being executed
# * `jobs`: The number of jobs
# * `shlvl`: The current value of $SHLVL
# * `script_file`: The name of the file containing the source code currently
# being executed
# * `date`: The date in yy-mm-dd format (equivalent to `date_long`)
# * `date_long`: The date in yy-mm-dd format
# * `date_short`: The date in day-dd format.
# * `time`: Current time of day, in 24-hour format (equivalent to `time_24h`)
# * `time_24h`: Current time of day, in 24-hour format
# * `time_12h`: Current time of day, in 12-hour format.
# * `date_format <format>`: Formatted time using <format> via `strftime`
#
module PromptBuilder
  module Shell
    class ZshPrompt < Prompt
      def noprint(text)
        "%{#{text}%}"
      end

      provide_escape_sequence :tty, '%l'
      provide_escape_sequence :tty_long, '%y'
      provide_escape_sequence :hostname_short, '%m'
      provide_escape_sequence :hostname_long, '%M'
      provide_escape_sequence :hostname, '%M'
      provide_escape_sequence :user, '%n'
      provide_escape_sequence :pound, '%#'
      provide_escape_sequence :return_code, '%?'
      provide_escape_sequence :parser_state, proc { |num = 0| "%#{num}_" }
      provide_escape_sequence :parser_state_rev, proc { |num = 0| "%#{num}^" }
      provide_escape_sequence :cwd, proc { |num = 0| "%#{num}~" }
      provide_escape_sequence :cwd_full, proc { |num = 0| "%#{num}d" }
      provide_escape_sequence :eval_depth, '%e'
      provide_escape_sequence :history, '%h'
      provide_escape_sequence :line, '%I'
      provide_escape_sequence :jobs, '%j'
      provide_escape_sequence :shlvl, '%L'
      provide_escape_sequence :script_file, proc { |num = 0| "%#{num}x" }
      provide_escape_sequence :date, '%D'
      provide_escape_sequence :date_long, '%D'
      provide_escape_sequence :date_short, '%w'
      provide_escape_sequence :time, '%T'
      provide_escape_sequence :time_24h, '%T'
      provide_escape_sequence :time_12h, '%t'
      provide_escape_sequence :date_format, proc { |format| "%D{#{format}}" }

      provide_escape_sequence :if_success do |text, otherwise: ''|
        "%(?.#{text}.#{otherwise})"
      end
    end
  end
end
