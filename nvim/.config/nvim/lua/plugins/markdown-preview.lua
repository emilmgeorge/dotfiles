local M = {}

MP_KEY_PREFIX = '<Leader>mm'

function M.configure()
	vim.cmd[[
	let g:mkdp_command_for_global = 1
	]]

	vim.keymap.set('n', MP_KEY_PREFIX .. 'p', "<Plug>MarkdownPreview", { desc = "Markdown Preview" })
end

function M.setup()
	return {
		'iamcco/markdown-preview.nvim',
		build = function() vim.fn["mkdp#util#install"]() end,
		config = M.configure,
	}
end

return M
