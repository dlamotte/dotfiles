HOSTNAME=$(hostname)
if [[ ${HOSTNAME} == "exyle" ]]; then
    keychain --quiet ~/.ssh/id_rsa
else
    keychain --quiet ~/.ssh/id_rsa.linode
fi
. ~/.keychain/${HOSTNAME}-sh
