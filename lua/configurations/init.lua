-- TODO: To make this file less overwhelming I want to separate out into modules inside the `configurations` directory

-- NOTE: Inspiration from LazyVim: https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/util/init.lua#L23

---@class config
---@field diagnostics config.diagnostics
---@field lazy        config.lazy
---@field lsps        config.lsp
---@field parsers     config.treesitter
---@field ui          config.ui
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "configurations." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("Configuration module 'configuration.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
  __newindex = function(t, k, v)
    --stylua: ignore
    vim.notify(
      string.format("Configuration is read-only. Cannton set '%s'" , k),
      vim.log.levels.ERROR
    )
  end,
})

---Helper to get nested keys using dot notation
---@param t table
---@param path string
---@return any
local function get_nested(t, path)
  local keys = {}
  for key in path:gmatch("[^.]+") do
    table.insert(keys, key)
  end

  local current = t
  for _, key in ipairs(keys) do
    if type(current) ~= "table" then
      return nil
    end
    current = current[key]
  end
  return current
end

---Get a configuration value by path
---@param path string
---@return any
M.get = function(path)
  return get_nested(M, path)
end

---Pretty print a configuration path
---@param path string
M.inspect = function(path)
  local value = get_nested(M, path)
  print(vim.inspect(value))
end

return M
