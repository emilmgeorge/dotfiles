# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=50000000
SAVEHIST=40000000
setopt beep nomatch notify
unsetopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/emil/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

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

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

## History options
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

# Match . files without explicitly specifying dot.
setopt globdots

## Completion settings

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
cmd_to_clip () { xsel -ib <<< $BUFFER }
zle -N cmd_to_clip
bindkey '^y' cmd_to_clip


## Plugins

zinit ice depth=1
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice depth=1
zinit light zsh-users/zsh-autosuggestions

zinit ice depth=1
zinit light zsh-users/zsh-completions

zinit ice depth=1
zinit light romkatv/powerlevel10k

# Setup fzf
# ---------
# zinit light unixorn/fzf-zsh-plugin	# Using fzf from distro package manager
FZF_PATH="/usr/share/fzf"
[[ $- == *i* ]] && source "${FZF_PATH}/completion.zsh" 2> /dev/null
source "${FZF_PATH}/key-bindings.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Use legacy scp protocol. Required for old scp clients.
# alias scp='scp -O'
alias ls='ls -alhptr' # all list human-readable-sizes slash-for-dirs sort-by-time-desc reverse

# Override builtin git commands
git() {
	if [[ "$1" == "reset" && "$@" == *"--hard"* ]]; then
		if [[ -n $(command git status --porcelain -uno) ]]; then
			REPLY=""
			vared -p "Work directory is dirty. Are you sure you want to reset --hard? [y/n]: " -c REPLY
			if [[ $REPLY =~ ^[Yy]$ ]]
			then
			else
				return
			fi
		fi
	fi
	command git "$@"
}
