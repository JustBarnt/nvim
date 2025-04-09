---@type vim.lsp.Config
return {
  cmd = { "prisma-language-server", "--stdio" },
  root_markers = { ".git", "package.json" },
  filetypes = { "prisma" },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
    client.server_capabilities.hoverProvider = true
  end,
  capabilities = Helpers.lsp.create_capabilities({
    textDocument = {
      hover = {
        dynamicRegistration = false,
      },
      formatting = {
        dynamicRegistration = false,
      },
    },
  }),
}
