---@meta

_G.Helpers = require("helpers")

---@class LSPConfig
---@field servers string[]
---@field treesitters string[]
---@field formatters string[]
---@field formatters_by_ft string[]
---@field settings string[]

---@class vim.api.keyset.create_autocmd.callback.args
---@field id number
---@field event string
---@field group number?
---@field match string
---@field buf number
---@field file string
---@field data any

---@class vim.api.keyset.create_autocmd.opts
---@field callback? fun(ev: vim.api.keyset.create_autocmd.callback.args):boolean?

---@param event any (string|array) Event(s) that will trigger the handler
---@param opts vim.api.keyset.create_autocmd.opts
---@return integer
function vim.api.nvim_create_autocmd(event, opts) end
