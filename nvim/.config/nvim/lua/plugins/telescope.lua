local packer = require('packer')
packer.use({
	'nvim-telescope/telescope.nvim',
	tag = '0.1.0',
	requires = {
		{ 'nvim-lua/plenary.nvim' },
	},
	after = 'which-key.nvim',
	config = function()
		require('which-key').register({
			["<leader>g"] = { name = "+go" },
			["<leader>gg"] = { "<cmd>Telescope lsp_definitions<cr>", "Go to definitions" },
			["<leader>gr"] = { "<cmd>Telescope lsp_references<cr>", "Go to references" },
		})
		require('telescope').setup()
	end
})
