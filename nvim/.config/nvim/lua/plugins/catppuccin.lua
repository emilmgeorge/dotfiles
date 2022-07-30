local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		transparent_background = false,
		term_colors = false,
		compile = {
			enabled = false,
			path = vim.fn.stdpath "cache" .. "/catppuccin",
		},
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			coc_nvim = false,
			lsp_trouble = false,
			cmp = true,
			lsp_saga = false,
			gitgutter = false,
			gitsigns = true,
			telescope = true,
			nvimtree = {
				enabled = true,
				show_root = true,
				transparent_panel = false,
			},
			neotree = {
				enabled = false,
				show_root = true,
				transparent_panel = false,
			},
			dap = {
				enabled = false,
				enable_ui = false,
			},
			which_key = false,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = false,
			},
			dashboard = true,
			neogit = false,
			vim_sneak = false,
			fern = false,
			barbar = false,
			bufferline = true,
			markdown = true,
			lightspeed = false,
			ts_rainbow = false,
			hop = false,
			notify = true,
			telekasten = true,
			symbols_outline = true,
			mini = false,
		}
	}

	local config = default_config
	config.dim_inactive.enabled = true
	config.integrations.which_key = true
	require 'catppuccin'.setup(config)
	vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
	vim.cmd[[colorscheme catppuccin]]
	vim.cmd[[highlight LspReferenceText guibg=NONE cterm=underline gui=underline]]
	vim.cmd[[highlight LspReferenceRead guibg=NONE cterm=underline gui=underline]]
	vim.cmd[[highlight LspReferenceWrite guibg=NONE cterm=underline gui=underline]]
end

function M.setup()
	require 'packer'.use({
		'catppuccin/nvim',
		as = 'catppuccin',
		config = M.configure,
	})
end

return M
