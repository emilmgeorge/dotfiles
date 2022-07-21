local packer = require('packer')
packer.use({
	'rcarriga/nvim-notify',
	config = function()
		require('notify').setup({
			background_colour = "Normal",
			fps = 30,
			icons = {
				DEBUG = "",
				ERROR = "",
				INFO = "",
				TRACE = "✎",
				WARN = ""
			},
			level = 2,
			minimum_width = 50,
			render = "default",
			stages = "fade_in_slide_out",
			timeout = 5000
		})
	end
})

