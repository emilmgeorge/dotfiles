#==============================================================================|
# Early init
#==============================================================================|
[ ! -f "$ZDOTDIR/""local/very-early" ] || source "$ZDOTDIR/""local/very-early"
#------------------------------------------------------------------------------|
# Tmux
#------------------------------------------------------------------------------|
load_tmux() {
	if [[ -n "$TMUX" ]]; then
		return
	fi
	if [[ -n "$SKIP_MUX_INIT" ]]; then
		return
	fi
	if ! which tmux >/dev/null 2>&1; then
		return
	fi
	# Only start tmux on a real interactive terminal. Non-interactive or
	# "dumb" login shells (e.g. editor/WSL shell-integration probes) also
	# source this file; under WSL such a TERM=dumb shell was racing the real
	# terminal to create the "main" session, causing "duplicate session"
	# errors and tearing the terminal down shortly after launch.
	if [[ ! -o interactive || ! -t 1 || "$TERM" == dumb || -z "$TERM" ]]; then
		return
	fi
	# Opens tmux and switches to a pane at $(pwd).
	# Logic:
	#  * If 'main' tmux session is not yet started, start it.
	#  * If: there is already a pane in 'main' session that is at $(pwd),
	#        then switch to that pane.
	#    Else: Create a new pane at $(pwd).
	# Main session name
	local session_name="main"
	# If main session is not started, start and use it.
	if ! tmux has-session -t "$session_name"; then
		exec tmux new-session -s "$session_name" -c "$(pwd)"
	fi
	# Attach to an existing pane that is at the required CWD (if such
	# a pane exists) or create a new one. Note: the required pane may
	# already be running a command. That's okay for the use case. If
	# not, add filters below for pane_current_command == <names of
	# shells>
	local pane_info=`tmux list-panes -s -t main \
		-f "#{==:#{pane_current_path},$(pwd)}" \
		-F '#{window_id} #{pane_id}' |
		head -n1`
	if [[ "$pane_info" == "" ]]; then
		# Suitable pane not found. Create a new one.
		exec tmux attach-session -d -t "$session_name" \; \
			new-window -c "$(pwd)"
	else
		local window_id
		local pane_id
		read -r window_id pane_id <<< "$pane_info"
		exec tmux attach-session -d -t "$session_name" \; \
			select-window -t "$window_id" \; select-pane -t "$pane_id"
	fi
}

load_tmux
#------------------------------------------------------------------------------|
# Zsh powerlevel10k instant prompt
#------------------------------------------------------------------------------|
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#------------------------------------------------------------------------------|
[ ! -f "$ZDOTDIR/""local/early" ] || source "$ZDOTDIR/""local/early"
#------------------------------------------------------------------------------|
#==============================================================================|
# Options
#==============================================================================|
# General Options
#------------------------------------------------------------------------------|
# Allow comments in interactive mode
setopt interactivecomments

# Do not terminate on EOF (Ctrl-D).
# This allows us to manually handle Ctrl-D. See Keybindings section.
setopt ignore_eof
#------------------------------------------------------------------------------|
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=50000000
SAVEHIST=40000000
setopt nobeep nomatch notify
unsetopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
#------------------------------------------------------------------------------|
# Key binding Options
#------------------------------------------------------------------------------|
# Time (in centiseconds) that zsh waits between key presses for multi-key
# bindings (default: 40)
KEYTIMEOUT=200
#------------------------------------------------------------------------------|
# History options
#------------------------------------------------------------------------------|
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
# setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
#------------------------------------------------------------------------------|
# Completion options
#------------------------------------------------------------------------------|
# The following lines were added by compinstall
zstyle :compinstall filename "${ZDOTDIR}/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
#------------------------------------------------------------------------------|
# Match . files without explicitly specifying dot.
setopt globdots

# Load module for list-style selection
zmodload zsh/complist

# Complete prefix when cursor is within a word
setopt completeinword

# Use the module above for autocomplete selection
# zstyle ':completion:*' menu yes select
zstyle ':completion:*' menu select

# Show full file list
zstyle ':completion:*' file-list all

# Convert // in path to / while completing instead of /*/
zstyle ':completion:*' squeeze-slashes true

