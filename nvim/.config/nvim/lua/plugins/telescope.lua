local M = {}

function M.configure()
	-- Default configuration
	local config = {
		defaults = {
			sorting_strategy = 'ascending',
			scroll_strategy = 'limit',
			layout_strategy = 'vertical',
			initial_mode = 'normal',
			layout_config = {
				horizontal = {
					width = 0.99,
					height = 0.99,
					prompt_position = 'top',
					preview_width = 0.6,
				},
				vertical = {
					width = 0.99,
					height = 0.99,
					prompt_position = 'top',
					preview_height = 0.6,
				},
			},
		},
	}

	require 'telescope'.setup(config)

	-- Mappings
	require('which-key').register({
		["<leader>g"] = { name = "+go" },
		["<leader>gg"] = { "<cmd>Telescope lsp_definitions<cr>", "Go to definitions" },
		["<leader>gr"] = { "<cmd>Telescope lsp_references<cr>", "Go to references" },
		["<leader>gs"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Go to symbol" },
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
