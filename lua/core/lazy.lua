-- bootstrap lazy
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
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

local function lazy_file()
  -- Add support for the LazyFile event
  local Event = require "lazy.core.handler.event"

  Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

lazy_file()

_G.LazyVim = require "lazy.core.util"
_G.Helpers = require "helpers"
_G.Installables = require "modules.servers.init"

require("lazy").setup {
  -- dev = {
  --   path = "D:/Personal/nvim-plugins/",
  -- },
  spec = {
    { "nvim-lua/plenary.nvim", lazy = true },
    { "MunifTanjim/nui.nvim", lazy = true },
    "justinsgithub/wezterm-types",
    {
      "folke/snacks.nvim",
      version = "v2.22.0",
      priority = 10000,
      lazy = false,
      opts = {},
      config = function(_, opts)
        require("snacks").setup(opts)
      end,
    },
    -- { import = "plugins.activate" },
    { import = "plugins" },
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.lsp" },
    { import = "plugins.themes" },
    { import = "plugins.treesitter" },
    { import = "plugins.ui" },
  },
  -- NOTE: Part of lazy.nvim. Include a .lazy.lua file in a project root directory, and those plugins will be merged
  --       into the plugin spec for that project only
  local_spec = true,
  install = { colorscheme = { "tokyonight", "slate" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
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

vim.cmd("colorscheme tokyonight-moon")

Helpers.root.setup()

-- Config Core Files
require "core.keymaps"
require "core.autocmds"
require "core.user-commands"

-- Neovim native functionality
require("modules.lsp").setup()
require "modules.snippets"
require("modules.colorify").setup()

-- Extensions Modules to existing lua classes
require "modules.extensions.string"
