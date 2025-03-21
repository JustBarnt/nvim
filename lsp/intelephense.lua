local utils = require("modules.lsp.utils")

---@type vim.lsp.Config
return {
  cmd = { "intelephense", "--stdio" },
  root_markers = { ".git", "composer.json" },
  filetypes = { "php", "ctp" },
  capabilities = utils.create_capabilities(),
  on_exit = utils.on_exit,
  on_error = utils.on_error,
  on_init = function(client)
    utils.on_init(client, Languages["php"].settings)
  end,
}
