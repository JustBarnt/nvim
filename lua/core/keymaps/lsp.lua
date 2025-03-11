local M = {}

M.LspKeys = function(event)
	local map = function(keys, func, desc, mode)
		mode = mode or 'n'
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
	map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	map("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
	map("<leader>ws", get_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
end

function get_workspace_symbols()
	local word = vim.fn.expand('<cword>')
	return vim.lsp.buf.workspace_symbol(word)
end

return M
