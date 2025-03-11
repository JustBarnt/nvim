---@diagnostic disable-next-line: undefined-global
if init_debug then
  local osvpath = vim.fn.stdpath("data") .. "/lazy/one-small-step-for-vimkind"
  vim.opt.rtp:append(osvpath)
  require("osv").launch({ port = 8086, blocking = true })
end

require("config.options")
require("config.lsp")
require("config.statusline")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
