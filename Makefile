.PHONY: all clean install_all uninstall_all install_vim uninstall_vim install_tmux uninstall_tmux install_spacemacs uninstall_spacemacs install_git uninstall_git install_tig uninstall_tig install_emacs uninstall_emacs

all: install_all
clean: uninstall_all

install_all: install_vim install_tmux install_spacemacs install_git install_tig install_emacs
uninstall_all: uninstall_vim uninstall_tmux uninstall_spacemacs uninstall_git uninstall_tig uninstall_emacs

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

install_git:
	stow -t ~/ git;
uninstall_git:
	stow -D -t ~/ git;

install_tig:
	stow -t ~/ tig;
uninstall_tig:
	stow -D -t ~/ tig;

install_emacs:
	stow -t ~/ emacs;
uninstall_emacs:
	stow -D -t ~/ emacs;
