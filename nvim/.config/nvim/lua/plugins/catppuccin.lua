local M = {}

function M.init()
	vim.cmd[[colorscheme catppuccin]]
end

function M.configure()
	local config = {
		flavour = 'mocha', -- latte, frappe, macchiato, mocha
		dim_inactive = {
			enabled = true,
		},
		integrations = {
			illuminate = true,
			lsp_trouble = true,
			notify = true,
			semantic_tokens = true,
			which_key = true,
			navic = {
				enabled = true,
			},
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
