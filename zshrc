# zshrc by dlamotte

if [[ -e /etc/zsh/zprofile ]]; then
    source /etc/zsh/zprofile
fi

umask 0077

if [[ -e $HOME/.current/zshrc.noninteractive ]]; then
    source $HOME/.current/zshrc.noninteractive
fi

if [[ -e $HOME/.zshrc.noninteractive ]]; then
    source $HOME/.zshrc.noninteractive
fi

export PATH=/usr/local/bin:/usr/local/sbin:$PATH:/sbin:/usr/sbin
for dir in /usr/local/share/python /usr/local/opt/coreutils/libexec/gnubin /usr/local/share/npm/bin; do
    if [[ -e $dir ]]; then
        # python scripts are installed here from homebrew
        export PATH=$dir:$PATH
    fi
done
export PATH=~/bin:~/.python/bin:~/.gem/ruby/1.9.1/bin:$PATH

if [[ $- != *i* ]]; then
    # non-interactive, return now
    return
fi

if locale -a | grep 'en_US.utf8' >/dev/null 2>/dev/null; then
    export LANG='en_US.utf8'
elif locale -a | grep 'en_US.UTF-8' >/dev/null 2>/dev/null; then
    export LANG='en_US.UTF-8'
else
    echo "zshrc error: LANG=C, en_US.utf8-ish not found"
    export LANG='C'
fi

export EDITOR=vim
export LC_COLLATE='C'
export LESS="-MRIFX"
export LESSOPEN="|lesspipe.sh %s"
export MANPAGER='vimmanpager'
export PAGER='less'
export PYTHONPATH="${PYTHONPATH}${PYTHONPATH+:}${HOME}/.python/lib"
export PYTHONSTARTUP=~/.pythonrc
export PYTHONDOCS=$(echo ${PYTHONDOCS} | sed -e 's:/lib::g')
export TZ='US/Central'

export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000

export PS1='%B%F{red}!%! %F{magenta}$(scmstatus)%F%1~ %(?.%? .%F{red}%? )%F{red}>> %f%b'
export PS2='%B%F{red}>>> %f%b'
export RPS1=' %B%F{red}<<%(!..%F) %M%f%b'

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
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

autoload -Uz add-zsh-hook
add-zsh-hook chpwd scmstatus_update
add-zsh-hook precmd scmstatus_precmd
add-zsh-hook preexec scmstatus_preexec

setopt appendhistory extendedglob
setopt autopushd
setopt histignorespace
setopt nocheckjobs nohup
setopt noclobber vi
setopt promptsubst # allow commands in prompts
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

mac32compile() {
    export ARCHFLAGS='-arch i386' CFLAGS='-arch i386' CXXFLAGS='-arch i386' LDFLAGS='-arch i386'
}

SCMSTATUS_FORMAT="{email_domain} on {branch} "
SCMSTATUS_TOOLS="$(scmstatus.py --tools)"
scmstatus() {
    echo $SCMSTATUS
}
scmstatus_precmd() {
    local update=0

    for tool in ${(@f)SCMSTATUS_TOOLS}; do
        case "$__SCMSTATUS_EXEC" in
            $tool*) update=1; break;;
        esac
    done

    if [[ $update == 1 ]]; then
        scmstatus_update
    fi

    unset __SCMSTATUS_EXEC
}
scmstatus_preexec() {
    __SCMSTATUS_EXEC=$1
}
scmstatus_update() {
    SCMSTATUS="$(scmstatus.py "$SCMSTATUS_FORMAT")"
}

keychain --quiet id_rsa
source $HOME/.keychain/$(hostname)-sh

#
# included zshrc configs
#

# start hub tab-completion script for zsh.
eval "$(hub alias -s)"
# end hub tab-completion script for zsh

#
# end included zshrc configs
#

if [[ -e $HOME/.current/zshrc ]]; then
    source $HOME/.current/zshrc
fi

if [[ -e $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi
