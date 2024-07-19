local M = {}

function M.configure()
	require("fidget").setup({})
end

function M.setup()
	return {
		"j-hui/fidget.nvim",
		config = M.configure,
	}
end

return M
