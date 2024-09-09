-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable LazyVim auto-format on save
vim.g.autoformat = false

-- Disable auto-write on buffer switch
vim.opt.autowrite = false

-- Setting this reduces the chance of key sequences like <Esc>j being
-- interpreted as ANSI escape sequences like ^[j, rather than as two separate
-- key presses (<Esc> and j). ANSI escape sequences can still be triggered
-- manually using Alt+key (e.g., <Alt-j> for ^[j). Without this, pressing <Esc>
-- followed by a key may unintentionally trigger the corresponding Alt+key
-- binding.
-- Note 1: Setting [ttimeout = false] or [ttimeoutlen = -1] can cause input
--         issues when opening Neovim. See details here:
--         https://github.com/neovim/neovim/issues/29047
--         https://github.com/neovim/neovim/issues/33148
-- Note 2: <Alt-*> bindings may still be triggered in some cases, especially
--         during remote sessions.
vim.o.ttimeoutlen = 0
