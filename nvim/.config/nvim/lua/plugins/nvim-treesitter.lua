local M = {}

function M.configure()
	local config = {
		-- A list of parser names, or "all"
		ensure_installed = {
			"c",
			"cpp",
			"lua",
			"python",
			"rust",
			"bash",
			"cmake",
			"css",
			"html",
			"javascript",
			"json",
			"markdown",
			"vim",
		},

		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- List of parsers to ignore installing (for "all")
		ignore_install = {},

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
			-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
			-- the name of the parser)
			-- list of language that will be disabled
			disable = {},

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
		textsubjects = {
			enable = true,
			prev_selection = ',', -- (Optional) keymap to select the previous selection
			keymaps = {
				['.'] = 'textsubjects-smart',
				[';'] = 'textsubjects-container-outer',
				['i;'] = 'textsubjects-container-inner',
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["ib"] = "@conditional.inner",
					["ab"] = "@conditional.outer",
					["ia"] = "@parameter.inner",
					["aa"] = "@parameter.outer",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
				},
				goto_next_end = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
				},
				goto_previous_start = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
				},
				goto_previous_end = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>mas"] = "@parameter.inner",
					["<leader>mfs"] = "@function.outer",
				},
				swap_previous = {
					["<leader>maS"] = "@parameter.inner",
					["<leader>mfS"] = "@function.outer",
				},
			},
			peek_definition_code = {
				["<leader>mfp"] = "@function.outer",
			},
		},
	}
	require 'nvim-treesitter.configs'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
		config = M.configure,
	}
	require 'packer'.use {
		'nvim-treesitter/nvim-treesitter-textobjects',
		after = 'nvim-treesitter',
	}
	require 'packer'.use {
		'RRethy/nvim-treesitter-textsubjects',
		after = 'nvim-treesitter',
	}
end

-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
---WORKAROUND

vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
	group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
	callback = function()
		vim.opt.foldmethod     = 'expr'
		vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
	end
})

---ENDWORKAROUND

return M
