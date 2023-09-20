eval "$(goenv init -)"

_reinit_goenv_version=$(go version)
_reinit_goenv_when_changed() {
    local v=$(go version)
    if [[ $v != $_reinit_goenv_version ]]; then
        eval "$(goenv init -)"
    fi
}
precmd_functions+=(_reinit_goenv_when_changed)
