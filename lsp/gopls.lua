local utils = require("module.lsp.utils")
local cfg = require("module.lsp.lang.go")

---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  root_markers = { "go.work", "go.mod", ".git" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
	capabilities = utils.create_capabilities(),
	on_exit = utils.on_exit,
	on_error = utils.on_error,
	on_init = function(client)
		utils.on_init(client, cfg.settings)
	end
}
