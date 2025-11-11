---@class config.lsp
local M = {}

--stylua: ignore
---@type string[]
M.debuggers = {}

--stylua: ignore
---@type string[]
M.formatters = {
  "clang-format", "gofumpt", "goimports",
  "gomodifytags", "shfmt", "stylua",
  "xmlformatter",
}

--stylua: ignore
---@type string[]
M.language_servers = {
  "clangd", "cmake-language-server", "css-lsp", "css-variables-language-server",
  "cssmodules-language-server", "emmet-ls", "gopls", "html-lsp",
  "intelephense", "json-lsp", "just-lsp", "lemminx",
  "lua-language-server", "pyrefly", "roslyn", "ruff",
  "svelte-language-server", "tailwindcss-language-server", "taplo", "vim-language-server",
  "vtsls", "yaml-language-server"
}

--stylua: ignore
---@type string[]
M.linters = { "cmakelint", "shellcheck" }

return M
