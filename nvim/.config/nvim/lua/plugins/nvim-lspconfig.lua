packer = require('packer')

packer.use({
	'hrsh7th/cmp-nvim-lsp'
})

packer.use({
	'williamboman/nvim-lsp-installer',
	requires = {
		'neovim/nvim-lspconfig',
	},
	after = 'nvim-lspconfig',
	config = function()
		require("nvim-lsp-installer").setup {
			ensure_installed = {},
			automatic_installation = false,
			ui = {
				icons = {
					server_installed = "✓",
					server_pending = "➜",
					server_uninstalled = "✗"
				}
			}
		}
	end
})

packer.use({
	'neovim/nvim-lspconfig',
	after = 'which-key.nvim',
	config = function()

		local wk = require('which-key')
		wk.register({
			-- ["<leader>ge"] = { vim.diagnostic.open_float, "Open float" },
		}, {remap = false, silent = true})

		-- -- Mappings.
		-- -- See `:help vim.diagnostic.*` for documentation on any of the below functions
		-- local opts = { noremap=true, silent=true }
		-- vim.keymap.set('n', '<leader>e', , opts)
		-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
		-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
		-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

		-- Use an on_attach function to only map the following keys
		-- after the language server attaches to the current buffer
		local on_attach = function(client, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

			-- Mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local wk = require('which-key')
			wk.register({
				["<leader>gd"] = { vim.lsp.buf.declaration, "Go to declaration" },
				["<leader>gh"] = { vim.lsp.buf.hover, "Show hover" },
				["<leader>gc"] = { vim.lsp.buf.rename, "Rename" },
				["<leader>ga"] = { vim.lsp.buf.code_action, "Code Action" },
				["<leader>gt"] = { vim.lsp.buf.type_definition, "Show type definition" },
			}, {remap = false, silent = true, buffer=bufnr})
		end

		-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

		require('lspconfig')['ccls'].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		require('lspconfig')['sumneko_lua'].setup({
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = 'LuaJIT',
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = {'vim'},
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},

				}
			},
			capabilities = capabilities,
		})

		require'lspconfig'.pyright.setup({
			capabilities = capabilities,
		})

	end
})
