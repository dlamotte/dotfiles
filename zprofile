source $HOME/.zshenv
if [[ -x $HOME/bin/keychain ]]; then
    $HOME/bin/keychain --quiet github
else
    keychain --quiet github
fi
source $HOME/.keychain/$(hostname)-sh
