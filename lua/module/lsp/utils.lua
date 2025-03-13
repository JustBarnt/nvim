local M = {}

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

---@param client vim.lsp.Client
M.fetch_workspaces = function(client)
		local path = vim.tbl_get(client, "workspace_folders", 1, "name")
		if not path then
			return nil
		end
		return path
end

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

M.on_exit = function(code, signal)
	vim.notify(string.format(
		"LSP Client exited with code %d, signal %s",
		code,
		signal
	))
end

M.on_error = function(code, msg)
	vim.notify(string.format(
		"LSP Client error: %s (code: %s)",
		msg,
		code
	), vim.log.levels.ERROR)
end

---@param client vim.lsp.Client
---@param config lsp.LSPObject
M.on_init = function(client, config)
	if not M.fetch_workspaces(client) then
		return
	end

	client.settings = vim.tbl_deep_extend("force", client.settings, config)
end


return M
