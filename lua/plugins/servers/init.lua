---@class Installables
---@field dap string[]
---@field formatters string[]
---@field linters string[]
---@field servers string[]
---@field treesitters string[]
local Installables = {}

Installables.dap = {
  "delve",
}

Installables.formatters = {
  "biome",
  "gofumpt",
  "goimports",
  "gomodifytags",
  "prettier",
  "shfmt",
  "stylua",
  "xmlformatter",
}

Installables.servers = {
  "bash-language-server",
  "clangd",
  "cmake-language-server",
  "css-lsp",
  "css-variables-language-server",
  "cssmodules-language-server",
  "emmet-ls",
  "gopls",
  "html-lsp",
  "intelephense",
  "json-lsp",
  "lemminx",
  "lua-language-server",
  "prisma-language-server",
  "pyrefly",
  "roslyn",
  "ruff",
  "svelte-language-server",
  "tailwindcss-language-server",
  "taplo",
  "vtsls",
  "yaml-language-server",
}

Installables.linters = {
  "cmakelint",
  "shellcheck",
}

return Installables
