return {
  "nvim-telescope/telescope.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")
    require("telescope").setup({
      defaults = {
        path_display = {
          "filename_first",
        },
        cycle_layout_list = { "horizontal", "vertical", "center", "flex", "cursor", "bottom_pane" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = 0.95,
            height = 0.95,
            preview_width = 0.6,
          },
          vertical = {
            width = 0.9,
            height = 0.95,
            preview_height = 0.65,
          },
          center = {
            height = 0.5,
            preview_cutoff = 40,
            prompt_position = "bottom",
            width = 0.7,
            preview_height = 0.4,
          },
        },
        mappings = {
          i = {
            ["<Esc>"] = require("telescope.actions").close,
            ["<M-u>"] = require("telescope.actions.layout").cycle_layout_next,
            ["<M-d>"] = require("telescope.actions.layout").cycle_layout_prev,
            ["<M-b>"] = require("telescope.actions").results_scrolling_left,
            ["<M-f>"] = require("telescope.actions").results_scrolling_right,
            ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
            ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
            ["<C-b>"] = require("telescope.actions").preview_scrolling_left,
            ["<C-f>"] = require("telescope.actions").preview_scrolling_right,
            ["<C-s>"] = require("telescope.actions").file_split,
            ["<C-S>"] = require("telescope.actions").file_vsplit,
          },
        },
      },
    })
  end,
  optional = true,
}
