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
  "intelephense",
  "json-lsp",
  "lemminx",
  "lua-language-server",
  "marksman",
  "roslyn",
  "svelte-language-server",
  "vtsls",
}

Installables.linters = {
  "cmakelint",
  "shellcheck",
}

Installables.treesitters = {
  "bash",
  "c",
  "c_sharp",
  "cmake",
  "cpp",
  "diff",
  "git_config",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "gitattributes",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "nu",
  "php",
  "printf",
  "query",
  "regex",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

return Installables
