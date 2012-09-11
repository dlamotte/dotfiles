if [[ -x $HOME/bin/keychain ]]; then
    $HOME/bin/keychain --quiet id_rsa
else
    keychain --quiet id_rsa
fi
source $HOME/.keychain/$(hostname)-sh
