return {
  cmd = { "lemminx" },
  root_markers = { ".git" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  settings = {
    xml = {
      fileAssociations = {
        {
          pattern = "**/*.xsl",
          systemId = "https://raw.githubusercontent.com/JustBarnt/user-schemas/refs/heads/main/xml/xslt-1_0.xsd",
          rootElement = "xsl:stylesheet",
          namespace = "http://www.w3.org/1999/XSL/Transform",
        },
        {
          pattern = "**/*.xslt",
          systemId = "https://raw.githubusercontent.com/JustBarnt/user-schemas/refs/heads/main/xml/xslt-1_0.xsd",
          rootElement = "xsl:stylesheet",
          namespace = "http://www.w3.org/1999/XSL/Transform",
        },
        {
          pattern = "**/*.xsl",
          systemId = "https://raw.githubusercontent.com/JustBarnt/user-schemas/refs/heads/main/xml/xslt-1_0.xsd",
          rootElement = "xsl:transform",
          namespace = "http://www.w3.org/1999/XSL/Transform",
        },
        {
          pattern = "**/*.xslt",
          systemId = "https://raw.githubusercontent.com/JustBarnt/user-schemas/refs/heads/main/xml/xslt-1_0.xsd",
          rootElement = "xsl:transfom",
          namespace = "http://www.w3.org/1999/XSL/Transform",
        },
      },
      -- catalogs = {
      --     "D:/Personal/Github/user-schemas/xml/xslt-1_0-catalog.xml", -- XSLT 1.0 Schema
      -- },
      validation = { noGrammar = "hint" },
      completion = { autoCloseTags = true },
      caching = { useCache = true },
      format = { enabled = true },
      foldings = { includeClosingTagInFold = true },
    },
  },
  capabilities = Helpers.lsp.create_capabilities { textDocument = { formatting = { dynamicRegistration = false } } },
}
