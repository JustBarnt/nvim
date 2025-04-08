return {
  cmd = { "lemminx" },
  root_markers = { ".git" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  settings = {
    xml = {
      completion = {
        autoCloseTags = true,
      },
      format = {
        enabled = true,
      },
      foldings = {
        includeClosingTagInFold = true,
      },
    },
  },
  capabilities = Helpers.lsp.create_capabilities({ textDocument = { formatting = { dynamicRegistration = false } } }),
}
