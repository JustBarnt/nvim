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
		require("core.keymaps.lsp").LspKeys(ev)
		-- Setup all potential lsp methods supported by the lsp	
		vim.defer_fn(function()
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			local lsp_methods = vim.lsp.protocol.Methods

			if client then
				for _, method in pairs(lsp_methods) do
					local found, _ = pcall(require("core.lsp.autocmds")[method])
					---@diagnostic disable-next-line param-type-mismatch
					if client_supports_method(client, method, ev.buf) and found then
						vim.print("Client supports " .. method)
						require("core.lsp.autocmds")[method](ev)
					end
				end
			end
		end, 150)
	end
})

vim.lsp.enable("lua")
