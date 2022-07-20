packer = require('packer')
packer.use({
	'feline-nvim/feline.nvim',
	requires = {
		{
			'kyazdani42/nvim-web-devicons',
			config = function()
				require('nvim-web-devicons').setup()
			end
		}
	},
	config = function()
		require('feline').setup({
			components = require('catppuccin.groups.integrations.feline'),
		})
	end,
	after = 'catppuccin',
})
