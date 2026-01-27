return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  specs = {
    {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<C-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" }
                  }
                }
              }
            }
          }
        })
      end
    },
  },
  keys = {
    { "<leader>xx", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>xX", "<CMD>Trouble diagnostics toggle<CR>",              desc = "Diagnostics (Trouble)" },
    { "<leader>xl", "<CMD>Trouble loclist toggle<CR>",                  desc = "Location List (Trouble)" },
    { "<leader>xq", "<CMD>Trouble qflist toggle<CR>",                   desc = "Quickfix List (Trouble)" },
  },
  opts = {
    modes = {
      lsp = {
        win = { position = "right" }
      }
    }
  },
}
