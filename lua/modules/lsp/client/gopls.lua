local Go = {}

---@param client vim.lsp.Client
---@param keys LazyKeysSpec[]
function Go.setup(client, keys)
  -- workaround for gopls not supporting semanticTokensProvider
  -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
  assert(client.name == "gopls", ("Unknown Client: **%s**"):format(client.name))
  if not client.server_capabilities.semanticTokensProvider then
    ---@class lsp.SemanticTokensClientCapabilities
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {
        tokenTypes = semantic.tokenTypes,
        tokenModifiers = semantic.tokenModifiers,
      },
      range = true,
    }
  end
end

return Go
