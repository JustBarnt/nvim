local icons = require("core.ui.icons").icons.diagnostics

local M = {}


---@class vim.diagnostic.Opts
M.diagnostics = {
	severity_sort = true,
	underline = true,
	update_in_insert = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Error,
			[vim.diagnostic.severity.WARN] = icons.Warn,
			[vim.diagnostic.severity.INFO] = icons.Info,
			[vim.diagnostic.severity.HINT] = icons.Hint
		}
	},
	virtual_text = {
		prefix = "●",
		source = "if_many",
		spacing = 4,
	}
}

---@type lsp.ClientCapabilities
M.capabilities = {
	workspace = {
		fileOperations = {
			didRename = true,
			willRename = true,
		},
	}
}

M.format = {
	formatting_options = nil,
	timeout_ms = nil
}

---@param capabilities? table<string, string> A list a client capabilities for an LSP
M.create_capabilities = function(capabilities)
	local has_blink, blink = pcall(require, "blink.cmp")
	return vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		has_blink and blink.get_lsp_capabilities() or {},
		capabilities or M.capabilities
	)
end

return M
