local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
	}

	local config = default_config
	require 'telescope'.setup(config)

	-- Mappings
	require('which-key').register({
		["<leader>g"] = { name = "+go" },
		["<leader>gg"] = { "<cmd>Telescope lsp_definitions<cr>", "Go to definitions" },
		["<leader>gr"] = { "<cmd>Telescope lsp_references<cr>", "Go to references" },
	})
end

function M.setup()
	require 'packer'.use {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		requires = 'nvim-lua/plenary.nvim',
		after = 'which-key.nvim',
		config = M.configure,
	}
end

return M
