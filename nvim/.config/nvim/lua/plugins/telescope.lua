local M = {}

TELESCOPE_KEY_PREFIX = '<leader>t'
LSP_KEY_PREFIX = '<leader>l'

function M.configure()
	require 'telescope'.setup {
		defaults = {
			mappings = {
				i = {
					["<ESC>"] = require('telescope.actions').close,
				},
			},
		},
	}

	-- Mappings
	require('which-key').register({
		[LSP_KEY_PREFIX .. 'g'] = { "<cmd>Telescope lsp_definitions fname_width=40<cr>", "Go to definitions" },
		[LSP_KEY_PREFIX .. 'r'] = { "<cmd>Telescope lsp_references fname_width=40<cr>", "Go to references" },
		[LSP_KEY_PREFIX .. 's'] = { "<cmd>Telescope lsp_document_symbols fname_width=40<cr>", "Go to document symbols" },
		[LSP_KEY_PREFIX .. 'w'] = { "<cmd>Telescope lsp_dynamic_workspace_symbols fname_width=40<cr>", "Go to workspace symbols" },
		[LSP_KEY_PREFIX .. 'i'] = { "<cmd>Telescope lsp_incoming_calls fname_width=40<cr>", "Go to Incoming Calls" },
		[LSP_KEY_PREFIX .. 'o'] = { "<cmd>Telescope lsp_incoming_calls fname_width=40<cr>", "Go to Outgoing Calls" },

		[TELESCOPE_KEY_PREFIX] = { name = "+telescope" },
		[TELESCOPE_KEY_PREFIX .. 'j'] = { "<cmd>Telescope jumplist fname_width=40<cr>", "Go to jumplist history" },
		[TELESCOPE_KEY_PREFIX .. 'b'] = { "<cmd>Telescope buffers fname_width=40<cr>", "Go to buffer" },
		[TELESCOPE_KEY_PREFIX .. 'f'] = { "<cmd>Telescope find_files fname_width=40<cr>", "Go to file" },
		[TELESCOPE_KEY_PREFIX .. 'gf'] = { "<cmd>Telescope git_files fname_width=40<cr>", "Go to file" },
		[TELESCOPE_KEY_PREFIX .. 'y'] = { ":Telescope yank_history<CR>", "Yank Ring history" },
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
