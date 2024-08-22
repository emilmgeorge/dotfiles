local M = {}

TELESCOPE_KEY_PREFIX = '<Leader>t'
LSP_KEY_PREFIX = '<Leader>l'

function M.configure()
	require 'telescope'.setup {
		defaults = {
			mappings = {
				i = {
					["<Esc>"] = require('telescope.actions').close,
				},
			},
		},
	}

	-- Mappings
	require 'which-key'.add({
		{ TELESCOPE_KEY_PREFIX, group = "telescope" },
	})

	vim.keymap.set('n', LSP_KEY_PREFIX .. 'g', "<Cmd>Telescope lsp_definitions fname_width=40<CR>", { desc = "Go to definitions" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'i', "<Cmd>Telescope lsp_incoming_calls fname_width=40<CR>", { desc = "Go to Incoming Calls" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'o', "<Cmd>Telescope lsp_incoming_calls fname_width=40<CR>", { desc = "Go to Outgoing Calls" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'r', "<Cmd>Telescope lsp_references fname_width=40<CR>", { desc = "Go to references" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 's', "<Cmd>Telescope lsp_document_symbols fname_width=40<CR>", { desc = "Go to document symbols" })
	vim.keymap.set('n', LSP_KEY_PREFIX .. 'w', "<Cmd>Telescope lsp_dynamic_workspace_symbols fname_width=40<CR>", { desc = "Go to workspace symbols" })

	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'b', "<Cmd>Telescope buffers fname_width=40<CR>", { desc = "Go to buffer" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'f', "<Cmd>Telescope find_files fname_width=40<CR>", { desc = "Go to file" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'gf', "<Cmd>Telescope git_files fname_width=40<CR>", { desc = "Go to git file" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'j', "<Cmd>Telescope jumplist fname_width=40<CR>", { desc = "Go to jumplist history" })
	vim.keymap.set('n', TELESCOPE_KEY_PREFIX .. 'y', "<Cmd>Telescope yank_history<CR>", { desc = "Yank Ring history" })
end

function M.setup()
	return {
		'nvim-telescope/telescope.nvim',
		dependencies = 'nvim-lua/plenary.nvim',
		config = M.configure,
	}
end

return M
