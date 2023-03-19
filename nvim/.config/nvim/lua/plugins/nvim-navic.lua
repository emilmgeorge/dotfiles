local M = {}

function M.configure()
	require 'nvim-navic'.setup {}
end

function M.setup()
	require 'packer'.use {
		'SmiteshP/nvim-navic',
		requires = 'neovim/nvim-lspconfig',
		config = M.configure,
	}
end

return M
