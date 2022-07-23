local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
	}

	local config = default_config
	require 'nvim-navic'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'SmiteshP/nvim-navic',
		requires = 'neovim/nvim-lspconfig',
		config = M.configure,
	}
end

return M
