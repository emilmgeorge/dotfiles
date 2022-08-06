local M = {}

function M.init()
	vim.cmd[[colorscheme nightfox]]
	vim.cmd[[highlight CursorLine guibg=#1a2a40]]
end

function M.configure()
	require 'nightfox'.setup {}
	require 'themes'.init()
end

function M.setup()
	require 'packer'.use {
		'EdenEast/nightfox.nvim',
		config = M.configure,
	}
end

return M
