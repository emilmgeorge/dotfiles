local M = {}

function M.configure()
	require 'nvim-navic'.setup {
		highlight = true,
	}
end

function M.setup()
	return {
		'SmiteshP/nvim-navic',
		dependencies = 'neovim/nvim-lspconfig',
		config = M.configure,
	}
end

return M
