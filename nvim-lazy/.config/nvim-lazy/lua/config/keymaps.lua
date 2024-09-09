-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle whitespace display
LazyVim.toggle.map("<leader>u<Space>", LazyVim.toggle("list", { name = "Whitespace display" }))

-- Insert character
vim.keymap.set("n", "<Leader> ", "i<Space><Esc>r", { desc = "Insert character in normal mode", remap = false })

-- Visual
vim.keymap.set(
  { "n", "v" },
  "<Leader>vh",
  "<Esc>:%s/<C-r>=GetVisual()<CR>//gc<Left><Left><Left>",
  { desc = "Replace selected text" }
)
vim.keymap.set({ "n", "v" }, "<Leader>vp", "<Esc>`[v`]", { desc = "Select previously put/yanked text" })
vim.keymap.set(
  { "n", "v" },
  "<Leader>vq",
  "<Esc>:'<,'>normal @",
  { desc = "Run macro on every line in visual selection" }
)
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
