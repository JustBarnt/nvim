---@class helpers
---@field folds helpers.folds
---@field lualine helpers.lualine
---@field lsp helpers.lsp
---@field ui helpers.ui
---@field root helpers.root
---@field mini helpers.mini
---@field mode helpers.mode
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("helpers." .. k)
    return t[k]
  end,
})

function M.is_win()
  return vim.uv.os_uname().version:match("Windows")
end

function M.insert_package_json(config_files, field, fname)
  local path = vim.fn.fnamemodify(fname, ":h")
  local root_with_package = vim.fs.dirname(vim.fs.find("package.json", { path = path, upward = true })[1])

  if root_with_package then
    local path_sep = M.is_win() and "\\" or "/"
    for line in io.lines(root_with_package .. path_sep .. "package.json") do
      if line:find(field) then
        config_files[#config_files + 1] = "package.json"
        break
      end
    end
  end
  return config_files
end

--- retuns true if neovim is in blocked state
function M.is_blocking()
  local mode = vim.api.nvim_get_mode()
  for _, m in ipairs({ "ic", "ix", "c", "no", "r%?", "rm" }) do
    if mode.mode:find(m) == 1 then
      return true
    end
  end
  return mode.blocking
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

--- Gets a path to a package in the mason registry
--- prefer this over `get_package`, since the package might not always be available
--- and triggers errors
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason")
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.uv.fs_stat(ret) and not require("lazy.core.config").headless() then
    LazyVim.warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path)
    )
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

---@param filetype string[]
function M.disable_item(filetype)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
  if vim.tbl_contains(filetype, ft) then
    return false
  end
  return true
end

local cache = {} ---@type table<(fun()), table<string, any>>

---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

return M
