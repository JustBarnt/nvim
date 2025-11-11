local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

---@class config.lsp
---@field debuggers string[]
---@field formatters string[]
---@field language_servers string[]
---@field linters string[]
local M = {}

--- Creates Client Capabilities
---@return lsp.ClientCapabilities
local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true
  }

  capabilities.textDocument.semanticTokens.multilineTokenSupport = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  return capabilities
end

local function lsp_attach()
  local lsp_group = augroup("barnt/lsp_attach", { clear = true })
  autocmd("LspAttach", {
    group = lsp_group,
  })
end

--stylua: ignore
M.debuggers = {}

--stylua: ignore
M.formatters = {
  "clang-format", "gofumpt", "goimports",
  "gomodifytags", "shfmt", "stylua",
  "xmlformatter",
}

--stylua: ignore
M.language_servers = {
  "clangd", "cmake-language-server", "css-lsp", "css-variables-language-server",
  "cssmodules-language-server", "emmet-ls", "gopls", "html-lsp",
  "intelephense", "json-lsp", "just-lsp", "lemminx",
  "lua-language-server", "pyrefly", "roslyn", "ruff",
  "svelte-language-server", "tailwindcss-language-server", "taplo", "vim-language-server",
  "vtsls", "yaml-language-server"
}

--stylua: ignore
M.linters = { "cmakelint", "shellcheck" }

---Sets up various LSP Capabilities
---@param capabilities any
M.setup = function(capabilities)
  vim.lsp.config("*", {
    capabilities = create_capabilities()
  })

  -- Remove default keybinds
  for _, bind in ipairs({"grn", "gra", "gri", "grr", "grt"}) do
      pcall(vim.keymap.del, "n", bind)
  end

  lsp_attach()
end

return M
