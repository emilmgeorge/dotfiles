local M = {}

function M.configure()
	require 'telescope'.setup {}

	-- Mappings
	require('which-key').register({
		["<leader>g"] = { name = "+go" },
		["<leader>gg"] = { "<cmd>Telescope lsp_definitions fname_width=40<cr>", "Go to definitions" },
		["<leader>gr"] = { "<cmd>Telescope lsp_references fname_width=40<cr>", "Go to references" },
		["<leader>gs"] = { "<cmd>Telescope lsp_document_symbols fname_width=40<cr>", "Go to symbol" },
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
