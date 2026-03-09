return {
  { import = "lazyvim.plugins.extras.ai.avante" },
  {
    "yetone/avante.nvim",
    keys = {
      { "<leader>ae", ":AvanteEdit<CR>", desc = "Edit Avante", mode = { "n", "x", "v" } },
    },
    opts = {
      provider = "copilot",
      behaviour = {
        auto_approve_tool_permissions = false,
        confirmation_ui_style = "popup",
      },
      windows = {
        ask = {
          start_insert = false,
        },
      },
    }
  },
}
