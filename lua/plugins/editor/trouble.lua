return {
  "folke/trouble.nvim",
  specs = {
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
                  mode = { "n", "" }
                }
              }
            }
          }
        }
      })
    end
  },
  opts = {
    modes = {
      lsp = {
        win = { position = "right" }
      }
    }
  },
}
