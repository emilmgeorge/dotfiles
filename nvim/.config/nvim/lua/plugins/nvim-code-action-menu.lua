local M = {}

LSP_KEY_PREFIX = '<leader>l'
CODE_ACTION_KEY = LSP_KEY_PREFIX .. 'a'

function M.configure()
	require 'which-key'.register({
		[CODE_ACTION_KEY] = { ":CodeActionMenu<cr>", "Code Action" },
	}, {remap = false, silent = true})
end

function M.setup()
	return {
		'weilbith/nvim-code-action-menu',
		config = M.configure,
	}
end

return M
