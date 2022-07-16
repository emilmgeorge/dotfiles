packer = require('packer')
packer.use({
	'nvim-telescope/telescope.nvim',
	tag = '0.1.0',
	requires = {
		{ 'nvim-lua/plenary.nvim' },
	},
	after = 'which-key.nvim',
	config = function()
		require('which-key').register({
			["<leader>g"] = { name = "+lsp" },
			["<leader>gg"] = { "<cmd>Telescope lsp_definitions<cr>", "Go to definitions" },
			["<leader>gr"] = { "<cmd>Telescope lsp_references<cr>", "Find references" },
			["<leader>gd"] = { "<cmd>Telescope lsp_declarations<cr>", "Go to declarations" },
		})
		require('telescope').setup({
			defaults = {
				-- Default configuration for telescope goes here:
				-- config_key = value,
				mappings = {
					i = {
						-- map actions.which_key to <C-h> (default: <C-/>)
						-- actions.which_key shows the mappings for your picker,
						-- e.g. git_{create, delete, ...}_branch for the git_branches picker
						["<C-h>"] = "which_key"
					}
				}
			},
			pickers = {
				-- Default configuration for builtin pickers goes here:
				-- picker_name = {
				--   picker_config_key = value,
				--   ...
				-- }
				-- Now the picker_config_key will be applied every time you call this
				-- builtin picker
			},
			extensions = {
				-- Your extension configuration goes here:
				-- extension_name = {
				--   extension_config_key = value,
				-- }
				-- please take a look at the readme of the extension you want to configure
			}
		})
	end
})
