---@class modules.lsp.lang.git
local M = {}

M["git"] = {
  filetypes = { "gitcommit", "gitconfig", "gitrebase", "gitignore", "gitattributes" },
  treesitters = { "git_config", "gitcommit", "git_rebase", "gitignore", "gitattributes" },
  formatters = {},
  formatter_options = {},
}

return M
