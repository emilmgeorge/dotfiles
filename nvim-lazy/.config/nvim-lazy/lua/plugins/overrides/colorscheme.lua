local transparent = true
local colorscheme = "catppuccin"

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = colorscheme,
    },
  },
  {
    "catppuccin",
    lazy = true,
    opts = {
      transparent_background = transparent,
    },
  },
  {
    "shaunsingh/nord.nvim",
    name = "nord-shaunsingh",
    cond = colorscheme == "nord-shaunsingh",
    build = "ln -fs nord.lua colors/nord-shaunsingh.lua ",
    lazy = true,
    config = function(_, _)
      vim.g.nord_disable_background = transparent
      if transparent then
        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = "nord-shaunsingh",
          callback = function()
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
          end,
        })
      end
    end,
  },
  {
    "gbprod/nord.nvim",
    name = "nord-gbprod",
    cond = colorscheme == "nord-gbprod",
    build = "ln -fs nord.lua colors/nord-gbprod.lua ",
    lazy = true,
    opts = {
      transparent = transparent,
      on_highlights = function(highlights, colors)
        if transparent then
          highlights.TabLineFill.bg = colors.none
        end
        highlights.IncSearch.fg = colors.polar_night.bright
        highlights.IncSearch.bg = colors.aurora.yellow
      end,
    },
    config = function(_, opts)
      local utils = require("nord.utils")
      local make_global_bg = utils.make_global_bg
      ---@diagnostic disable-next-line: duplicate-set-field
      require("nord.utils").make_global_bg = function(_)
        return make_global_bg(opts.transparent)
      end
      require("nord").setup(opts)
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = function(_, opts)
      if transparent then
        opts = vim.tbl_deep_extend("force", opts or {}, {
          options = {
            transparent = true,
          },
          groups = {
            all = {
              NormalFloat = { bg = "none" },
              TabLineFill = { bg = "none" },
            },
          },
        })
      end
      return opts
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = function(_, opts)
      if not transparent then
        return opts
      end
      opts.transparent = true
      opts = vim.tbl_deep_extend("force", opts or {}, {
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
      })
      opts.overrides = function(_)
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          TabLineFill = { bg = "none" },
          TelescopeBorder = { bg = "none" },
        }
      end
      return opts
    end,
  },
  {
    "cpea2506/one_monokai.nvim",
    lazy = true,
    opts = {
      transparent = transparent,
      highlights = function(colors)
        if not transparent then
          return {}
        end
        local highlights = {
          TreesitterContext = { bg = colors.none },
        }
        return highlights
      end,
    },
  },
  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = true,
    opts = {
      dark_style_background = transparent and "transparent" or "default",
      styles = {
        floats = transparent and "transparent" or "default",
        sidebars = transparent and "transparent" or "default",
      },
      on_highlights = function(highlights, colors)
        if transparent then
          highlights.TabLineFill.bg = colors.none
          highlights.NormalFloat.bg = colors.none
          highlights.FloatBorder.bg = colors.none
          if highlights.NeoTreeNormal then
            highlights.NeoTreeNormal.bg = colors.none
          end
          if highlights.NeoTreeWinSeparator then
            highlights.NeoTreeWinSeparator.bg = colors.none
          end
          if highlights.TreesitterContext then
            highlights.TreesitterContext.bg = colors.none
          end
          if highlights.TelescopeNormal then
            highlights.TelescopeNormal.bg = colors.none
          end
        end
      end,
    },
  },
  {
    "UtkarshVerma/molokai.nvim",
    lazy = true,
    opts = {
      transparent = transparent,
      styles = {
        sidebars = transparent and "transparent" or "dark",
        floats = transparent and "transparent" or "dark",
      },
      on_highlights = function(highlights, colors)
        if transparent then
          if highlights.TreesitterContext then
            highlights.TreesitterContext.bg = colors.none
          end
        end
      end,
    },
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = function(_, opts)
      if not transparent then
        return opts
      end
      opts = vim.tbl_deep_extend("force", opts or {}, {
        transparent = true,
        lualine = {
          transparent = transparent,
        },
        highlights = {
          ["NormalFloat"] = { bg = "none" },
          ["FloatBorder"] = { bg = "none" },
          ["TabLineFill"] = { bg = "none" },
        },
      })
      return opts
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = transparent,
      styles = {
        sidebars = transparent and "transparent" or "dark",
        floats = transparent and "transparent" or "dark",
      },
      on_highlights = function(highlights, colors)
        if transparent then
          highlights.TabLineFill.bg = colors.none
          if highlights.TreesitterContext then
            highlights.TreesitterContext.bg = colors.none
          end
        end
      end,
    },
  },
}
