---@type vim.lsp.Config
return {
  bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
  capabilities = {
    textDocument = {
       semanticTokens = nil
    }
  }
}