# Do not insert TAB at start of line
zstyle ':completion:*' insert-tab false

# List all processes in process completion
zstyle ':completion:*:processes' command 'ps aux'

# Remote autocomplete
# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%% [# ]*}//,/ })'

zstyle ':completion:*' completer \
  _oldlist _complete _correct _ignored _prefix

# Tab completion for shell (`!`) git aliases (git/.config/git/config)
_git_alias_comp="${XDG_CONFIG_HOME:-$HOME/.config}/git/git-alias-completion.zsh"
[ ! -f "$_git_alias_comp" ] || source "$_git_alias_comp"
unset _git_alias_comp

#------------------------------------------------------------------------------|
[ ! -f "$ZDOTDIR/""local/options" ] || source "$ZDOTDIR/""local/options"
#------------------------------------------------------------------------------|
#==============================================================================|
# Aliases and functions
#==============================================================================|

# ls with all list human-readable-sizes slash-for-dirs sort-by-time-desc reverse
alias ls='ls -alhptr --color=auto --group-directories-first'
alias diff='diff --show-c-function --unified --color=auto'
alias grep='grep --color=auto'

alias nvim-custom='NVIM_APPNAME=nvim command nvim'
alias nvim-lazy='NVIM_APPNAME=nvim-lazy command nvim'

# Override builtin git commands
git() {
	# 'git reset --hard' with dirty working tree
	if [[ "$1" == "reset" && "$@" == *"--hard"* ]]; then
		if [[ -n $(command git status --porcelain -uno) ]]; then
			REPLY=""
			MSG="Work directory is dirty. "
			MSG+="Are you sure you want to reset --hard? [y/n]: "
			vared -p $MSG -c REPLY
			if ! [[ $REPLY =~ ^[Yy]$ ]]; then
				return
			fi
		fi
	fi
	command git "$@"
}

# cd using yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#------------------------------------------------------------------------------|
[ ! -f "$ZDOTDIR/""local/aliases" ] || source "$ZDOTDIR/""local/aliases"
#------------------------------------------------------------------------------|
#==============================================================================|
# Keybindings
#==============================================================================|

# Switch to vi-cmd-mode with escape (i switches back to insert (emacs) mode)
bindkey '\e' vi-cmd-mode

