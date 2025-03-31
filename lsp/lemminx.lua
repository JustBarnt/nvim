return {
  cmd = { "lemminx" },
  root_markers = { ".git" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  capabilities = Helpers.lsp.create_capabilities(),
}
