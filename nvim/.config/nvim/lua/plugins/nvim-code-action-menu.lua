local M = {}

LSP_KEY_PREFIX = '<leader>l'
CODE_ACTION_KEY = LSP_KEY_PREFIX .. 'a'

function M.configure()
	vim.keymap.set('n', CODE_ACTION_KEY, ":CodeActionMenu<cr>", { desc = "Code Action", remap = false })
end

function M.setup()
	return {
		'weilbith/nvim-code-action-menu',
		config = M.configure,
	}
end

return M
