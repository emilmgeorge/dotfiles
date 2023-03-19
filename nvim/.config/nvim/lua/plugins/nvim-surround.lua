local M = {}

function M.configure()
	require 'nvim-surround'.setup {}
end

function M.setup()
	require 'packer'.use {
		'kylechui/nvim-surround',
		config = M.configure,
	}
end

return M
