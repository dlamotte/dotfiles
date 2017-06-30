bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^U' kill-whole-line
bindkey -M viins '^Y' yank

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^E' end-of-line
bindkey '^A' beginning-of-line
