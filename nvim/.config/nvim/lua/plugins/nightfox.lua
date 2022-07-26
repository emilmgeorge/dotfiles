local M = {}

function M.configure()
	require 'nightfox'.setup {}
	-- vim.cmd[[colorscheme nightfox]]
	-- vim.cmd[[highlight CursorLine guibg=#1a2a40]]
end

function M.setup()
	require 'packer'.use {
		'EdenEast/nightfox.nvim',
		config = M.configure,
	}
end

return M
