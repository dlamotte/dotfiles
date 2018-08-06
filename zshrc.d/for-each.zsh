for-each-item() {
    local cmd="$1"
    shift

    for item in "$@"; do
        echo $item
        eval "$cmd"
        echo
    done
}
