local M = {}

LSP_KEY_PREFIX = '<Leader>l'

function M.configure()
	local on_attach = function(client, bufnr)
		local opt = function(d) return { buffer = bufnr, remap = false, silent = true, desc = d } end
		vim.keymap.set('n', LSP_KEY_PREFIX .. 'T', vim.lsp.buf.type_definition, opt("Show type definition"))
		vim.keymap.set('n', LSP_KEY_PREFIX .. 'c', vim.lsp.buf.rename, opt("Rename"))
		vim.keymap.set('n', LSP_KEY_PREFIX .. 'd', vim.lsp.buf.declaration, opt("Go to declaration"))
		vim.keymap.set('n', LSP_KEY_PREFIX .. 'h', vim.lsp.buf.hover, opt("Show hover"))
		vim.keymap.set({'n', 'v'}, LSP_KEY_PREFIX .. 'f', vim.lsp.buf.format, opt("Format code"))

		require("illuminate").on_attach(client)
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

	require("mason").setup({})
	require("mason-lspconfig").setup({
		ensure_installed = {},
		handlers = {
			function(server)
				require("lspconfig")[server].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			lua_ls = function()
				require("lspconfig").lua_ls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					on_init = function(client)
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
							return
						end
						client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
							runtime = {
								version = 'LuaJIT'
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME
								}
							}
						})
					end,
					settings = {
						Lua = {}
					}
				})
			end,
		},
	})

	require("null-ls").setup({
		on_attach = function(_, bufnr)
			local opt = function(d) return { buffer = bufnr, remap = false, silent = true, desc = d } end
			vim.keymap.set('n', LSP_KEY_PREFIX .. 'f', vim.lsp.buf.format, opt("Format code"))
		end,
	})
	require("mason-null-ls").setup({
		handlers = {},
	})
end

function M.setup()
	return {
		'neovim/nvim-lspconfig',
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			{ "nvimtools/none-ls.nvim", "nvim-lua/plenary.nvim",},
			{
				"jay-babu/mason-null-ls.nvim",
				event = { "BufReadPre", "BufNewFile" },
			},
		},
		config = M.configure,
	}
end

return M
