return {
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          preset = "vertical",
          -- layout = {
          --   width = 0.9,
          --   -- height = 0.5, -- not working
          -- },
          fullscreen = true,
        },
        win = {
          input = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-b>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<c-f>"] = { "preview_scroll_right", mode = { "i", "n" } },
            },
          },
          preview = {
            layout = {
              height = 0.5,
              -- width = 0.95,
              -- min_width = 80,
            },
            wo = {
              wrap = false,
            },
          },
        },
      },
    },
  },
}
