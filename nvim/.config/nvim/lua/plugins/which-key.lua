local M = {}

function M.configure()
	local config = {
		preset = "helix",
		win = {
			border = "rounded",
			padding = { 1, 2, 1, 2 }, -- [top, right, bottom, left]
		},
		replace = {
			key = {
				{ "<Space>", "SPC" },
			},
		},
		show_help = false,
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
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	}
end

return M
