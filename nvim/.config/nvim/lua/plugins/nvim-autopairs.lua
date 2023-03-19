local M = {}

function M.configure()
	require 'nvim-autopairs'.setup {}
end

function M.setup()
	require 'packer'.use {
		'windwp/nvim-autopairs',
		config = M.configure,
	}
end

return M
