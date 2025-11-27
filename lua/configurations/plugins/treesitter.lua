local function isnt_installed(lang)
  return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
end

local ensure_installed = {
  "bash", "c", "c_sharp", "cmake",
  "cpp", "diff", "git_config", "gitcommit",
  "git_rebase", "gitignore", "gitattributes", "go",
  "gomod", "gosum", "gowork", "html",
  "ini", "javascript", "jsdoc", "json",
  "json5", "jsonc", "just", "lua",
  "luadoc", "luap", "lua_patterns", "markdown",
  "markdown_inline", "nu", "prisma", "php",
  "printf", "query", "regex", "scheme",
  "svelte", "toml", "tsx", "typescript",
  "vim", "vimdoc", "xml", "yaml",
} 


---@class config.plugins.treesitter
local M = {}

function M:install()
  local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
  if #to_install > 0 then require("nvim-treesitter").install(to_install) end
end

return M
