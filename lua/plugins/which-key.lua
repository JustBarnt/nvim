local function expand_buf()
  return require("which-key.extras").expand.buf()
end

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
        { "<leader>g",  group = "Git"                             },
        { "<leader>gh", group = "Git Hunks"                       },
        { "<leader>f",  group = "File/Find"                       },
        { "<leader>s",  group = "Search/Show"                     },
        { "<leader>m",  group = "Marks"                           },
        { "<leader>t",  group = "TimeMachine"                     },
        { "[",          group = "Pevious"                         },
        { "]",          group = "Next"                            },
        { "g",          group = "LSP/Global"                      },
        { "cs",         group = "Surround"                        },
        { "z",          group = "Folds"                           },
        { "<leader>b",  group = "Buffer", expand = expand_buf     },
        { "<leader>w",  group = "Windows", expand = expand_window },
      }
    }
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    Utils.keymaps.enable(keys)
  end
}
