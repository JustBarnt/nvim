local utils = require("modules.lsp.utils")

---@type vim.lsp.Config
return {
  cmd = { "bash-language-server", "start" },
  root_markers = { ".bashrc", ".bash_profile", ".git" },
  single_file_support = true,
  filetypes = { "bash", "sh" },
  capabilities = utils.create_capabilities(),
  on_exit = utils.on_exit,
  on_error = utils.on_error,
  on_init = function(client)
    utils.on_init(client, AvailableLanguages["bash"].settings)
  end,
}
