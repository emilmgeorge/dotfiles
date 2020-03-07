# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi




## Custom Emil --------------------------------------------------------------------------------------------------------------



# Coloured Prompt
PS1='\[\e[1;92m\]\u\[\e[m\] \[\e[1;91m\]\h\[\e[m\] \[\e[0;37m\]\w\[\e[m\] \[\e[1;33m\]\$\[\e[m\] '
#PS1='[\u@\h \W]\$ '  # Default
# for root colors see /root/.bashrc

# Automatically expand !-based history shortcuts when space is pressed.
#http://stackoverflow.com/questions/68372/what-is-your-single-most-favorite-command-line-trick-using-bash#comment1261205_68496
bind Space:magic-space


export HISTCONTROL=ignoreboth:erasedups

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"


## Common Aliases -------------------------------------------------------------------------------------------------------------
alias ls='ls --color=auto -alhFSr --group-directories-first'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias alsamixer='alsamixer -c 0 -V all'

changeandlistdir() 
{ 
	cd "$1" && ls; 
}
alias cd='changeandlistdir'

## ----------------------------------------------------------------------------------------------------------------------------

alias emacs="emacsclient -t"
alias gemacs="emacsclient -c"

# function emacs {
#     if [[ $# -eq 0 ]]; then
#         /usr/bin/emacs # "emacs" is function, will cause recursion
#         return
#     fi
#     args=($*)
#     for ((i=0; i <= ${#args}; i++)); do
#         local a=${args[i]}
#         # NOTE: -c for creating new frame
#         if [[ ${a:0:1} == '-' && ${a} != '-c' ]]; then
#             /usr/bin/emacs ${args[*]}
#             return
#         fi
#     done
#     setsid emacsclient -n -a /usr/bin/emacs ${args[*]}
# } 


#export EDITOR="emacsclient -t"
export ALTERNATE_EDITOR=""

export EDITOR="vim"


# TMUX
# https://wiki.archlinux.org/index.php/Tmux#Start_tmux_on_every_shell_login

# check if tmux is installed
if which tmux >/dev/null 2>&1; then
    # if not inside a tmux session
    if [[ -z "$TMUX" ]] ;then

    	# start tmux session if server doesnt exist
    	b="`tmux ls || tmux new-session -s 'main'`"


    	# make newlines the only separator
    	${IFS+"false"} && unset oldifs || oldifs="$IFS"
    	IFS=$'\n'
    	# list all panes in all windows in all sessions
    	a=`tmux list-panes -a -F "#{pane_pid} #{pane_id} #{window_id} #{session_id} #{pane_current_command} #{pane_current_path}"`
    	for x in $a; do
    	  	#if some pane has process bash (idle terminal) and has same directory as pwd then
    	  	if [ "$( echo "$x" | cut -d " " -f5)" == "bash" ] && [ "$( echo "$x" | cut -d " " -f1,2,3,4,5 --complement)" == "$(pwd)" ] ; then 
    	  		# reset IFS (does it matter?) and switch to that pane
    	  		${oldifs+"false"} && unset IFS || IFS="$oldifs"
    	  		tmux attach-session -t "$s" \; select-window -t "$( echo "$x" | cut -d " " -f3)" \; select-pane -t "$( echo "$x" | cut -d " " -f2)" 
    	  	fi ; 
    	done

    	# else attach to main and start new window
	    tmux attach-session -t "main" \; new-window -c $(pwd)

	fi
fi

#source ~/.bash.d/autocomplete/tmux.completion.bash

# disable Ctrl-S XOFF (if it is enabled, hangs terminal updates until Ctrl-Q)
stty -ixon

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
