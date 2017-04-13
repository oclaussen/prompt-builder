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

require 'prompt_builder/prompt'
require 'prompt_builder/segment'
require 'prompt_builder/shell/common'

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
      include Shell::Common

      def noprint(text)
        "%{#{text}%}"
      end

      def compile(name)
        script "export #{name}=$'#{super}'"
        @lines.join "\n"
      end

      def lookup_variable_name(name)
        {
          'PS1' => %i[default primary left],
          'PS2' => %i[secondary],
          'PS3' => %i[select],
          'PS4' => %i[trace],
          'RPS1' => %i[right],
          'SPROMPT' => %i[spelling]
        }.find(proc { super }) { |_, names| names.include? name }[0]
      end

      {
        tty:              proc { '%l' },
        tty_long:         proc { '%y' },
        hostname_short:   proc { '%m' },
        hostname_long:    proc { '%M' },
        hostname:         proc { '%M' },
        user:             proc { '%n' },
        pound:            proc { '%#' },
        return_code:      proc { '%?' },
        parser_state:     proc { |num = 0| "%#{num}_" },
        parser_state_rev: proc { |num = 0| "%#{num}^" },
        cwd:              proc { |num = 0| "%#{num}~" },
        cwd_full:         proc { |num = 0| "%#{num}d" },
        eval_depth:       proc { '%e' },
        history:          proc { '%h' },
        line:             proc { '%I' },
        jobs:             proc { '%j' },
        shlvl:            proc { '%L' },
        script_file:      proc { |num = 0| "%#{num}x" },
        date:             proc { '%D' },
        date_long:        proc { '%D' },
        date_short:       proc { '%w' },
        time:             proc { '%T' },
        time_24h:         proc { '%T' },
        time_12h:         proc { '%t' },
        date_format:      proc { |format| "%D{#{format}}" }
      }.each do |name, blk|
        define_method name do |*args|
          Segment.new(instance_exec(*args, &blk))
        end
      end

      def if_success(text, otherwise: '')
        Segment.new "%(?.#{text}.#{otherwise})"
      end

      def vi_mode(cmd: 'CMD', ins: 'INS')
        script 'setopt prompt_subst'
        script 'function zle-line-init zle-keymap-select() { zle reset-prompt; zle -R }'
        script 'zle -N zle-line-init'
        script 'zle -N zle-keymap-select'
        script <<~EOS
          function vi_mode_prompt_info() {
            INDICATOR_CMD="#{cmd}"
            INDICATOR_INS="#{ins}"
            echo "${${KEYMAP/vicmd/$INDICATOR_CMD}/(main|viins)/$INDICATOR_INS}"
          }
        EOS
        Segment.new '$(vi_mode_prompt_info)'
      end

      def vcs_info
        script 'setopt prompt_subst'
        script 'autoload -Uz vcs_info'
        script 'precmd () { vcs_info }'
        script 'zstyle \':vcs_info:git:*\' formats \'%b\''
        Segment.new '${vcs_info_msg_0_}'
      end

      private

      def script(text)
        @lines = [] if @lines.nil?
        @lines << text unless @lines.include? text
      end
    end
  end
end
