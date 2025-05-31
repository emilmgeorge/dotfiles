source <(fzf --zsh)

# Set custom bindings
bindkey '^g^f^f' fzf-file-widget
bindkey '^g^f^d' fzf-cd-widget

# Restore default zsh bindings
bindkey '^t' transpose-chars
bindkey '^[c' capitalize-word

# Rename and wrap the original history-widget function to add more features
functions -c fzf-history-widget fzf-history-widget-orig

fzf-history-widget() {
	local SEP="\x1F"

	local DELETE_TRANSFORM="[ \"\$FZF_SELECT_COUNT\" -gt 0 ] && printf \"+print(${SEP}d${SEP}%s)\" \"{r+1}\";"
	FZF_CTRL_R_OPTS="
	--bind 'start:change-multi'
	--bind 'ctrl-d:toggle'
	--bind 'ctrl-l:deselect-all'
	--bind 'ctrl-x:transform(
		$DELETE_TRANSFORM
		printf \"+print(${SEP}x${SEP})\" {q};
	)+clear-selection+accept'
	--bind 'enter:transform(
		$DELETE_TRANSFORM
		[ \"\$FZF_MATCH_COUNT\" -gt 0 ] && printf \"+print(${SEP}a${SEP}%s)\" \"{r1}\" ||
		printf \"+print(%s)\" {q};
	)+clear-selection+accept'
	--bind 'tab:ignore'
	" fzf-history-widget-orig "$@" >/dev/null 2>&1

	local out="$LBUFFER"
	BUFFER=""
	zle -R

	# Save accepted entry before possible deletion in the next step.
	local accept
	accept="$(awk -F"$SEP" '$2 == "a" { print $3; exit }' <<< "$out")"
	[ -n "$accept" ] && { accept=$(fc -l $accept $accept | awk '{ $1=""; sub(/^[ \t]+/, ""); gsub(/\\n/, "\n"); print }') }

	# Delete selected entries
	local delete
	delete="$(awk -F"$SEP" '$2 == "d" { print $3; exit }' <<< "$out")"
	[ -n "$delete" ] && { echo; hist -i delete ${=delete}; zle reset-prompt; }

    local delete_only
	delete_only="$(awk -F"$SEP" '$2 == "x" { print 1; exit }' <<< "$out")"
	if [ -n "$accept" ]; then
        # User explicitly accepted an entry
		LBUFFER="$accept"
	elif [ "$delete_only" != "1" ]; then
        # User explicitly accepted a custom query
		LBUFFER="$(grep -Pv "^$SEP" <<< "$out")"
	fi
}
