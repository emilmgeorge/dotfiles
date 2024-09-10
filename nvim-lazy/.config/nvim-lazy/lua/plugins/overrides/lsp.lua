-- Rust tools installed via rustup.
-- ra-multiplex installed via distro/external packager managers.
vim.api.nvim_create_autocmd("FileType", {
  desc = "Start ra-multiplex server",
  once = true,
  pattern = "rust",
  command = "silent !systemctl --user start ra-multiplex.service",
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        rust_analyzer = {
          cmd = {
            "/usr/bin/ra-multiplex",
          },
        },
      },
    },
  },
}
