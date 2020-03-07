.PHONY: all clean install_all uninstall_all install_vim uninstall_vim

all: install_all
clean: uninstall_all

install_all: install_vim
uninstall_all: uninstall_vim

install_vim:
	stow -t ~/ vim
	stow -t ~/ nvim
uninstall_vim:
	stow -D -t ~/ vim
	stow -D -t ~/ nvim



