local M = {}

function M.configure()
	require 'telescope'.setup {}

	-- Mappings
	require('which-key').register({
		["<leader>g"] = { name = "+go" },
		["<leader>gg"] = { "<cmd>Telescope lsp_definitions fname_width=40<cr>", "Go to definitions" },
		["<leader>gr"] = { "<cmd>Telescope lsp_references fname_width=40<cr>", "Go to references" },
		["<leader>gs"] = { "<cmd>Telescope lsp_document_symbols fname_width=40<cr>", "Go to document symbols" },
		["<leader>gws"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols fname_width=40<cr>", "Go to workspace symbols" },
		["<leader>gic"] = { "<cmd>Telescope lsp_incoming_calls fname_width=40<cr>", "Go to Incoming Calls" },
		["<leader>goc"] = { "<cmd>Telescope lsp_incoming_calls fname_width=40<cr>", "Go to Outgoing Calls" },

		["<leader>gj"] = { "<cmd>Telescope jumplist fname_width=40<cr>", "Go to jumplist history" },
		["<leader>gb"] = { "<cmd>Telescope buffers fname_width=40<cr>", "Go to buffer" },
		["<leader>gf"] = { "<cmd>Telescope find_files fname_width=40<cr>", "Go to file" },
		["<leader>ggf"] = { "<cmd>Telescope git_files fname_width=40<cr>", "Go to file" },
		["<leader>gy"] = { "<cmd>Telescope yank_history fname_width=40<cr>", "Yank History" },
	})
end

function M.setup()
	require 'packer'.use {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		requires = 'nvim-lua/plenary.nvim',
		config = M.configure,
	}
end

return M
