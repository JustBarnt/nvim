local utils = require("module.lsp.utils")
local cfg = require("module.lsp.lang.lua")

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "selene.toml", "selene.yml", ".git" },
	filetypes = { "lua" },
	capabilities = utils.create_capabilities(),
	on_exit = utils.on_exit,
	on_error = utils.on_error,
	on_init = function(client)
		utils.on_init(client, cfg.settings)
	end
}
