return {
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      injector = {
        ["python3"] = {
          before = true,
        },
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", "using namespace std;" },
          after = "int main() {}",
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      if opts and opts.dashboard and opts.dashboard.preset and opts.dashboard.preset.keys then
        local keys = opts.dashboard.preset.keys
        local leet_key = { icon = "{}", key = "L", desc = "Leetcode", action = ":Leet" }
        if keys[#keys].desc == "Quit" then
          table.insert(keys, #keys, leet_key)
        else
          table.insert(keys, leet_key)
        end
      end
    end,
  },
}
