---@class helpers
---@field folds helpers.folds
---@field lualine helpers.lualine
---@field ui helpers.ui
---@field root helpers.root
---@field mini helpers.mini
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("helpers." .. k)
    return t[k]
  end,
})

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
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

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

--- returns a list of tables containing the servers from each language configuration
---@param path string
---@param key string
---@return string[][]
function M.get_ensured_installed(path, key)
  local lang_paths = vim.fn.globpath(path, "*.lua", false, true)
  local langs = {}
  local ret = {}
  for _, lang in ipairs(lang_paths) do
    table.insert(langs, vim.fn.fnamemodify(lang, ":t:r"))
  end

  for _, lang in ipairs(langs) do
    local success, obj = pcall(require, path .. "/" .. lang)
    if success then
      table.insert(ret, obj[key])
    end
  end
  return ret
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

--- builds a table from n tables given and removes any duplicates it finds and returns a merged table
---@param ... string[]
---@return string[]
function M.build_table(...)
  --- Flatten our n tables in to a single list
  ---@type string[]
  local list = vim.iter({ ... }):flatten(math.huge):totable()
  return M.dedup(list)
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == "string" and { mode } or mode

  local exists = {}
  for _, m in ipairs(modes) do
    if keys.have and keys:have(lhs, m) then
      table.insert(exists, m)
    end
  end

  if #exists > 0 then
    vim.notify(
      ("Keymap for %s already exists in mode(s): %s, skipping"):format(lhs, table.concat(exists, ",")),
      vim.log.levels.WARN
    )
  end

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- Do not create keymaps if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

return M
