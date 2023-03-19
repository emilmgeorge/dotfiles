local M = {}

function M.init()
	vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
	vim.cmd[[colorscheme catppuccin]]
end

function M.configure()
	local config = {
		dim_inactive = {
			enabled = true,
		},
		integrations = {
			which_key = true,
		}
	}
	require 'catppuccin'.setup(config)
	require 'themes'.init()
end

function M.setup()
	require 'packer'.use({
		'catppuccin/nvim',
		as = 'catppuccin',
		config = M.configure,
	})
end

return M
