local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
		options = {
			icons_enabled = true,
			theme = 'auto',
			component_separators = { left = '', right = ''},
			section_separators = { left = '', right = ''},
			disabled_filetypes = {},
			always_divide_middle = true,
			globalstatus = false,
		},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'branch', 'diff', 'diagnostics'},
			lualine_c = {'filename'},
			lualine_x = {'encoding', 'fileformat', 'filetype'},
			lualine_y = {'progress'},
			lualine_z = {'location'}
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {'filename'},
			lualine_x = {'location'},
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		extensions = {}
	}

	local config = default_config
	config.options.theme = 'catppuccin'
	config.options.globalstatus = true
	require('lualine').setup(config)
end

function M.setup()
	require 'packer'.use({
		'nvim-lualine/lualine.nvim',
		requires = {
			{
				'kyazdani42/nvim-web-devicons',
				config = function()
					require('nvim-web-devicons').setup()
				end
			}
		},
		after = 'catppuccin',
		config = M.configure,
	})
end

return M
