---@class Configuration
---@field debuggers Debuggers
---@field formatters Formatters
---@field lazyCfg LazyConfiguration
---@field linters Linters
---@field lsps Lsps
---@field parsers Parsers
local M = {}

---@class LazyConfiguration
---@reference refer to `lazy.nvim` configuration for details

---@alias Debuggers string[]
---@alias Formatters string[]
---@alias Linters string[]
---@alias Lsps string[]
---@alias Parsers string[]

---@type string[]
--stylua: ignore
local lsps = {
  "clangd", "cmake-language-server", "css-lsp", "css-variables-language-server",
  "cssmodules-language-server", "emmet-ls", "gopls", "html-lsp",
  "intelephense", "json-lsp", "just-lsp", "lemminx",
  "lua-language-server", "pyrefly", "roslyn", "ruff",
  "svelte-language-server", "tailwindcss-language-server", "taplo", "vim-language-server",
  "vtsls", "yaml-language-server",
}

--stylua: ignore
---@type Linters
local linters = { "cmakelint", "shellcheck" }

---@type Formatters
--stylua: ignore
local formatters = {
  "clang-format", "gofumpt", "goimports",
  "gomodifytags", "shfmt", "stylua",
  "xmlformatter",
}

---@type Debuggers
--stylua: ignore
local debuggers = {}

---@type Parsers

--stylua: ignore
local parsers = {
  "bash", "c", "c_sharp", "cmake",
  "cpp", "diff", "git_config", "gitcommit",
  "git_rebase", "gitignore", "gitattributes", "go",
  "gomod", "gosum", "gowork", "html",
  "ini", "javascript", "jsdoc", "json",
  "json5", "jsonc", "just", "lua",
  "luadoc", "luap", "lua_patterns", "markdown",
  "markdown_inline", "nu", "prisma", "php",
  "printf", "query", "regex", "scheme",
  "svelte", "toml", "tsx", "typescript",
  "vim", "vimdoc", "xml", "yaml",
}

-- Contains the `lazy.nvim` configuration
---@class LazyConfiguration
local lazy_config = {
  spec = {
    { "nvim-lua/plenary.nvim", lazy = true },
    { "MunifTanjim/nui.nvim", lazy = true },
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
  },
  local_spec = true,
  install = { colorscheme = { "onedark", "slate" } },
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

local configs = {
  debuggers = debuggers,
  formatters = formatters,
  lazyCfg = lazy_config,
  linters = linters,
  lsps = lsps,
  parsers = parsers,
}

---@param t table
---@param path string
---@return any
local function get_nested(t, path)
  local keys = {}
  for key in path:gmatch "[^.]+" do
    table.insert(keys, key)
  end

  local current = t
  for _, key in ipairs(keys) do
    if type(current) ~= "table" then
      return nil
    end

    local numeric_key = tonumber(key)
    if numeric_key then
      current = current[numeric_key]
    else
      current = current[key]
    end
  end
  return current
end

---@overload fun(path: "dap"): string[]
---@overload fun(path: "formatters"): string[]
---@overload fun(path: "lazyCfg"): LazyConfiguration
---@overload fun(path: "linters"): string[]
---@overload fun(path: "lsps"): string[]
---@overload fun(path: "parsers"): string[]
function M:get(path)
  if path:find "%." then
    return get_nested(configs, path)
  else
    return configs[path]
  end
end

return M
