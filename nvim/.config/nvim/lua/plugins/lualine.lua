local M = {}

function M.configure()
	local navic = require 'nvim-navic'
	local config = {
		options = {
			globalstatus = true,
		},
		sections = {
			lualine_x = {{ navic.get_location, cond = navic.is_available }, 'encoding', 'fileformat', 'filetype'},
		},
	}
	require 'lualine'.setup(config)
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
		after = {
			'nightfox.nvim',
			'nvim-navic'
		},
		config = M.configure,
	})
end

return M
