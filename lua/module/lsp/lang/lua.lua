return {
  servers = { "lua-language-server" },
	treesitters = { "lua", "luadoc", "luap" },
	formatters = { "stylua" },
  formatters_by_ft = { "stylua" },
	settings = {
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
	}
}
