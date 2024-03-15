local M = {}

function M.configure()
	require("neorg").setup({
		load = {
			["core.defaults"] = {},
			["core.concealer"] = {},
			["core.dirman"] = {
				config = {
					workspaces = {
						notes = "~/data/neorg",
					},
					default_workspace = "notes",
				},
			},
		},
	})
end

function M.setup()
	return {
		{
			"nvim-neorg/neorg",
			lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
			version = "*", -- Pin Neorg to the latest stable release
			dependencies = "nvim-treesitter",
			build = ":TSInstall norg",
			config = M.configure,
		}
	}
end

return M
