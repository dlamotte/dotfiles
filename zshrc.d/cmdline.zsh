# http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html
bindkey -M viins '^r' history-incremental-pattern-search-backward
bindkey -M vicmd '^r' history-incremental-pattern-search-backward

bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^U' kill-whole-line
bindkey -M viins '^Y' yank

zle -N edit-command-line
bindkey -M vicmd v edit-command-line

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^E' end-of-line
bindkey '^A' beginning-of-line
