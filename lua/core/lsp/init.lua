-- a wrapper around client:supports_method for LSP capabilities
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer Some LSP's support methods in specific files
---@return boolean
local function client_supports_method(client, method, bufnr)
	return client:supports_method(method, bufnr)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(ev)
		-- Attach generic LSP keymaps here
		local config = require("core.lsp.diagnostics").config
		require("core.keymaps.lsp").LspKeys(ev)

		-- Setup all potential lsp methods supported by the lsp	
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local lsp_methods = vim.lsp.protocol.Methods
		local methods = require("core.lsp.configured_methods")

		if client then
			for _, method in pairs(lsp_methods) do
				---@diagnostic disable-next-line param-type-mismatch
				if client_supports_method(client, method, ev.buf) and methods[method] then
					-- Sets up any configured LSP Protocol Methods
					methods[method](ev)
				end
			end
		end
		vim.diagnostic.config = config
	end
})

for _, file in ipairs(vim.fn.globpath("lsp", "*.lua", false, true)) do
	local basepath = vim.fn.fnamemodify(file, ":t:r")
	vim.lsp.enable(basepath)
end
