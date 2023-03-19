local M = {}

function M.configure()
	require 'nvim-lsp-installer'.setup {}
end

function M.setup()
	require 'packer'.use {
		'williamboman/nvim-lsp-installer',
		requires = 'neovim/nvim-lspconfig',
		after = 'nvim-lspconfig',
		config = M.configure,
	}
end

return M
