---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";")
      },
      workspace = {
        checkThirdParty = false,
        ignoreSubmodules = true,
      },
      codeLens = { enable = true },
      completion = { callSnippet = "Replace" },
      doc = { privateName = { "^_" } },
      hint = {
        enable     = true,
        setType    = false,
        paramType  = true,
        paramName  = "Disable",
        semicolon  = "Disable",
        arrayIndex = "Disable"
      }
    }
  }
}
