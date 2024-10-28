return {
  "3rd/image.nvim",
  ft = { "markdown", "neorg", "typst", "html", "css" },
  cond = function()
    return vim.fn.has("win32") ~= 1
  end,
  dependencies = {
    { "leafo/magick", lazy = true, },
  },
  opts = {
    tmux_show_only_in_active_window = true,
  },
}
