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
		{ "<Leader>c", group = "code" },
		{ "<Leader>g", group = "git" },
		{ "<Leader>l", group = "lsp" },
		{ "<Leader>m", group = "misc" },
	}
end

function M.setup()
	return {
		"folke/which-key.nvim",
		config = M.configure,
		event = "VeryLazy",
		keys = {
			{
				"<Leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	}
end

return M
