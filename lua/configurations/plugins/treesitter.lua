---@class config.plugins.treesitter
local M = {}

--stylua: ignore
M.parsers = {
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

return M
