local M = {}

LSP_KEY_PREFIX = '<leader>l'
CODE_ACTION_KEY = LSP_KEY_PREFIX .. 'a'

function M.configure()
	require 'which-key'.register({
		[CODE_ACTION_KEY] = { ":CodeActionMenu<cr>", "Code Action" },
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'weilbith/nvim-code-action-menu',
		config = M.configure,
		keys = CODE_ACTION_KEY,
	}
end

return M
