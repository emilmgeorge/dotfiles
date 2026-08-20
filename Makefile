# Generic targets =============================================================|

# Add apps that use generic logic:
#	install: stow -t ~/ <app>
#	uninstall: stow -D -t ~/ <app>
#	reinstall: uninstall install

GENERIC_APPS += atuin
GENERIC_APPS += emacs
GENERIC_APPS += git
GENERIC_APPS += gitui
GENERIC_APPS += hypr
GENERIC_APPS += kitty
GENERIC_APPS += less
GENERIC_APPS += misc/ra-multiplex
GENERIC_APPS += tig
GENERIC_APPS += tmux
GENERIC_APPS += tridactyl
GENERIC_APPS += vim
GENERIC_APPS += wezterm
GENERIC_APPS += zsh

# Custom targets ==============================================================|

.PHONY: nvim-install
nvim-install:
	stow -t ~/ nvim
	stow -t ~/ nvim-astro
	stow -t ~/ nvim-lazy
.PHONY: nvim-uninstall
nvim-uninstall:
	stow -D -t ~/ nvim
	stow -D -t ~/ nvim-astro
	stow -D -t ~/ nvim-lazy
.PHONY: nvim-reinstall
nvim-reinstall: nvim-uninstall nvim-install
.PHONY: nvim-clean
nvim-clean:
ifeq ($(C),)
	rm -rf ~/.cache/nvim;
	rm -rf ~/.local/share/nvim;
	rm -rf ~/.local/state/nvim;
else
	rm -rf ~/.cache/nvim-$(C);
	rm -rf ~/.local/share/nvim-$(C);
	rm -rf ~/.local/state/nvim-$(C);
endif

.PHONY: spacemacs-install
spacemacs-install:
	@if [ -d "${HOME}/.emacs.d" ]; then \
		echo "Path ~/.emacs.d already exists. You may want to remove it and run 'make install spacemacs' again. Spacemacs config files will still be installed."; \
	else \
		echo "Cloning Spacemacs to ~/.emacs.d ..."; \
		git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d; \
	fi;
	stow -t ~/ spacemacs;
.PHONY: spacemacs-uninstall
spacemacs-uninstall:
	stow -D -t ~/ spacemacs
	@echo "Please rm -rf ~/.emacs.d manually."
.PHONY: spacemacs-reinstall
spacemacs-reinstall:
	stow -R -t ~/ spacemacs

# CLI logic ===================================================================|

# Create generic app targets
GENERIC_INSTALL_TARGETS := $(addsuffix -install, $(GENERIC_APPS))
.PHONY: $(GENERIC_INSTALL_TARGETS)
$(GENERIC_INSTALL_TARGETS):
	stow -d $(patsubst %-install,%, $@) -t ~/ .
GENERIC_UNINSTALL_TARGETS := $(addsuffix -uninstall, $(GENERIC_APPS))
.PHONY: $(GENERIC_UNINSTALL_TARGETS)
$(GENERIC_UNINSTALL_TARGETS):
	stow -D -d $(patsubst %-uninstall,%, $@) -t ~/ .
$(foreach app,$(GENERIC_APPS), \
  $(eval .PHONY: $(app)-reinstall) \
  $(eval $(app)-reinstall: $(app)-uninstall $(app)-install) \
)

# First target is the command (eg. install, uninstall, clean)
COMMAND := $(firstword $(MAKECMDGOALS))

# Command is followed by the list of apps
ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
ARG_TARGETS := $(addsuffix -$(COMMAND), $(ARGS))

# Generate a list of defined targets and valid apps.
# https://stackoverflow.com/a/26339924/1589191
LITERAL_HASH := \#
ALL_TARGETS ?= $(shell LC_ALL=C $(MAKE) ALL_TARGETS=1 -pRrq \
		-f $(firstword $(MAKEFILE_LIST)) $(MAKECMDGOALS) 2>/dev/null \
	| awk -v RS= -F: '/(^|\n)$(LITERAL_HASH) Files(\n|$$)/,/(^|\n)\
		$(LITERAL_HASH) Finished Make data base/ \
		{if ($$1 !~ "^[$(LITERAL_HASH).]") {print $$1}}' \
	| sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$')
ALL_APPS := $(sort $(foreach t,$(filter-out _%,$(ALL_TARGETS)),$(firstword $(subst -, ,$(t)))))

.PHONY: _listapps
_listapps:
	@echo $(ALL_APPS)

# Verify that all the required targets are defined.
.PHONY: _checktargets
_checktargets:
	@$(foreach app,$(ARGS), \
		if [ -z "$(strip $(filter $(app)-$(COMMAND),$(ALL_TARGETS)))" ]; then \
			echo "Error: No definition for '$(COMMAND) $(app)'."; exit 1; \
		fi;)

# Dependency list for the special 'all' argument. (eg. make install all)
COMMAND_ALL_TARGETS := $(filter-out all-$(COMMAND), $(sort $(filter %-$(COMMAND), $(ALL_TARGETS))))

# Define all-$(COMMAND) target.
.PHONY: all-$(COMMAND)
all-$(COMMAND): $(COMMAND_ALL_TARGETS)

ifneq ($(COMMAND_ALL_TARGETS),)
# If $(COMMAND) is a valid command (ie., any <app>-$(COMMAND) is defined), then
# define $(COMMAND) target.
.PHONY: $(COMMAND)
$(COMMAND): _checktargets $(ARG_TARGETS)
endif

# Make will run $(ARGS) as separate targets after running $(COMMAND).
# This rule makes those no-op.
.PHONY: $(ARGS)
$(ARGS):
	@:
