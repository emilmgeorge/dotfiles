local M = {}

--
-- Not working.
--

function M.configure()
	require 'navigator'.setup({
		debug = true,
		lsp_installer = false,
		lsp = {
			enable = false,
			disable_lsp = 'all',
		}
	})
end

function M.setup()
	require 'packer'.use {
		'ray-x/navigator.lua',
		requires = {
			{ 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
			{ 'neovim/nvim-lspconfig' },
		},
		config = M.configure,
	}
end

return M
