local M = {}

function M.configure()
	local cmp = require 'cmp'
	local config = {
			snippet = {
				expand = function(args)
					vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'ultisnips' }, -- For ultisnips users.
			}, {
				{ name = 'buffer' },
			})
	}
	cmp.setup(config)
end

function M.setup()
	require 'packer'.use {
		'hrsh7th/nvim-cmp',
		requires = 'hrsh7th/cmp-nvim-lsp-signature-help',
		config = M.configure,
	}
end

return M
