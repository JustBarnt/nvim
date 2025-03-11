local lua_cfg = require("lsp.lua_ls")
-- vim.lsp.start(lua_cfg)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspStart", { clear = true }),
	callback = function(ev)
		-- Attach generic LSP keymaps here
		require("config.keymaps.lsp").LspKeys(ev)
	end,
})
