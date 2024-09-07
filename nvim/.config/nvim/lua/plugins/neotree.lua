local M = {}

function M.configure()
	require("neo-tree").setup({
		filesystem = {
			filtered_items = {
				visible = true,
			},
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			}
		}
	})
	vim.keymap.set('n', "<Leader>e", "<Cmd>Neotree toggle left<CR>", { desc = "Open file manager pane" })
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "neo-tree",
		callback = function()
			vim.api.nvim_create_augroup("WhitespaceIssueHighlight", { clear = true })
		end,
	})
end

function M.setup()
	return {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = M.configure,
	}
end

return M
