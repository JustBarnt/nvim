-- TODO: To make this file less overwhelming I want to separate out into modules inside the `configurations` directory

-- NOTE: Inspiration from LazyVim: https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/util/init.lua#L23

---@class config
---@field diagnostics config.diagnostics
---@field lazy        config.lazy
---@field lsp         config.lsp
---@field plugins     config.plugins
---@field ui          config.ui
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "configurations." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("Configuration module 'configurations.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
})

return M
