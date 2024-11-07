return {
  { import = "lazyvim.plugins.extras.lang.tex" },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["tex"] = { "texlab" },
        ["plaintex"] = { "texlab" },
      },
    },
  },
}
