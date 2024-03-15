local M = {}

function M.configure()
	local config = {
		view = {
			adaptive_size = true,
		},
		update_focused_file = {
			enable = true,
			update_root = true,
		},
	}
	require("nvim-tree").setup(config)
	require("which-key").register({
		["<leader>d"] = { '<cmd>NvimTreeFindFileToggle<cr>', "Open file manager pane" },
	}, {mode = 'n', silent = true})
end

function M.setup()
	return {
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = M.configure,
		lazy = false,
	}
end

return M
