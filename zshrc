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

if [[ $- != *i* ]]; then
    # non-interactive, return now
    return
fi

if [[ -z $LS_COLORS ]]; then
    eval $(dircolors)
fi

alias bc="bc -ql"
alias cp="cp -i"
alias cscope="cscope -R -q"
alias egrep="egrep --color=auto"
alias gcc="gcc -pedantic -Wall"
alias grep="grep --color=auto"
alias info="info --vi-keys"
alias ls="ls -F --color=auto"
alias mq='hg -R $(hg root)/.hg/patches'
alias mv="mv -i"
alias octave="octave --silent"
alias rdesktop="rdesktop -g 1024x768 -K -x b"
alias rm="rm -i"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

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

SCMSTATUS_FORMAT="{email_domain} {branch} "
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
scmstatus_update # init right away

keychain --quiet id_rsa
source $HOME/.keychain/$(hostname)-sh

demo() {
    export RPS1=
    export PS1=$PS1_DEMO
}
nodemo() {
    export RPS1=$RPS1_BACKUP
    export PS1=$PS1_BACKUP
}

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
