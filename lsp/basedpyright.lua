local utils = require("modules.lsp.utils")

---@type vim.lsp.Config
return {
  cmd = { "basedpyright" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.toml" },
  filetypes = { "python" },
  capabilities = utils.create_capabilities(),
  on_exit = utils.on_exit,
  on_error = utils.on_error,
  on_init = function(client)
    utils.on_init(client, Languages["py"].settings)
  end,
}
