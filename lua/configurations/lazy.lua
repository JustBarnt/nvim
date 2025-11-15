---@class config.lazy
local M = {
  spec = {
    -- { "nvim-lua/plenary.nvim", lazy = true },
    -- { "MunifTanjim/nui.nvim", lazy = true },
    -- {
    --   "folke/snacks.nvim",
    --   version = "v2.22.0",
    --   priority = 10000,
    --   lazy = false,
    --   opts = {},
    --   config = function(_, opts)
    --     require("snacks").setup(opts)
    --   end,
    -- },
    { import = "plugins" },
  },
  local_spec = true,
  install = { colorscheme = { "vim" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    backdrop = 25,
  },
}

return M
