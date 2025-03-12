local M = {}

M.LspKeys = function(event)
	local map = function(keys, func, desc, mode)
		mode = mode or 'n'
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("gd", function() Snacks.picker.lsp_definitions() end, "[G]oto [D]efinition")
	map("gr", function() Snacks.picker.lsp_references() end, "[G]oto [R]eferences")
	map("gI", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")
	map("<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type [D]efinition")
	map("<leader>ds", function() Snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols")
	map("<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols")
	map("<leader>rn", function() Snacks.rename.rename_file() end, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
	map("gD", function() Snacks.picker.lsp_declarations() end, "[G]oto [D]eclaration")
end

return M
