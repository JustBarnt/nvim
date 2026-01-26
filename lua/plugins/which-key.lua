local function expand_window()
  return require("which-key.extras").expand.win()
end

local function show_buffer_keymaps()
  require("which-key").show({global = false})
end

local function toggle_hydra()
  require("which-key").show({ keys = "<C-w>", loop = true})
end

local keys = {
  { { "n" }, "<leader>?", show_buffer_keymaps, { desc = "Buffer Keymaps"    } },
  { { "n" }, "<C-w><ppace>", toggle_hydra,     { desc = "Window Hydra Mode" } },
}

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    defaults = {},
    preset = "helix",
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>b",  group = "Buffer",                         },
        { "<leader>c",  group = "Code"                            },
        { "<leader>d",  group = "Delete",                         },
        { "<leader>f",  group = "File/Find"                       },
        { "<leader>g",  group = "Git"                             },
        { "<leader>gh", group = "Git Hunks"                       },
        { "<leader>m",  group = "Marks"                           },
        { "<leader>r",  group = "Rustaceanvim"                    },
        { "<leader>s",  group = "Search/Show"                     },
        { "<leader>t",  group = "TimeMachine"                     },
        { "<leader>w",  group = "Windows", expand = expand_window },
        { "[",          group = "Pevious"                         },
        { "]",          group = "Next"                            },
        { "cs",         group = "Surround"                        },
        { "g",          group = "LSP/Global"                      },
        { "z",          group = "Folds"                           },
      }
    }
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    Utils.keymaps.enable(keys)
  end
}
