-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", lazyrepo, "--branch=stable", lazypath })
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

---@type table<string, LSPConfig>
_G.ConfiguredLangs = vim
  .iter(vim.fn.globpath("lua/modules/lsp/lang", "*.lua", false, true))
  :fold({}, function(acc, path)
    local lang = vim.fn.fnamemodify(path, ":t:r")
    local ok, obj = pcall(require, "modules/lsp/lang/" .. lang)
    if ok then
      acc[lang] = obj
    else
      vim.notify(("[Neovim] Failed to load config for [%s]"):format(lang), vim.log.levels.WARN)
    end
    return acc
  end)

_G.LazyVim = require("lazy.core.util")
_G.Helpers = require("helpers")

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

-- Config Core Files
require("core.keymaps")
require("core.autocmds")
require("core.user-commands")

-- Neovim native functionality
require("modules.lsp")
require("modules.snippets")

-- Extensions Modules to existing lua classes
require("modules.extensions.string")

vim.cmd([[colorscheme tokyonight-storm]])
