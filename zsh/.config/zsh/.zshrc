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
zstyle :compinstall filename '/home/emil/.zshrc'

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
  _oldlist _expand _complete _correct _ignored _prefix

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

# fzf fuzzy finder
# Installed using distro package manager
source <(fzf --zsh)
# Set custom bindings
bindkey '^g^f^f' fzf-file-widget
bindkey '^g^f^d' fzf-cd-widget
# Restore default zsh bindings
bindkey '^t' transpose-chars
bindkey '^[c' capitalize-word

export __FZF_GIT_USER_PREFIX=^g^f^g
# [f]iles [b]ranches [t]ags [r]emotes [h]ashes [s]tashes [l]reflogs [e]ach_ref [w]orktrees
zinit ice depth=1 wait lucid \
  patch"$ZDOTDIR/fzf-git-add-option-to-set-custom-key-prefix.patch;" nocompile'!' reset
zinit light junegunn/fzf-git.sh

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

zinit ice depth=1 wait lucid trigger-load"!hist"
zinit light marlonrichert/zsh-hist
bindkey -s '^g^r^f' "hist f -1\n"
bindkey -s '^g^r^e' "hist e -1\n"
bindkey -s '^g^r^r' "hist d -1\n"

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
