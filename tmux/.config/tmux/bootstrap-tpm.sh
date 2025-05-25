#!/usr/bin/env bash

tmux set -g status-right-length 100

tmux set -gF status-right "#[bg=red] TPM Bootstrap: downloading TPM... "
mkdir -p "${TMUX_PLUGIN_MANAGER_PATH}"
git clone https://github.com/tmux-plugins/tpm "${TMUX_PLUGIN_MANAGER_PATH}/tpm"

tmux set -gF status-right "#[bg=red] TPM Bootstrap: patching TPM... "
git -C "${TMUX_PLUGIN_MANAGER_PATH}/tpm" am ${TMUX_CONFIG_DIR}/plugin-files/tpm/patches/*.patch

tmux set -gF status-right "#[bg=red] TPM Bootstrap: installing plugins... "
"${TMUX_PLUGIN_MANAGER_PATH}/tpm/bin/install_plugins"

tmux set -gF status-right "#[bg=red] TPM Bootstrap: re-sourcing tmux config... "
tmux source-file "${TMUX_CONFIG_DIR}/tmux.conf"
