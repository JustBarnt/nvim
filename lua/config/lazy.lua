-- Setup base46_cache before lazy initializes
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"


-- Bootstrap lazy if it doesn't exists
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." }
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Set our `mapleader` and `maplocalleader` keymaps before any plugin loads
-- to ensure mappings are correct

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load the rest of our options before any plugins load as well
require("config.options")

local lazy = require("lazy")
---@type LazyConfig
local opts = {
  dev = {
    path = "D:/nvim-plugins",
    patterns = { "justbarnt" },
    fallback = true
  },
  checker = { enabled = true },
  install = { missing = true, colorscheme = { "nvchad" } },
  spec = {
    { import = "core.ui" },
    { import = "plugins" }
  },
  change_detection = {
    enabled = true,
    notify = false
  },
  performance = {
    rtp = {
      paths = {
        vim.fn.glob(vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types/*.lua"),
      },
      disabled_plugins = {
        "gzip",
        "tohtml",
        "tutor",
        "netrwPlugin"
      }
    }
  }
}

lazy.setup(opts)

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

require("config.keymaps")
require("config.commands")
require("config.autocmds")
