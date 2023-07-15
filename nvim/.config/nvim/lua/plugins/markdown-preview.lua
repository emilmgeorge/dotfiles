local M = {}

function M.configure()
	vim.cmd[[
	let g:mkdp_command_for_global = 1
	]]

	require 'which-key'.register({
		["<leader>mp"] = { "<Plug>MarkdownPreview" , "Markdown Preview" },
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
