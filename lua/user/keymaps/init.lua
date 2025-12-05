---@class Keymaps
---@field base   UserKeymaps[]
---@field lsp    UserKeymaps[]
---@field snacks UserKeymaps[]
local M = {}

---@alias keymap_sets "base"|"lsp"|"snacks"|"grugfar"

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "user.keymaps." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("User keymaps module 'user.keymaps.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end

    if type(mod) ~= "table" then
      vim.notify(
        string.format("User keymaps module 'user.keymaps.%s' did not return a table", k),
        vim.log.levels.ERROR
      )
    end

    t[k] = mod
    return t[k]
  end,
})

---@param set keymap_sets
function M:activate(set)
  local maps = self[set]

  if not maps then
    vim.notify(("Keymaps: `%s` was not found"):format(set), vim.log.levels.ERROR)
    return
  end

  for _, map in ipairs(maps) do
    local mode, lhs, rhs, opts = unpack(map)
    opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

---@param set keymap_sets
---@param bufnr integer
function M:make_buffer_only(set, bufnr)
  local maps = self[set]
  if not maps then
    vim.notify(("Keymaps: `%s` was not found"):format(set), vim.log.levels.ERROR)
    return
  end

  for _, map in ipairs(maps) do
    local mode, lhs, rhs, opts = unpack(map)
    local buffer_opts = vim.tbl_deep_extend("force", { silent = true, buffer = bufnr }, opts or {})
    vim.keymap.set(mode, lhs, rhs, buffer_opts)
  end
end

return M
