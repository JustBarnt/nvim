local M = {}

M["textDocument/documentHighlight"] = function(_, buffer)
  local highlight_group = vim.api.nvim_create_augroup("user-lsp-highlights", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = buffer,
    group = highlight_group,
    callback = vim.lsp.buf.document_highlight,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = buffer,
    group = highlight_group,
    callback = vim.lsp.buf.clear_references,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
    callback = function(ev2)
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds({ group = "user-lsp-highlights", buffer = ev2.buf })
    end,
  })
end

M["textDocument/inlayHint"] = function(_, buffer)
  vim.lsp.inlay_hint.enable()
  vim.keymap.set("n", "<leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
  end, { desc = "Toggle Inlay Hints" })
end

return M
