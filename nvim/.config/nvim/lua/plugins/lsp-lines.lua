local M = {}

LSP_KEY_PREFIX = '<leader>l'
LSP_LINES_KEY = LSP_KEY_PREFIX .. 'l'

function M.configure()
	require 'lsp_lines'.setup()
	vim.diagnostic.config({
		virtual_text = true,
		virtual_lines = false,
	})

	vim.keymap.set('n', LSP_LINES_KEY,
	function()
		local lines = require 'lsp_lines'.toggle()
		vim.diagnostic.config({
			virtual_text = not lines,
		})
	end,
	{ desc = "Toggle LSP lines" })
end

function M.setup()
	return {
		'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
		config = M.configure,
	}
end

return M
