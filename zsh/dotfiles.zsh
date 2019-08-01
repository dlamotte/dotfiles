zmodload zsh/datetime

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

function _dotfiles_current_epoch() {
    echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _dotfiles_update_dotfiles_update() {
    echo "DOTFILES_LAST_UPDATED=$(_dotfiles_current_epoch)" >! ~/.dotfiles.update
}

function _dotfiles_upgrade() {
    printf "${BLUE}%s${NORMAL}\n" 'dotfiles: upgrading'
    cd ~/.dotfiles
    if git pull --rebase --stat origin master; then
        printf "${GREEN}%s${NORMAL}\n" 'dotfiles: upgraded'
        git log --pretty=oneline --abbrev-commit "HEAD@{1}..HEAD"
        ./lndotfiles.py
    else
        printf "${RED}%s${NORMAL}\n" 'dotfiles: error upgrading'
    fi
    cd $OLDPWD
    _dotfiles_update_dotfiles_update
}

if [ -f ~/.dotfiles.update ]; then
    source ~/.dotfiles.update

    if [[ -z "$DOTFILES_LAST_UPDATED" ]]; then
        _dotfiles_update_dotfiles_update && return 0
    fi

    epoch_diff=$(($(_dotfiles_current_epoch) - $DOTFILES_LAST_UPDATED))
    if [ $epoch_diff -ge 1 ]; then
        _dotfiles_upgrade
    fi
else
    _dotfiles_update_dotfiles_update
fi
