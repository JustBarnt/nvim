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
  "black",
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
  "basedpyright",
  "clangd",
  "cmake-language-server",
  "gopls",
  "harper-ls",
  "intelephense",
  "json-lsp",
  "lemminx",
  "lua-language-server",
  "prisma-language-server",
  "marksman",
  "roslyn",
  "ruff",
  "svelte-language-server",
  "tailwindcss-language-server",
  "taplo",
  "vtsls",
}

Installables.linters = {
  "cmakelint",
  "shellcheck",
}

return Installables
