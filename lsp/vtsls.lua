local utils = require("modules.lsp.utils")

---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  root_markers = { ".git", "package.json", "tsconfig.json", "jsconfig.json" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  capabilities = utils.create_capabilities(),
  on_exit = utils.on_exit,
  on_error = utils.on_error,
  on_init = function(client)
    utils.on_init(client, Languages["js"].settings)
  end,
}
