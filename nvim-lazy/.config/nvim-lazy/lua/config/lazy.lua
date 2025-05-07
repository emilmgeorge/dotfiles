require("keycheck").init()
require("bootstrap")

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- lazyvim.plugins.* config overrides
    { import = "plugins.overrides" },

    -- lazyvim.plugins.extras.* imports
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.util.dot" },

    -- lazyvim.plugins.extras.* imports with config overrides
    { import = "plugins.overrides.extras.coding.yanky" },
    { import = "plugins.overrides.extras.editor.mini-files" },
    { import = "plugins.overrides.extras.editor.neo-tree" },
    { import = "plugins.overrides.extras.lang.markdown" },
    { import = "plugins.overrides.extras.lang.tex" },
    { import = "plugins.overrides.extras.ui.treesitter-context" },

    -- user plugins
    { import = "plugins" },
  },
  ui = {
    border = "single",
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
