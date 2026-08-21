return {
  {
    "olimorris/codecompanion.nvim",
    lazy = true,
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      "ravitemer/mcphub.nvim",
    },
    keys = {
      { "<leader>ac", desc = "+CodeCompanion" },
      { "<leader>acc", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanion: Toggle Chat" },
      { "<leader>aci", "<cmd>CodeCompanion<CR>", mode = { "n", "v" }, desc = "CodeCompanion: Inline Prompt" },
      { "<leader>aca", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanion: Actions" },
    },
    opts = {
      interactions = {
        cli = {
          agent = "copilot",
          agents = {
            copilot = {
              cmd = "copilot",
              args = {},
              description = "Github Copilot CLI",
              provider = "terminal",
            },
          },
        },
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-opus-5",
          },
        },
      },
      extensions = {
        history = {
          enabled = true,
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        default = { "codecompanion" },
        providers = {
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown", "codecompanion" },
    },
    ft = { "markdown", "codecompanion" },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    optional = true,
    opts = {
      -- recommended settings
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        -- required for Windows users
        use_absolute_path = true,
      },
      filetypes = {
        codecompanion = {
          template = "[Image]($FILE_PATH)",
        },
      },
    },
  },
}
