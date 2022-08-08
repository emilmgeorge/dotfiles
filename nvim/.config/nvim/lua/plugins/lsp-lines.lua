local M = {}

function M.configure()
	require 'lsp_lines'.setup()
	vim.diagnostic.config({
		virtual_text = true,
		virtual_lines = false,
	})
	require 'which-key'.register({
		["<leader>mltl"] = {
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
		after = 'which-key.nvim',
		config = M.configure,
	}
end

return M
