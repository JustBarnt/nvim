local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Capability-based actions
local capability_actions = {
  completionProvider = function(client, buf)
    vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,

  definitionProvider = function(client, buf)
    vim.bo[buf].tagfunc = "v:lua.vim.lsp.tagfunc"
  end,

  colorProvider = function(client, buf)
    local ok = pcall(function() vim.lsp.document_color.enable(true, buf, { style = "virtual" }) end)
    if not ok then
      vim.notify(("Client `%s` does not support `document_color`"):format(client.name), vim.log.levels.INFO)
    end
  end,

  codeLensProvider = function(client, buf)
    local ok = pcall(vim.lsp.codelens.refresh)
    if not ok then
      vim.notify(("Client `%s` does not support `codelens`"):format(client.name), vim.log.levels.INFO)
    end
  end,
}

--- Creates Client Capabilities
---@return lsp.ClientCapabilities
local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
  }

  capabilities.textDocument.semanticTokens.multilineTokenSupport = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  return capabilities
end

---Sets up capability based actions
---@param client vim.lsp.Client
local function setup_server_capabilities(client, buf)
  for capability, action in pairs(capability_actions) do
    if client.server_capabilities[capability] then
      action(client, buf)
    end
  end
end

local function lsp_attach()
  local lsp_group = augroup("barnt/lsp_attach", { clear = true })
  autocmd("LspAttach", {
    group = lsp_group,
    callback = function(ev)
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

      -- Remove default keybinds
      for _, bind in ipairs { "grn", "gra", "gri", "grr", "grt", "K" } do
        pcall(vim.keymap.del, "n", bind, { buffer = ev.buf })
      end

      -- Setup our server capabilities
      setup_server_capabilities(client, ev.buf)
      Keymaps:make_buffer_only("lsp", ev.buf)
    end,
  })
end

---@class config.lsp
---@field debuggers string[]
---@field formatters string[]
---@field language_servers table<string, string>
---@field linters string[]
local M = {}

--stylua: ignore start

M.debuggers = {}

M.formatters = {
  "clang-format", "gofumpt", "goimports",
  "gomodifytags", "shfmt", "stylua",
  "xmlformatter",
}

M.language_servers = {
  ["clangd"] = "clangd",
  ["cmake-language-server"] = "cmake",
  ["css-lsp"] = "cssls",
  ["css-variables-language-server"] = "css_variables",
  ["cssmodules-language-server"] = "cssmodules_ls",
  ["emmet-ls"] = "emmet_ls",
  ["gopls"] = "gopls",
  ["html-lsp"] = "html",
  ["intelephense"] = "intelephense",
  ["json-lsp"] = "jsonls",
  ["just-lsp"] = "just",
  ["lemminx"] = "lemminx",
  ["lua-language-server"] = "lua_ls",
  ["nushell"] = "nushell",
  ["pyrefly"] = "pyrefly",
  ["roslyn"] = "roslyn_ls",
  ["ruff"] = "ruff",
  ["svelte-language-server"] = "svelte",
  ["tailwindcss-language-server"] = "tailwindcss",
  ["taplo"] = "taplo",
  ["vim-language-server"] = "vimls",
  ["vtsls"] = "vtsls",
  ["yaml-language-server"] = "yamlls",
}

M.linters = { "cmakelint", "shellcheck" }

-- stylua: ignore end

--- Setup language servers
M.setup = function()
  vim.lsp.config("*", {
    capabilities = create_capabilities(),
  })

  local lsps = vim.tbl_values(Config.lsp.language_servers)
  vim.lsp.enable(lsps)

  local completion_kinds = vim.lsp.protocol.CompletionItemKind
  local icons = Config.ui.icons.kinds
  for i, kind in ipairs(completion_kinds) do
    completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
  end

  vim.diagnostic.config(Config.diagnostics.config)
  lsp_attach()
end

--- Creates a flattened arrary of all Mason servers to download
function M:ensure_installed()
  local lsps = vim.tbl_keys(self.language_servers)
  return vim.iter({
    lsps,
    self.debuggers,
    self.formatters,
    self.linters 
  }):flatten(math.huge):totable()
end

return M
