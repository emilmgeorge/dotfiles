local M = {}

function M.configure()
	local config = {
		operators = {
			gc = 'Line Comments',
			gb = 'Block comments',
		},
		window = {
			border = "single", -- none, single, double, shadow
			margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
			padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
		},
	}
	require 'which-key'.setup(config)
	require 'mappings'.map_wk(require 'which-key')
	require 'which-key'.register {
		['<leader>c'] = { name = '+code' },
		['<leader>ct'] = { name = '+treesitter' },
		['<leader>g'] = { name = '+git' },
		['<leader>l'] = { name = '+lsp' },
		['<leader>m'] = { name = '+misc' },
	}
end

function M.setup()
	require 'packer'.use({
		"folke/which-key.nvim",
		config = M.configure,
	})
end

return M
