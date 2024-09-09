.PHONY: all
all: install_all

.PHONY: install_all
install_all: \
	install_emacs \
	install_git \
	install_kitty \
	install_less \
	install_nvim \
	install_spacemacs \
	install_tig \
	install_tmux \
	install_tridactyl \
	install_vim \
	install_wezterm \
	install_zsh \
	;

.PHONY: uninstall_all
uninstall_all: \
	uninstall_emacs \
	uninstall_git \
	uninstall_kitty \
	uninstall_less \
	uninstall_nvim \
	uninstall_spacemacs \
	uninstall_tig \
	uninstall_tmux \
	uninstall_tridactyl \
	uninstall_vim \
	uninstall_wezterm \
	uninstall_zsh \
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

.PHONY: install_kitty
install_kitty:
	stow -t ~/ kitty
.PHONY: uninstall_kitty
uninstall_kitty:
	stow -D -t ~/ kitty

.PHONY: install_less
install_less:
	stow -t ~/ less
.PHONY: uninstall_less
uninstall_less:
	stow -D -t ~/ less

.PHONY: install_nvim
install_nvim:
	stow -t ~/ nvim
	stow -t ~/ nvim-lazy
.PHONY: uninstall_nvim
uninstall_nvim:
	stow -D -t ~/ nvim
	stow -D -t ~/ nvim-lazy
.PHONY: clean_nvim
clean_nvim:
ifeq ($(C),)
	rm -rf ~/.cache/nvim;
	rm -rf ~/.local/share/nvim;
	rm -rf ~/.local/state/nvim;
else
	rm -rf ~/.cache/nvim-$(C);
	rm -rf ~/.local/share/nvim-$(C);
	rm -rf ~/.local/state/nvim-$(C);
endif

.PHONY: install_spacemacs
install_spacemacs:
	@if [ -d "${HOME}/.emacs.d" ]; then \
		echo "Path ~/.emacs.d already exists. You may want to remove it and run 'make $@' again. Spacemacs config files will still be installed."; \
	else \
		echo "Cloning Spacemacs to ~/.emacs.d ..."; \
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

.PHONY: install_tridactyl
install_tridactyl:
	stow -t ~/ tridactyl
.PHONY: uninstall_tridactyl
uninstall_tridactyl:
	stow -D -t ~/ tridactyl

.PHONY: install_vim
install_vim:
	stow -t ~/ vim
.PHONY: uninstall_vim
uninstall_vim:
	stow -D -t ~/ vim

.PHONY: install_wezterm
install_wezterm:
	stow -t ~/ wezterm
.PHONY: uninstall_wezterm
uninstall_wezterm:
	stow -D -t ~/ wezterm

.PHONY: install_zsh
install_zsh:
	stow -t ~/ zsh
.PHONY: uninstall_zsh
uninstall_zsh:
	stow -D -t ~/ zsh
