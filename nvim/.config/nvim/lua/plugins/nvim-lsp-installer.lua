local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
		ensure_installed = {},
		automatic_installation = false,
		ui = {
			icons = {
				server_installed = "✓",
				server_pending = "➜",
				server_uninstalled = "✗"
			}
		}
	}

	local config = default_config
	require 'nvim-lsp-installer'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'williamboman/nvim-lsp-installer',
		requires = 'neovim/nvim-lspconfig',
		after = 'nvim-lspconfig',
		config = M.configure,
	}
end

return M
