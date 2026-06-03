---@class utils
---@field blink      utils.blink
---@field color      utils.color
---@field dap        utils.dap
---@field git        utils.git
---@field lsp        utils.lsp
---@field marks      utils.marks
---@field overseer   utils.overseer
---@field root       utils.root
---@field statusline utils.statusline
---@field treesitter utils.treesitter
---@field ui         utils.ui
---@field wezterm    utils.wezterm
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "utils." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("Utility module 'utils.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
})

function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp -- This stores our notifications in a temp table until we are ready

  local timer = vim.uv.new_timer()
  local check = assert(vim.uv.new_check())

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify() == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took longer than 500ms, something is wrong
  timer:start(500, 0, replay)
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
