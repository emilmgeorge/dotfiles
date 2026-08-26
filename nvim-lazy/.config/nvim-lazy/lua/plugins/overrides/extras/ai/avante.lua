return {
  { import = "lazyvim.plugins.extras.ai.avante" },
  {
    "yetone/avante.nvim",
    keys = {
      { "<leader>aa", false },
      { "<leader>ac", false },
      { "<leader>ae", false },
      { "<leader>af", false },
      { "<leader>ah", false },
      { "<leader>am", false },
      { "<leader>an", false },
      { "<leader>ap", false },
      { "<leader>ar", false },
      { "<leader>as", false },
      { "<leader>at", false },
      { "<leader>aa", desc = "+Avante" },
      { "<leader>aae", "<cmd>AvanteEdit<CR>", desc = "Edit Avante", mode = { "n", "x", "v" } },
      { "<leader>aaa", "<cmd>AvanteAsk<CR>", desc = "Ask Avante" },
      { "<leader>aac", "<cmd>AvanteChat<CR>", desc = "Chat with Avante" },
      { "<leader>aae", "<cmd>AvanteEdit<CR>", desc = "Edit Avante" },
      { "<leader>aaf", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
      { "<leader>aah", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
      { "<leader>aam", "<cmd>AvanteModels<CR>", desc = "Select Avante Model" },
      { "<leader>aan", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat" },
      { "<leader>aap", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
      { "<leader>aar", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
      { "<leader>aas", "<cmd>AvanteStop<CR>", desc = "Stop Avante" },
      { "<leader>aat", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
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
