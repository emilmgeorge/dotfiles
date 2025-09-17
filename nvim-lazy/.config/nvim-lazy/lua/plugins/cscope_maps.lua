return {
  "dhananjaylatkar/cscope_maps.nvim",
  dependencies = {
    -- "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
    -- "ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
    -- "echasnovski/mini.pick", -- optional [for picker="mini-pick"]
    -- "folke/snacks.nvim", -- optional [for picker="snacks"]
  },
  opts = {
    prefix = "<C-\\>",
    skip_input_prompt = true,
    cscope = {
      picker = "snacks",
      skip_picker_for_single_result = true,
    },
  },
}
