local M = {}

TELESCOPE_KEY_PREFIX = '<Leader>t'
LSP_KEY_PREFIX = '<Leader>l'

function M.configure()
	vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")
	require 'telescope'.setup {
		defaults = {
			path_display = {
				'filename_first',
			},
			cycle_layout_list = { 'horizontal', 'vertical', 'center', 'flex', 'cursor', 'bottom_pane' },
			layout_strategy = 'horizontal',
			layout_config = {
				horizontal = {
					width = 0.95,
					height = 0.95,
					preview_width = 0.6,
				},
				vertical = {
					width = 0.9,
					height = 0.95,
					preview_height = 0.65,
				},
				center = {
					height = 0.5,
					preview_cutoff = 40,
					prompt_position = 'bottom',
					width = 0.7,
					preview_height = 0.4,
				},
			},
			mappings = {
				i = {
					["<Esc>"] = require('telescope.actions').close,
					["<C-u>"] = require('telescope.actions.layout').cycle_layout_next,
					["<C-d>"] = require('telescope.actions.layout').cycle_layout_prev,
					["<C-b>"] = require('telescope.actions').results_scrolling_left,
					["<C-f>"] = require('telescope.actions').results_scrolling_right,
					["<M-u>"] = require('telescope.actions').preview_scrolling_up,
					["<M-d>"] = require('telescope.actions').preview_scrolling_down,
					["<M-b>"] = require('telescope.actions').preview_scrolling_left,
					["<M-f>"] = require('telescope.actions').preview_scrolling_right,
					["<M-s>"] = require('telescope.actions').file_split,
					["<M-S>"] = require('telescope.actions').file_vsplit,
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
