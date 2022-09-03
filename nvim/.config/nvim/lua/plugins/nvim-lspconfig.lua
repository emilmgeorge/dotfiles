local M = {}

function M.configure()
	local wk = require 'which-key'

	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		wk.register({
			["<leader>gd"] = { vim.lsp.buf.declaration, "Go to declaration" },
			["<leader>gh"] = { vim.lsp.buf.hover, "Show hover" },
			["<leader>gc"] = { vim.lsp.buf.rename, "Rename" },
			["<leader>gt"] = { vim.lsp.buf.type_definition, "Show type definition" },
		}, {remap = false, silent = true, buffer=bufnr})

		require 'illuminate'.on_attach(client)
		require 'nvim-navic'.attach(client, bufnr)
	end

	-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

	require 'lspconfig'.clangd.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	require 'lspconfig'.sumneko_lua.setup {
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
	}

	require 'lspconfig'.pyright.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	require 'lspconfig'.rust_analyzer.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	require 'lspconfig'.bashls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	require 'lspconfig'.cmake.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	require 'lspconfig'.cssls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = { "vscode-css-languageserver", "--stdio" },
	}

	require 'lspconfig'.html.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = { "vscode-html-languageserver", "--stdio" },
	}

	require 'lspconfig'.jsonls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = { "vscode-json-languageserver", "--stdio" },
	}

	require 'lspconfig'.tsserver.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	require 'lspconfig'.vimls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

function M.setup()
	require 'packer'.use {
		'neovim/nvim-lspconfig',
		after = {
			'which-key.nvim',
			'vim-illuminate',
			'nvim-navic',
		},
		requires = 'hrsh7th/cmp-nvim-lsp',
		config = M.configure,
	}
end

return M
