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

zmodload -i zsh/complist
