local M = {}

function M.configure()
	-- Default configuration
	-- See :h notify.setup()
	local default_config = {
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
	}

	local config = default_config
	require 'notify'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'rcarriga/nvim-notify',
		config = M.configure,
	}
end

return M
