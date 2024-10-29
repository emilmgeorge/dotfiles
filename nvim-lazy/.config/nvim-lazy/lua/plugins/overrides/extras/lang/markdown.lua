return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", },
    config = true,
    opts = {
      perspective = {
        priority = "current",
        fallback = "current",
      },
      links = {
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          return text
        end,
      },
      new_file_template = {
        use_template = true,
      },
      tables = {
        auto_extend_rows = true,
      },
      mappings = {
        MkdnNextHeading = false,
        MkdnPrevHeading = false,
        MkdnGoBack = false,
        MkdnGoForward = false,
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>Mp" }, -- see MkdnEnter
        MkdnDestroyLink = { "n", "<leader>Mx" },
        MkdnTagSpan = false,
        MkdnMoveSource = { "n", "<leader>Mm" },
        MkdnYankAnchorLink = { "n", "<leader>Mya" },
        MkdnYankFileAnchorLink = { "n", "<leader>Myf" },
        MkdnIncreaseHeading = { "n", "-" },
        MkdnDecreaseHeading = { "n", "+" },
        MkdnUpdateNumbering = false,
        MkdnTableFormat = {'n', '<leader>Mtf'},
        MkdnTablePrevRow = { "i", "<leader>Mk" },
        MkdnTableNewRowBelow = {'n', '<leader>Mir'},
        MkdnTableNewRowAbove = {'n', '<leader>MiR'},
        MkdnTableNewColAfter = {'n', '<leader>Mic'},
        MkdnTableNewColBefore = {'n', '<leader>MiC'},
        MkdnFoldSection = { "n", "<leader>Mf" },
        MkdnUnfoldSection = { "n", "<leader>MF" },
      },
    },
  },
}
