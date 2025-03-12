local M = {}

M["lua_ls"] = {
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

return M
