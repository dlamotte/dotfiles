# strip the trailing newline before encoding.
# handy when passing selected text through vim
b64encode() {
    if base64 --help | grep GNU &>/dev/null; then
        B64_NOWRAP="--wrap 0"
    fi

    awk 'NR>1{print PREV} {PREV=$0} END{printf("%s",$0)}' | base64 $B64_NOWRAP

    unset B64_NOWRAP
}

b64decode() {
    base64 --decode
}
