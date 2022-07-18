local M = {}

function M.map()
	-- Set vim leader key
	vim.g.mapleader = " "

	vim.cmd([[
	""""""""""""""""""""""""""" EscapeString() """"""""""""""""""""""""""""
	" Escape special characters in a string for exact matching.
	" This is useful to copying strings from the file to the search tool
	" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
	function! EscapeString (string)
	let string=a:string
	" Escape regex characters
	let string = escape(string, '^$.*\/~[]')
	" Escape the line endings
	let string = substitute(string, '\n', '\\n', 'g')
	return string
	endfunction
	"""""""""""""""""""""""""""" GetVisual() """"""""""""""""""""""""""""""
	" Get the current visual block for search and replaces
	" This function passed the visual block through a string escape function
	" Based on this:
	" https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
	function! GetVisual() range
	" Save the current register and clipboard
	let reg_save = getreg('"')
	let regtype_save = getregtype('"')
	let cb_save = &clipboard
	set clipboard&
	" Put the current visual selection in the " register
	normal! ""gvy
	let selection = getreg('"')
	" Put the saved registers and clipboards back
	call setreg('"', reg_save, regtype_save)
	let &clipboard = cb_save
	"Escape any special characters in the selection
	let escaped_selection = EscapeString(selection)
	return escaped_selection
	endfunction
	]])
end

function M.map_wk(wk)
	wk.register({
	["<leader> "] = { "i<space><Esc>r", "Insert character in normal mode" },

	["<leader>1"] = { ":buffer 1<CR>", "Jump to buffer 1" },
	["<leader>2"] = { ":buffer 2<CR>", "Jump to buffer 2" },
	["<leader>3"] = { ":buffer 3<CR>", "Jump to buffer 3" },

	["<leader>c"] = { ":let @/=''<CR>", "Clear search" },
	["<leader>w"] = { ":set list!<CR>", "Toggle whitespace display" },
	})

	wk.register({
	["<leader>h"] = { "<Esc>:%s/<c-r>=GetVisual()<cr>//gc<Left><Left><Left>", "Replace selected text" },
	}, { mode = "v"})

	local clipboard_mappings = {
		["<leader>y"] = { "\"+y", "Yank to clipboard" },
		["<leader>p"] = { "\"+p", "Paste from clipboard" },
		["<leader>Y"] = { "\"*y", "Yank to primary" },
		["<leader>P"] = { "\"*p", "Paste from primary" },
	}
	wk.register(clipboard_mappings, { mode = "n"})
	wk.register(clipboard_mappings, { mode = "v"})
end

return M
