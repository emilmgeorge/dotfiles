local M = {}

function M.configure()
	-- Time in milliseconds (default 0)
	vim.g.Illuminate_delay = 0
end

function M.setup()
	require 'packer'.use {
		'RRethy/vim-illuminate',
		config = M.configure,
	}
end

return M
