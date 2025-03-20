local default_capabilities = {
  general = {
    positionEncodings = { "utf-16" },
  },
  textDocument = {
    callHierarchy = {
      dynamicRegistration = false,
    },
    codeAction = {
      codeActionLiteralSupport = {
        codeActionKind = {
          valueSet = {
            "",
            "quickfix",
            "refactor",
            "refactor.extract",
            "refactor.inline",
            "refactor.rewrite",
            "source",
            "source.organizeImports",
          },
        },
      },
      dataSupport = true,
      dynamicRegistration = true,
      isPreferredSupport = true,
      resolveSupport = {
        properties = { "edit" },
      },
    },
    codeLens = {
      dynamicRegistration = false,
      resolveSupport = {
        properties = { "command" },
      },
    },
    completion = {
      completionItem = {
        commitCharactersSupport = false,
        deprecatedSupport = true,
        documentationFormat = { "markdown", "plaintext" },
        preselectSupport = false,
        resolveSupport = {
          properties = { "additionalTextEdits" },
        },
        snippetSupport = true,
        tagSupport = {
          valueSet = { 1 },
        },
      },
      completionItemKind = {
        valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 },
      },
      completionList = {
        itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" },
      },
      contextSupport = false,
      dynamicRegistration = false,
    },
    declaration = {
      linkSupport = true,
    },
    definition = {
      dynamicRegistration = true,
      linkSupport = true,
    },
    diagnostic = {
      dynamicRegistration = true,
    },
    documentHighlight = {
      dynamicRegistration = false,
    },
    documentSymbol = {
      dynamicRegistration = false,
      hierarchicalDocumentSymbolSupport = true,
      symbolKind = {
        valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
      },
    },
    formatting = {
      dynamicRegistration = true,
    },
    hover = {
      contentFormat = { "markdown", "plaintext" },
      dynamicRegistration = true,
    },
    implementation = {
      linkSupport = true,
    },
    inlayHint = {
      dynamicRegistration = true,
      resolveSupport = {
        properties = { "textEdits", "tooltip", "location", "command" },
      },
    },
    publishDiagnostics = {
      dataSupport = true,
      relatedInformation = true,
      tagSupport = {
        valueSet = { 1, 2 },
      },
    },
    rangeFormatting = {
      dynamicRegistration = true,
      rangesSupport = true,
    },
    references = {
      dynamicRegistration = false,
    },
    rename = {
      dynamicRegistration = true,
      prepareSupport = true,
    },
    semanticTokens = {
      augmentsSyntaxTokens = true,
      dynamicRegistration = false,
      formats = { "relative" },
      multilineTokenSupport = false,
      overlappingTokenSupport = true,
      requests = {
        full = {
          delta = true,
        },
        range = false,
      },
      serverCancelSupport = false,
      tokenModifiers = {
        "declaration",
        "definition",
        "readonly",
        "static",
        "deprecated",
        "abstract",
        "async",
        "modification",
        "documentation",
        "defaultLibrary",
      },
      tokenTypes = {
        "namespace",
        "type",
        "class",
        "enum",
        "interface",
        "struct",
        "typeParameter",
        "parameter",
        "variable",
        "property",
        "enumMember",
        "event",
        "function",
        "method",
        "macro",
        "keyword",
        "modifier",
        "comment",
        "string",
        "number",
        "regexp",
        "operator",
        "decorator",
      },
    },
    signatureHelp = {
      dynamicRegistration = false,
      signatureInformation = {
        activeParameterSupport = true,
        documentationFormat = { "markdown", "plaintext" },
        parameterInformation = {
          labelOffsetSupport = true,
        },
      },
    },
    synchronization = {
      didSave = true,
      dynamicRegistration = false,
      willSave = true,
      willSaveWaitUntil = true,
    },
    typeDefinition = {
      linkSupport = true,
    },
  },
  window = {
    showDocument = {
      support = true,
    },
    showMessage = {
      messageActionItem = {
        additionalPropertiesSupport = false,
      },
    },
    workDoneProgress = true,
  },
  workspace = {
    applyEdit = true,
    configuration = true,
    didChangeConfiguration = {
      dynamicRegistration = false,
    },
    didChangeWatchedFiles = {
      dynamicRegistration = true,
      relativePatternSupport = true,
    },
    inlayHint = {
      refreshSupport = true,
    },
    semanticTokens = {
      refreshSupport = true,
    },
    symbol = {
      dynamicRegistration = false,
      symbolKind = {
        valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
      },
    },
    workspaceEdit = {
      resourceOperations = { "rename", "create", "delete" },
    },
    workspaceFolders = true,
  },
}

return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  opts = function(_, opts)
    local blink = require("blink.cmp")
    local config = {
      config = {
        capabilities = vim.tbl_deep_extend(
          "force",
          default_capabilities,
          vim.lsp.protocol.make_client_capabilities(),
          blink.get_lsp_capabilities(),
          opts.capabiltites or {}
        ),
      },
      filewatching = true,
    }
    return config
  end,
}
