gocd() {
    cd $(go list -f '{{.Dir}}' .../$1 | head -1)
}
