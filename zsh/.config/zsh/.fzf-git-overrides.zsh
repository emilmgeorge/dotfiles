# Override this fzf-git function:
# https://github.com/junegunn/fzf-git.sh/blob/3ec3e97d1cc75ec97c0ab923ed5aa567aee01a5e/fzf-git.sh#L163
_fzf_git_fzf() {
	# Copy of original function that we are wrapping.
	_fzf_git_fzf_orig() {
		fzf --height 50% --tmux 90%,70% \
			--layout reverse --multi --min-height 20+ --border \
			--no-separator --header-border horizontal \
			--border-label-pos 2 \
			--color 'label:blue' \
			--preview-window 'right,50%' --preview-border line \
			--bind 'ctrl-/:change-preview-window(down,50%|hidden|)' "$@"
	}

	# _fzf_git_* function-specific option overrides
	local FN_OPTS=()

	if [[ "${funcstack[2]}" == "_fzf_git_hashes" ]]; then
		# Add bind: ctrl-f -> git show {}    (f for forward)
		# GIT_PAGER should never skip the paging even for short diffs.
		# Otherwise fzf won't be able to show short diffs (returns immediately).
		local git_pager segments last_segment token pager_cmd
		git_pager=$(git var GIT_PAGER)
		segments=("${(s:|:)git_pager}")
		last_segment=${segments[-1]## }
		for token in ${(z)last_segment}; do
			[[ "$token" == *=* ]] || { pager_cmd=$token; break }
		done
		if [[ $pager_cmd == "delta" ]]; then
			git_pager="$git_pager --paging always --pager \"less --+quit-if-one-screen\""
		elif [[ $pager_cmd == "less" ]]; then
			git_pager="$git_pager --+quit-if-one-screen"
		fi
		FN_OPTS+=("--bind" "ctrl-f:execute:clear; grep -o '[a-f0-9]\{7,\}' <<< {} | head -n 1 | GIT_PAGER='$git_pager' xargs git show --color=$(__fzf_git_color)")
	fi;

	# Finally cally the original function (above) adding some general overrides.
	_fzf_git_fzf_orig \
		"$@" \
		--tmux 95%,95% \
		--preview-window 'down,60%,wrap,cycle' \
		--bind "ctrl-y:preview-up" \
		--bind "ctrl-u:preview-half-page-up" \
		--bind "ctrl-e:preview-down" \
		--bind "ctrl-d:preview-half-page-down" \
		--bind "ctrl-\:toggle-preview-wrap" \
		"${FN_OPTS[@]}"
		;
}

# If fzf-git is lazy-loaded, then our override written above, will be defined
# first. When fzf-git later loads, our "override" be overriden and reverted to
# the original. Defining the below variable (notice the double underscore) will
# prevent fzf-git from defining (and overriding our) _fzf_git_fzf.
__fzf_git_fzf=':'

