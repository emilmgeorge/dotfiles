# https://github.com/sigoden/aichat/issues/1030#issuecomment-3062604636

COPILOT_OAUTH_FILE="${COPILOT_OAUTH_FILE:-$HOME/.config/github-copilot/apps.json}"

# check if $COPILOT_API_KEY is set
# if it does run aichat "$@"
# otherwise run `load_copilot_key` then run `aichat`
# supports --silent flag to suppress the echo message from load_copilot_key
aichat() {
    # Check if --silent flag is present
    local silent_mode=false
    local -a new_argv
    local arg

    for arg in "$@"; do
        if [[ "$arg" == "--silent" ]]; then
            silent_mode=true
        else
            new_argv+=("$arg")
        fi
    done

    # Check if key is not set or if it has expired
    local need_refresh=false

    if [[ -z "$COPILOT_API_KEY" ]]; then
        need_refresh=true
    else
        # Extract expiration time from token and check if expired
        local current_time exp_string exp_time
        current_time=$(date +%s)

        # Try to extract expiration from token (assumes token contains "exp=TIMESTAMP")
        exp_string=$(print -r -- "$COPILOT_API_KEY" | grep -o "exp=[0-9]*" | head -n 1)

        if [[ -n "$exp_string" ]]; then
            exp_time=${exp_string#exp=}
            if (( current_time >= exp_time )); then
                # Token has expired
                need_refresh=true
            fi
        fi
    fi

    if [[ "$need_refresh" == true && -f "$COPILOT_OAUTH_FILE" ]]; then
        # Key is not set or has expired, so load a fresh one
        if [[ "$silent_mode" == true ]]; then
            load_copilot_key --silent
        else
            load_copilot_key
        fi
    fi

    # Run aichat with arguments
    command aichat "${new_argv[@]}"
}

# Load GitHub Copilot API key from hosts.json file
load_copilot_key() {
    # Check for silent flag
    local silent=false
    local arg
    for arg in "$@"; do
        if [[ "$arg" == "--silent" ]]; then
            silent=true
        fi
    done

    # Extract the OAuth token from GitHub Copilot hosts file
    local oauth_token
    oauth_token=$(jq -r 'to_entries[] | .value.oauth_token' "$COPILOT_OAUTH_FILE")

    export COPILOT_API_KEY=$(xhs api.github.com/copilot_internal/v2/token -Abearer -a "$oauth_token" | jq -r .token)

    # Print token for confirmation unless silent mode is enabled
    if [[ "$silent" == false ]]; then
        echo "aichat.zsh: API key set as \$COPILOT_API_KEY"
    fi
}
