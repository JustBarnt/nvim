---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "selene.toml", "selene.yml", ".git" },
	filetypes = { "lua" },
	capabilities = require("core.lsp.utils").create_capabilities(),
	on_init = function(client)
		local fetch_workspaces = require("core.lsp.utils").fetch_workspaces

		if not fetch_workspaces(client) then
			return
		end

		client.settings = vim.tbl_deep_extend("force", client.settings, {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				codeLens = {
					enabled = true,
				},
				completion = {
					callSnippet = "Replace",
				},
				doc = {
					privateName = { "^_" },
				},
				hint = {
					enable = true,
					setType = false,
					paramType = true,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
				workspace = {
					checkThirdParty = false,
				},
			}
		})
	end
}
