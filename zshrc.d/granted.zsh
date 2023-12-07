# brew tap common-fate/granted
# brew install granted
# run: assume

function assume() {
    source assume "$@"

    # granted sets these as well as AWS_PROFILE, these are problematic for any
    # terraform that points to a specific profile as aws sdks prefer env creds
    # to profile settings by default
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}
