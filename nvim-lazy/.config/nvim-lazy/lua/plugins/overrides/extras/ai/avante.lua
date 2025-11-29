return {
  { import = "lazyvim.plugins.extras.ai.avante" },
  {
    "yetone/avante.nvim",
    keys = {
      { "<leader>ae", ":AvanteEdit<CR>", desc = "Edit Avante", mode = { "n", "x", "v" } },
    },
    opts = {
      behaviour = {
        auto_approve_tool_permissions = false,
      },
    }
  },
}
