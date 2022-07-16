packer = require('packer')
packer.use({
	'rcarriga/nvim-notify',
	config = function()
		require('notify').setup()
	end
})

