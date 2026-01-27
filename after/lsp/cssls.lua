---@type vim.lsp.Config
return {
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true, lint = { unknownAtRules = "ignore" }},
    scss = { validate = false },
    less = { validate = false }
  }
}
