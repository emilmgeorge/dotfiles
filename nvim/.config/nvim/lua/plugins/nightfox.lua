local M = {}

function M.configure()
	require 'nightfox'.setup {}
	vim.cmd[[colorscheme nightfox]]
end

function M.setup()
	require 'packer'.use {
		'EdenEast/nightfox.nvim',
		config = M.configure,
	}
end

return M
