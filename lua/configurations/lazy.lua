---@class config.lazy
local M = {
  spec = {
    { import = "plugins" },
  },
  local_spec = true,
  install = { colorscheme = { "onedark", "habamax" } },
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
