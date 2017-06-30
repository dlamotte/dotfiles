kube-namespace() {
    if [[ -z "$1" ]]; then
        unset KUBE_NAMESPACE
        unalias kubectl
    else
        export KUBE_NAMESPACE="$1"
        alias kubectl="kubectl --namespace ""$KUBE_NAMESPACE"""
    fi
}

source <(kubectl completion zsh)
