local packer = require('packer')
Default_config = {
	ring = {
		history_length = 10,
		storage = "shada",
		sync_with_numbered_registers = true,
		cancel_event = "update",
	},
	picker = {
		select = {
			action = nil, -- nil to use default put action
		},
		telescope = {
			mappings = nil, -- nil to use default mappings
		},
	},
	system_clipboard = {
		sync_with_ring = true,
	},
	highlight = {
		on_put = true,
		on_yank = true,
		timer = 500,
	},
	preserve_cursor_position = {
		enabled = true,
	},
}

packer.use({
	'gbprod/yanky.nvim',
	after = 'telescope.nvim',
	config = function()
		Default_config.ring.history_length = 100
		Default_config.highlight.timer = 100
		require("yanky").setup(Default_config)
		require("telescope").load_extension("yank_history")
	end,
})
