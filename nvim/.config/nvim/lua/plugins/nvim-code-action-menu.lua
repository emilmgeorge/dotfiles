local M = {}

LSP_KEY_PREFIX = '<leader>l'

function M.configure()
	require 'which-key'.register({
		[LSP_KEY_PREFIX .. 'a'] = { ":CodeActionMenu<cr>", "Code Action" },
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'weilbith/nvim-code-action-menu',
		config = M.configure,
	}
end

return M
