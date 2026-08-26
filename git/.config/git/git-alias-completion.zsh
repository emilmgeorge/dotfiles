# Tab completion for shell (`!`) git aliases defined in git/.config/git/config.

# svnco -> first arg is an SVN revision (rNNNN), rest are passed to git switch
_git-svnco() {
  _arguments -S \
    '1: :compadd -S "" -- r' \
    '*:: :_git-switch'
}

# show_alias -> complete existing git alias names (grep filter arg)
_git-alias() {
  _arguments -S '1: :__git_aliases'
}

# step_to_ref -> git switch
_git-step() { _git-switch }

# log_oneline -> git log
_git-ol() { _git-log }
_git-sl() { _git-log }
_git-ml() { _git-log }
_git-ll() { _git-log }

# branch_info -> git branch
_git-branch-info() { _git-branch }

# log_upstream -> git log
_git-lu() { _git-log }

# list_skipped -> takes an optional path argument
_git-skipped-ls() {
  _arguments -S '*:path:_files'
}

# list_conflicts -> takes no arguments
_git-conflicts-ls() {
  _message 'no arguments'
}

# archive_branch -> git branch
_git-archive-branch() { _git-branch }
