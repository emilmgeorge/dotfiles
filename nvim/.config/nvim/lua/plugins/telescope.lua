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
	require 'which-key'.add({
		{ TELESCOPE_KEY_PREFIX, group = "telescope" },
	})

	vim.keymap.set('n', LSP_KEY_PREFIX .. 'g', "<cmd>Telescope lsp_definitions fname_width=40<cr>", { desc = "Go to definitions" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'i', "<cmd>Telescope lsp_incoming_calls fname_width=40<cr>", { desc = "Go to Incoming Calls" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'o', "<cmd>Telescope lsp_incoming_calls fname_width=40<cr>", { desc = "Go to Outgoing Calls" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'r', "<cmd>Telescope lsp_references fname_width=40<cr>", { desc = "Go to references" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 's', "<cmd>Telescope lsp_document_symbols fname_width=40<cr>", { desc = "Go to document symbols" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'w', "<cmd>Telescope lsp_dynamic_workspace_symbols fname_width=40<cr>", { desc = "Go to workspace symbols" })

	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'b', "<cmd>Telescope buffers fname_width=40<cr>", { desc = "Go to buffer" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'f', "<cmd>Telescope find_files fname_width=40<cr>", { desc = "Go to file" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'gf', "<cmd>Telescope git_files fname_width=40<cr>", { desc = "Go to git file" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'j', "<cmd>Telescope jumplist fname_width=40<cr>", { desc = "Go to jumplist history" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'y', ":Telescope yank_history<CR>", { desc = "Yank Ring history" })
end

function M.setup()
	return {
		'nvim-telescope/telescope.nvim',
		version = '0.1.5',
		dependencies = 'nvim-lua/plenary.nvim',
		config = M.configure,
	}
end

return M
