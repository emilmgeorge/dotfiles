-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Highlight trailing whitespace and mixed whitespace indent
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("WhitespaceIssueHighlight", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#562626", fg = "white" })
    vim.api.nvim_set_hl(0, "MixedWhitespaceIndent", { bg = "#333333" })
  end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("WhitespaceIssueHighlight", { clear = false }),
  callback = function()
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "" then
      return
    end
    vim.fn.matchadd("TrailingWhitespace", "\\s\\+$")
    vim.fn.matchadd("MixedWhitespaceIndent", "\\%(^\\s* \\t\\s*\\)\\|\\%(^\\s*\\t \\s*\\)")
  end,
})
