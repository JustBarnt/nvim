-- Register our global variables
_G.Utils = require("utils")

-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    "--branch=stable",
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- adds all of our plugins into vims runtimepath
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup {
  spec = {
    {
      import = "plugins",
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {},
      config = function(_, opts)
        local notify = vim.notify
        require("snacks").setup(opts)
        if Utils.has("noice.nvim") then
          vim.notify = notify
        end
      end
    }
  },
  rocks = { enabled = false },
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

_G.LazyUtil = require("lazy.core.util")

-- Delay notifications until noice.nvim is ready
Utils.lazy_notify()

-- Setup our RootDir awareness
-- from: https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/util/root.lua
Utils.root.setup()

-- Setup any DAP Adapters we have
Utils.dap.init()

-- Load our filetype additions
require("filetypes").setup()

-- Load the our user modules
require("user.autocmds")
require("user.diagnostics")
require("user.commands")
require("user.keys")
require("user.options")

-- TODO: Move to a plugin
require("filetypes.ft-commands")

-- require("vim._core.ui2").enable({})

-- TODO: Create a command for this
-- local file_path = vim.fn.stdpath("config") .. '\\lua\\types.lua'
-- local file = io.open(file_path, "a+")
-- local fts = vim.fn.getcompletion("", "filetype")
-- local types = table.concat(fts, '" | "')
-- if file then
--   file:write('\n')
--   file:write('---@alias Filetype "' .. types .. '"')
-- end
