-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    "--branch=stable",
    lazypath,
  })
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
  local Event = require("lazy.core.handler.event")

  Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

lazy_file()

_G.LazyVim = require("lazy.core.util")
_G.Helpers = require("helpers")
_G.Installables = require("plugins.servers")
_G.Lang = require("modules.lsp.lang")

require("lazy").setup({
  spec = {
    { "folke/tokyonight.nvim", priority = 10000 },
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
    { "MunifTanjim/nui.nvim", lazy = true },
    { "nvim-lua/plenary.nvim", lazy = true },
    { import = "plugins.ui" },
    { import = "plugins.lsp" },
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.treesitter" },
    { import = "plugins.colorschemes" },
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
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = Helpers.ui.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = Helpers.ui.icons.diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = Helpers.ui.icons.diagnostics.Info,
      [vim.diagnostic.severity.HINT] = Helpers.ui.icons.diagnostics.Hint,
    },
  },
  -- This is newly merged as of jan 2025, this displays diagnostic in a very similar way to nushell
  virtual_lines = {
    prefix = "●",
    current_line = true,
    spacing = 4,
    source = "if_many",
  },
  float = {
    source = true,
  },
})

-- Config Core Files
require("core.keymaps")
require("core.autocmds")
require("core.user-commands")

-- Neovim native functionality
require("modules.lsp").setup()
require("modules.snippets")

-- Extensions Modules to existing lua classes
require("modules.extensions.string")

vim.cmd([[colorscheme tokyonight-storm]])
