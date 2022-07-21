local packer = require('packer')
packer.use({
	'lewis6991/impatient.nvim',
	config = function()
		require('impatient')
	end,
})
