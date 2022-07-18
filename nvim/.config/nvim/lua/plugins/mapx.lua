packer = require('packer')
packer.use({
	'b0o/mapx.nvim',
	-- after = 'which-key.nvim',
	config = function()
		require('mapx').setup({
			global = true,
			whichkey = true,
		})
	end,
})
