local M = {}

function M.configure()
	require("headlines").setup()
end

function M.setup()
	return {
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = M.configure,
	}
end

return M
