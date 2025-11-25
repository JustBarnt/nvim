---@class config.plugins.lsp
---@field blink config.plugins.lsp.blink
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "configurations.plugins.lsp." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("Configuration module 'configuration.plugins.lsp.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
})

return M
