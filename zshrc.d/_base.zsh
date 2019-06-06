alias bc="bc -ql"
alias cp="cp -i"
alias egrep="egrep --color=auto"
alias grep="grep --color=auto"
alias info="info --vi-keys"
alias ls="ls -F --color=auto"
alias mv="mv -i"
alias rm="rm -i"

alias cscope="cscope -R -q"
alias gcc="gcc -pedantic -Wall"

# almost deleted
alias octave="octave --silent"
alias rdesktop="rdesktop -g 1024x768 -K -x b"

setopt appendhistory extendedglob
setopt autopushd
setopt histignorespace
setopt checkjobs hup checkrunningjobs
setopt noclobber vi
setopt promptsubst # allow commands in prompts
unsetopt autocd beep notify
unsetopt share_history