# Better handling of Ctrl-D
# Note: This requires setopt ignore_eof.
IGNOREEOF=5
zsh-ctrl-d() {
	# If this is the first consecutive Ctrl-D pressed, reset hold-off count.
	if [[ $LASTWIDGET != zsh-ctrl-d ]]; then
		(( __ZSH_IGNORE_EOF_COUNT = $IGNOREEOF ))
	fi
	if [[ -z $BUFFER ]]; then
		#  If buffer is empty:
		#  If hold-off not configured, then exit the shell immediately.
		[[ -z $IGNOREEOF || $IGNOREEOF == 0 ]] && exit
		#  If hold-off count expired, then exit the shell.
		(( --__ZSH_IGNORE_EOF_COUNT <= 0 )) && exit
		zle -M "Exiting in $__ZSH_IGNORE_EOF_COUNT (Ctrl-D) .."
	elif [[ $CURSOR -lt ${#BUFFER} ]]; then
		# If cursor is in the middle of text, remove the next character.
		zle delete-char
	else
		# Else remove the last character.
		zle backward-delete-char
	fi
}
zle -N zsh-ctrl-d
bindkey '^d' zsh-ctrl-d

# Edit current command in $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line

# Use C-u to stash the existing command and pop it after the next command
# C-q is commonly used in zsh and C-u, C-y is used in bash
bindkey '^u' push-line

# Undo/redo last text modification
bindkey '^x^u' undo
bindkey '^x^y' redo

# History up/down based on what is already typed
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^p" up-line-or-beginning-search
bindkey "^n" down-line-or-beginning-search

# Copy command to clipboard
copy_command_to_clipboard () { xsel -ib <<< $BUFFER }
zle -N copy_command_to_clipboard
bindkey '^y' copy_command_to_clipboard

# Alt+Backspace to kill previous alphanumeric word.
# Use C-w for default behaviour.
backward-kill-alphanumeric() {
    local WORDCHARS=
    zle backward-kill-word
    zle -f kill
}
zle -N backward-kill-alphanumeric
bindkey '^[^?' backward-kill-alphanumeric

# Alt+d to kill next alphanumeric word.
# Use Alt+Shift+d for default behaviour.
forward-kill-alphanumeric() {
    local WORDCHARS=
    zle kill-word
    zle -f kill
}
zle -N forward-kill-alphanumeric
bindkey '^[d' forward-kill-alphanumeric
bindkey '^[D' kill-word

# Alt+b to move back till previous non-alphanumeric character.
# Alt+B for default behaviour.
backward-move-alphanumeric () {
    local WORDCHARS=
    zle backward-word
}
zle -N backward-move-alphanumeric
bindkey '^[b' backward-move-alphanumeric
bindkey '^[B' backward-word

# Alt+f to move forward till next non-alphanumeric character.
# Alt+F for default behaviour.
forward-move-alphanumeric () {
    local WORDCHARS=
    zle forward-word
}
zle -N forward-move-alphanumeric
bindkey '^[f' forward-move-alphanumeric
bindkey '^[F' forward-word

# Selectively skip saving the command being executed to the history file
function skip-history-file-hook() {
  emulate -L zsh
  add-zsh-hook -d zshaddhistory skip-file-history-hook
  # Keep in memory till next command execution.
  # return 1
  # Keep in memory history, but do not save to file.
  return 2
}
function accept-line-skip-history-file() {
  emulate -L zsh
  add-zsh-hook zshaddhistory skip-history-file-hook
  zle .accept-line
}
zle -N accept-line-skip-history-file
bindkey "^g^M" accept-line-skip-history-file

# Bind Tab to `complete-word` (the default is `expand-or-complete`, whose
# expand step evaluates `$(pwd)`, `$var`, `~`, etc. when completing, e.g.
# turning `$(pwd)/path/<TAB>` into the evaluated path).
# Note: this bindkey must be placed before tab-completion plugins (eg. fzf-tab)
# are loaded, otherwise this will override the plugin's bindkey.
bindkey '^I' complete-word

#------------------------------------------------------------------------------|
[ ! -f "$ZDOTDIR/""local/keybindings" ] || source "$ZDOTDIR/""local/keybindings"
#------------------------------------------------------------------------------|
#==============================================================================|
# Plugins Setup
#==============================================================================|
# Plugin Manager
#------------------------------------------------------------------------------|
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

#------------------------------------------------------------------------------|
# Plugins
#------------------------------------------------------------------------------|
[ ! -f "$ZDOTDIR/""local/plugins-early" ] || source "$ZDOTDIR/""local/plugins-early"
#------------------------------------------------------------------------------|

zinit ice depth=1
zinit light zdharma-continuum/zinit-annex-patch-dl

zinit ice depth=1
zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit file pointed to by the
# POWERLEVEL9K_CONFIG_FILE env var.
export POWERLEVEL9K_CONFIG_FILE="$ZDOTDIR/.p10k.zsh"
[[ ! -f "${POWERLEVEL9K_CONFIG_FILE}" ]] || source "${POWERLEVEL9K_CONFIG_FILE}"
# Emit OSC 133 markers
typeset -g POWERLEVEL9K_TERM_SHELL_INTEGRATION=true

# fzf - fuzzy finder
# fzf package must be installed and present in PATH
source "$ZDOTDIR/fzf.zsh"

# fzf-git.sh
export __FZF_GIT_USER_PREFIX=^g^f^g
# [f]iles [b]ranches [t]ags [r]emotes [h]ashes [s]tashes [l]reflogs [e]ach_ref [w]orktrees
zinit ice depth=1 wait lucid \
  patch"$ZDOTDIR/fzf-git-add-option-to-set-custom-key-prefix.patch;" nocompile'!' reset
zinit light junegunn/fzf-git.sh
source "$ZDOTDIR/.fzf-git-overrides.zsh"

zinit ice depth=1 wait lucid
zinit light Aloxaf/fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# reset zsh completers to allow fzf-tab to capture the unambiguous prefix
zstyle -d ':completion:*' completer
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-min-size 80 0
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# use tmux popup for display
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# remove unnecessary '.' prefix
# https://github.com/Aloxaf/fzf-tab/pull/183#issuecomment-787080931
zstyle ':fzf-tab:*' prefix ''
# prevent full file list which causes:
# - file permission string to be taken as prefix
# - file names to go out of sight when preview window is present (cd)
zstyle ':completion:*' file-list default

# The CLI sometimes hangs when trying to highlight man/whatis commands.
# https://github.com/zdharma-continuum/fast-syntax-highlighting/issues/27
# Temp fix: disable man/whatis argument highlights.
zinit ice depth=1 wait lucid \
	subst'→chroma/-whatis.ch ->'
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice depth=1 wait lucid \
  dl'https://github.com/zsh-users/zsh-autosuggestions/commit/4ccfdb243.patch' \
  patch'4ccfdb243.patch;' nocompile'!' reset
# PR URL: https://github.com/zsh-users/zsh-autosuggestions/pull/507
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-word forward-move-alphanumeric)

zinit ice depth=1 wait'1' lucid
zinit light zsh-users/zsh-completions

atuin-search(){}
export ATUIN_NOBIND="true"
zinit ice depth=1 wait lucid has'atuin'
zinit load atuinsh/atuin
zle -N atuin-search
bindkey '^r' atuin-search
bindkey '^g^g' fzf-history-widget

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

_aichat_zsh="${XDG_CONFIG_HOME:-$HOME/.config}/aichat/aichat.zsh"
if (( $+commands[aichat] )) && [[ -f "$_aichat_zsh" ]]; then
  source "$_aichat_zsh"
fi
unset _aichat_zsh

zinit ice depth=1 wait lucid trigger-load"!hist"
zinit light marlonrichert/zsh-hist
zstyle ':hist:*' auto-format no
# We have to defer invoking 'hist' in key-bound widgets because subcommands like
# 'fix' and 'edit', which require interactive user input (via vared), cannot be
# run directly inside the ZLE widget context.
local function make_deferred_hist_widget() {
	local widget_name=$1
	local hook_func="__${widget_name}_hook"
	local hist_args=("${(@)argv[2,-1]}")
	local quoted_args=$(print -r -- ${(q)hist_args})

	eval "
	function $widget_name() {
		function $hook_func() {
			add-zsh-hook -d precmd $hook_func
			unfunction $hook_func
			hist $quoted_args
		}
		add-zsh-hook -d precmd $hook_func
		add-zsh-hook precmd $hook_func
		local BUFFERSTASH=\$BUFFER
		BUFFER=
		zle accept-line
		print -z "\$BUFFERSTASH"
	}
	zle -N $widget_name
	"
}
make_deferred_hist_widget hist_defer_fix_minus_1    f -1
make_deferred_hist_widget hist_defer_edit_minus_1   e -1
make_deferred_hist_widget hist_defer_delete_minus_1 d -1
unfunction make_deferred_hist_widget
bindkey '^g^r^f' hist_defer_fix_minus_1
bindkey '^g^r^e' hist_defer_edit_minus_1
bindkey '^g^r^r' hist_defer_delete_minus_1

# Core transpose logic: direction = -1 (left) or 1 (right)
_transpose_arg() {
  emulate -L zsh
  setopt extended_glob

  local direction=$1
  local pos=CURSOR
  # Current cursor position (0-indexed) can be equal to #BUFFER (one past end)
  # We add a space at the end to accomodate for this:
  local cmd="${LBUFFER}${RBUFFER} " # Full command line content
  local args=("${(z)cmd}")        # Array of shell words

  local current_arg_idx=1 # Current argument index in the 'args' array (1-indexed)
  local cursor_arg_idx
  local arg

  # Arrays to store word/space positions and counts
  local -a arg_starts       # 0-indexed start position of each arg in cmd
  local -a arg_ends         # 0-indexed end position of each arg in cmd
  local -a arg_lengths      # 0-indexed start position of each arg in cmd
  local -a post_spacings # Number of trailing spaces *after* each arg
                            # post_spacings[1] -> spaces after args[1]
                            # post_spacings[2] -> spaces after args[2] etc.

  local char_idx=0 # Tracks our current position in 'cmd' as we parse it
  local found_cursor=0

  # Populate arg_starts, arg_ends, and post_spacings
  for arg in "${args[@]}"; do
    local len=${#arg}
    local postspaces=0

    # Calculate and store start/end positions for this argument
    local start_pos=$char_idx
    char_idx=$((start_pos + len))
    local end_pos=$char_idx

    # Calculate trailing spaces for the current segment
    local segment_from_current_idx="${cmd:$char_idx}"
    if [[ "$segment_from_current_idx" =~ '^([[:space:]]*)' ]]; then
	postspaces=${#match[1]}
	char_idx=$(( char_idx + postspaces )) # Use match[1] to get the captured group (the spaces)
    fi

    # Store the number of trailing spaces for this argument
    post_spacings+=($postspaces)
    arg_starts+=($start_pos)
    arg_ends+=($end_pos)
    arg_lengths+=($len)

    if [ "$found_cursor" -eq "1" ]; then
	break;
    fi

    # Check if the cursor is within this argument (inclusive of its postspaces)
    if (( pos >= start_pos && pos < char_idx )); then
	cursor_arg_idx=$current_arg_idx
	# If transpose right, then do one more iteration because we need to find
	# the target values also. Otherwise break.
	found_cursor=1
	if [ $direction -lt 0 ]; then
		break
	fi
    fi

    ((current_arg_idx++)) # Increment argument index
  done

  # Determine target argument for transposition
  local target_arg_idx=$((cursor_arg_idx + direction))
  if (( target_arg_idx < 1 || target_arg_idx > $#args )); then
    zle beep
    return
  fi

  # --- Reconstruct the BUFFER with flipped words and preserved spacing ---
  local new_buffer=""
  local new_cursor_position=0

  # Determine the range of affected arguments for substring extraction
  local first_affected_idx
  local last_affected_idx
  local cursordiff
  cursordiff=$(( cursordiff < 0 ? -cursordiff : cursordiff ))

  if (( cursor_arg_idx < target_arg_idx )); then
      first_affected_idx=$cursor_arg_idx
      last_affected_idx=$target_arg_idx
      cursordiff=$(( arg_lengths[current_arg_idx] + post_spacings[current_arg_idx] ))
  else
      first_affected_idx=$target_arg_idx
      last_affected_idx=$cursor_arg_idx
      cursordiff=$(( -(arg_lengths[target_arg_idx] + post_spacings[target_arg_idx]) ))
  fi

  # Part 1: Content before the first affected argument
  # Take the substring from the beginning of the buffer up to the start of the first affected arg.
  local start_of_first_affected_in_cmd=${arg_starts[first_affected_idx]}
  # Zsh substrings are 1-indexed. `cmd[1,X]` includes X.
  local start_of_remaining=${arg_ends[last_affected_idx]}
  new_buffer="${cmd[1,start_of_first_affected_in_cmd]}${args[last_affected_idx]}${(r:$((post_spacings[first_affected_idx])):)}${args[first_affected_idx]}"
  new_buffer="$new_buffer${BUFFER:$start_of_remaining}"
  BUFFER="$new_buffer"
  CURSOR=$(( CURSOR + cursordiff ))

  return
}

# Bind keys
transpose_arg_left()  { _transpose_arg -1 }
transpose_arg_right() { _transpose_arg  1 }
zle -N transpose_arg_left
zle -N transpose_arg_right
bindkey '^g<' transpose_arg_left   # move arg left
bindkey '^g>' transpose_arg_right  # move arg right

#------------------------------------------------------------------------------|
[ ! -f "$ZDOTDIR/""local/plugins-late" ] || source "$ZDOTDIR/""local/plugins-late"
#------------------------------------------------------------------------------|
#==============================================================================|
# Env
#==============================================================================|

export EDITOR=nvim

#------------------------------------------------------------------------------|
[ ! -f "$ZDOTDIR/""local/environment" ] || source "$ZDOTDIR/""local/environment"
#------------------------------------------------------------------------------|
#==============================================================================|
