.PHONY: all clean install_all uninstall_all install_vim uninstall_vim install_tmux uninstall_tmux install_spacemacs uninstall_spacemacs

all: install_all
clean: uninstall_all

install_all: install_vim install_tmux install_spacemacs
uninstall_all: uninstall_vim uninstall_tmux uninstall_spacemacs

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

install_spacemacs:
	@if [ -d "${HOME}/.emacs.d" ]; then \
		echo "Path ~/.emacs.d already exists. Please remove it and run 'make install_spacemacs' again. Otherwise spacemacs will not work. Other spacemacs files will still be installed."; \
	else \
		git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d; \
	fi; \
	stow -t ~/ spacemacs;

uninstall_spacemacs:
	stow -D -t ~/ spacemacs
	echo "Please rm -rf ~/.emacs.d manually."


