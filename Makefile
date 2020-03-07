.PHONY: all clean install_all uninstall_all install_vim uninstall_vim install_tmux uninstall_tmux

all: install_all
clean: uninstall_all

install_all: install_vim install_tmux
uninstall_all: uninstall_vim uninstall_tmux

install_vim:
	stow -t ~/ vim
	stow -t ~/ nvim
uninstall_vim:
	stow -D -t ~/ vim
	stow -D -t ~/ nvim

install_tmux:
	stow -t ~/ tmux
uninstall_tmux:
	stow -D -t ~/ tmux


