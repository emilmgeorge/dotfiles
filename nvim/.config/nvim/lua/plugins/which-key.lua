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
	require 'which-key'.add {
		{ "<leader>c", group = "code" },
		{ "<leader>g", group = "git" },
		{ "<leader>l", group = "lsp" },
		{ "<leader>m", group = "misc" },
	}
end

function M.setup()
	return {
		"folke/which-key.nvim",
		config = M.configure,
	}
end

return M
