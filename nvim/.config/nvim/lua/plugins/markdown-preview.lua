local M = {}

MP_KEY_PREFIX = '<leader>mm'

function M.configure()
	vim.cmd[[
	let g:mkdp_command_for_global = 1
	]]

	require 'which-key'.register({
		[MP_KEY_PREFIX] = { name = '+markdown'},
		[MP_KEY_PREFIX .. 'p'] = { "<Plug>MarkdownPreview" , "Markdown Preview" },
	}, {remap = true, silent = true})
end

function M.setup()
	require 'packer'.use {
		'iamcco/markdown-preview.nvim',
		run = function() vim.fn["mkdp#util#install"]() end,
		config = M.configure,
	}
end

return M
