local M = {}

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
function M.create_capabilities()
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
function M.setup_server_capabilities(client, buf)
  for capability, action in pairs(capability_actions) do
    if client.server_capabilities[capability] then
      action(client, buf)
    end
  end
end

return M
