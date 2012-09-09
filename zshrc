# zshrc by dlamotte
source /etc/zsh/zprofile

umask 0077

export PATH=$PATH:/sbin:/usr/sbin
export PATH=~/bin:~/.python/bin:~/.gem/ruby/1.9.1/bin:~/sandbox/node-local/bin:$PATH

if [[ -e $HOME/.current/zshrc.noninteractive ]]; then
    source $HOME/.current/zshrc.noninteractive
fi

if [[ $- != *i* ]]; then
    # non-interactive, return now
    return
fi

export EDITOR=vim
export LANG='en_US.utf8'
export LC_COLLATE='C'
export LESS="-MRIF"
export MANPAGER='vimmanpager'
export PAGER='less'
export TZ='US/Central'

export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000

export PYTHONPATH="${PYTHONPATH}${PYTHONPATH+:}${HOME}/.python/lib"
export PYTHONSTARTUP='/home/xyld/.pythonrc'
export PYTHONDOCS=$(echo ${PYTHONDOCS} | sed -e 's:/lib::g')

export PS1="%B%F{red}!%! %F%1~ %F{red}%(?..%? )>> %f%b"
export PS2="%B%F{red}>>> %f%b"
export RPS1=" %B%F{red}<<%(!..%F) %M%f%b"

if [[ -z $LS_COLORS ]]; then
    eval $(dircolors)
fi

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ls="ls -F --color=auto"
alias info="info --vi-keys"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias acroread="acroread -openInNewWindow"
alias octave="octave --silent"
alias bc="bc -ql"
alias gcc="gcc -pedantic -Wall"
alias cscope="cscope -R -q"
alias wbugz="bugz -b http://bugs.winehq.org/"
alias rdesktop="rdesktop -g 1024x768 -K -x b"
alias mq='hg -R $(hg root)/.hg/patches'
alias chromium_roam="chromium --user-data-dir=$HOME/.config/chromium-roam"

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true
zstyle ':completion::complete:*' use-cache 1 # gentoo item...
zstyle :compinstall filename '/home/xyld/.zshrc'

autoload -Uz compinit
compinit

setopt appendhistory extendedglob
setopt noclobber vi
setopt nocheckjobs nohup
setopt autopushd
unsetopt autocd beep notify

zmodload -i zsh/complist

bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^U' kill-whole-line
bindkey -M viins '^Y' yank

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^E' end-of-line
bindkey '^A' beginning-of-line

if [[ -e $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi
if [[ -e $HOME/.current/zshrc.local ]]; then
    source $HOME/.current/zshrc.local
fi

# hub tab-completion script for zsh.
# This script complements the completion script that ships with git.
#
# vim: ft=zsh sw=2 ts=2 et

# Autoload _git completion functions
if declare -f _git > /dev/null; then
  _git
fi

if declare -f _git_commands > /dev/null; then
  _hub_commands=(
    'alias:show shell instructions for wrapping git'
    'pull-request:open a pull request on GitHub'
    'fork:fork origin repo on GitHub'
    'create:create new repo on GitHub for the current project'
    'browse:browse the project on GitHub'
    'compare:open GitHub compare view'
  )
  # Extend the '_git_commands' function with hub commands
  eval "$(declare -f _git_commands | sed -e 's/base_commands=(/base_commands=(${_hub_commands} /')"
fi

eval "$(hub alias -s)"
