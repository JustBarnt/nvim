---@class Configuration
---@field servers string[]
---@field parsers string[]
---@field lazyCfg LazyConfiguration
local M = {}

---@class LazyConfiguration
---@reference refer to `lazy.nvim` configuration for details

-- Contains a list of LSP servers to always install
---@type string[]
local lsp_servers = {}

-- Contains a list of parsers to install for Treesitter
---@type string[]
local ts_parsers = {}

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
  }
}

local configs = {
  servers = lsp_servers,
  parsers = ts_parsers,
  lazyCfg = lazy_config,
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

local config_mt = {
  __index = function(table, key)
    if key == "get" then
      return function(path)
        if path:find "%." then
          return get_nested(configs, path)
        else
          return configs[path]
        end
      end
    end
    return configs[key]
  end,

  __newindex = function(table, key, value)
    error("Configurations are read-only. Cannot set '" .. tostring(key) .. "'")
  end,
}

-- Set metatable for
setmetatable(M, config_mt)
return M
