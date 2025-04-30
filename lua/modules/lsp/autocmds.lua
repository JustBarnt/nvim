local LspAutocmds = {}

local aus = {}

---@param client vim.lsp.Client
---@param buf integer|number
aus.document_highlight = function(client, buf)
  if client and client:supports_method("textDocument/documentHighlight", buf) then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = buf, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

---@param client vim.lsp.Client
---@param buf integer|number
aus.format_on_save = function(client, buf)
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      if vim.g.autoformat and not vim.tbl_contains(vim.g.autoformat_ignore, vim.bo[buf].filetype) then
        vim.print "FORMATTING"
        require("conform").format { bufnr = buf }
      end
    end,
  })
end

---@param client vim.lsp.Client
---@param buf integer|number
LspAutocmds.setup = function(client, buf)
  for name, hook in pairs(aus) do
    if type(hook) == "function" then
      hook(client, buf)
    end
  end
end

return LspAutocmds
