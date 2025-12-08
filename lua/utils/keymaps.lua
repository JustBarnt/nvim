---@class utils.keymaps
local M = {}

---@param keys UserKeymaps[]
function M.enable(keys)
  for _, key in ipairs(keys) do
    local mode, lhs, rhs, opts = unpack(key)
    opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

---@param keys UserKeymaps[]
---@param bufnr integer
function M.make_buffer_only(keys, bufnr)
  for _, key in ipairs(keys) do
    local mode, lhs, rhs, opts = unpack(key)
    local buffer_opts = vim.tbl_deep_extend("force", { silent = true, buffer = bufnr }, opts or {})
    vim.keymap.set(mode, lhs, rhs, buffer_opts)
  end
end

return M
