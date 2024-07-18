.PHONY: all
all: install_all

.PHONY: clean
clean: uninstall_all

.PHONY: install_all
install_all: \
	install_emacs \
	install_git \
	install_nvim \
	install_spacemacs \
	install_tig \
	install_tmux \
	install_vim \
	;

.PHONY: uninstall_all
uninstall_all: \
	uninstall_emacs \
	uninstall_git \
	uninstall_nvim \
	uninstall_spacemacs \
	uninstall_tig \
	uninstall_tmux \
	uninstall_vim \
	;

.PHONY: install_emacs
install_emacs:
	stow -t ~/ emacs;
.PHONY: uninstall_emacs
uninstall_emacs:
	stow -D -t ~/ emacs;

.PHONY: install_git
install_git:
	stow -t ~/ git;
.PHONY: uninstall_git
uninstall_git:
	stow -D -t ~/ git;

.PHONY: install_nvim
install_nvim:
	stow -t ~/ nvim
	stow -t ~/ nvim-lazy
.PHONY: uninstall_nvim
uninstall_nvim:
	stow -D -t ~/ nvim
	stow -D -t ~/ nvim-lazy

.PHONY: install_spacemacs
install_spacemacs:
	@if [ -d "${HOME}/.emacs.d" ]; then \
		echo "Path ~/.emacs.d already exists. Please remove it and run 'make install_spacemacs' again. Otherwise spacemacs will not work. Other spacemacs files will still be installed."; \
	else \
		git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d; \
	fi; \
	stow -t ~/ spacemacs;
.PHONY: uninstall_spacemacs
uninstall_spacemacs:
	stow -D -t ~/ spacemacs
	echo "Please rm -rf ~/.emacs.d manually."

.PHONY: install_tig
install_tig:
	stow -t ~/ tig;
.PHONY: uninstall_tig
uninstall_tig:
	stow -D -t ~/ tig;

.PHONY: install_tmux
install_tmux:
	stow -t ~/ tmux
.PHONY: uninstall_tmux
uninstall_tmux:
	stow -D -t ~/ tmux

.PHONY: install_vim
install_vim:
	stow -t ~/ vim
.PHONY: uninstall_vim
uninstall_vim:
	stow -D -t ~/ vim
