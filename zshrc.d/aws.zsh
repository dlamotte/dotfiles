aws-decode() {
    aws sts decode-authorization-message --encoded-message "$@" | jq '.DecodedMessage' -r | jq -C '' | less
}
