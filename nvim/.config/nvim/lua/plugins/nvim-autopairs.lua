local M = {}

function M.configure()
	local config = {
	}

	require 'nvim-autopairs'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'windwp/nvim-autopairs',
		config = M.configure,
	}
end

return M
