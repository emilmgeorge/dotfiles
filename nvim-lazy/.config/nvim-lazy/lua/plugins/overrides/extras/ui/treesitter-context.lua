return {
  "nvim-treesitter/nvim-treesitter-context",
  opts = function(_, opts)
    opts.max_lines = 5
    opts.mode = "topline"

    -- Compact separator between context and content
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true })
  end,
}
