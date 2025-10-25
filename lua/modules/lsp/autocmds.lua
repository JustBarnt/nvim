local LspAutocmds = {}

---@type table<string, fun(client: vim.lsp.Client, buffer?: number)>
local aus = {}

-- aus.document_highlight = function(client, buffer)
--   if client:supports_method("textDocument/documentHighlight", buffer) then
--     vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
--     vim.api.nvim_clear_autocmds { buffer = buffer, group = "lsp_document_highlight" }
--     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--       group = "lsp_document_highlight",
--       buffer = buffer,
--       callback = vim.lsp.buf.document_highlight,
--     })
--     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--       group = "lsp_document_highlight",
--       buffer = buffer,
--       callback = vim.lsp.buf.clear_references,
--     })
--   end
-- end

---@param client vim.lsp.Client
---@param buffer integer|number
-- aus.format_on_save = function(client, buffer)
--   vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--       local disable_filetypes = { c = true, cpp = true, xml = true }
--       if vim.g.autoformat and not disable_filetypes[vim.bo[args.buf].filetype] then
--         require("conform").format { bufnr = args.buf, async = true }
--       end
--     end,
--   })
-- end

---@param client vim.lsp.Client
---@param buffer integer|number
LspAutocmds.setup = function(client, buffer)
  for name, hook in pairs(aus) do
    if type(hook) == "function" then
      hook(client, buffer)
    end
  end
end

return LspAutocmds
