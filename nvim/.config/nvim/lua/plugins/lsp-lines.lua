local M = {}

LSP_KEY_PREFIX = '<leader>l'
LSP_LINES_KEY = LSP_KEY_PREFIX .. 'l'

function M.configure()
	require 'lsp_lines'.setup()
	vim.diagnostic.config({
		virtual_text = true,
		virtual_lines = false,
	})
	require 'which-key'.register({
		[LSP_LINES_KEY] = {
			function()
				local lines = require 'lsp_lines'.toggle()
				vim.diagnostic.config({
					virtual_text = not lines,
				})
			end,
			"Toggle LSP lines"
		},
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
		config = M.configure,
		keys = LSP_LINES_KEY,
	}
end

return M
