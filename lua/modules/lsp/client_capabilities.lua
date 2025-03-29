---@type table<vim.lsp.protocol.Method.ClientToServer, fun(buffer?: number, keys?: LazyKeysSpec[])>
local M = {}

M["textDocument/codeLens"] = function(buffer, keys)
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = buffer,
    callback = vim.lsp.codelens.refresh,
  })

  vim.list_extend(keys, {
    { "<leader>cc", vim.lsp.codelens.run, "Run Codelens" },
    { "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens" },
  })
end

M["textDocument/codeAction"] = function(_, keys)
  vim.list_extend(keys, {
    { "<leader>ca", "<CMD>lua require('fastaction').code_action()<CR>", desc = "Code Action (FastAction)" },
  })
end

M["textDocument/rename"] = function(_, keys)
  vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
      if event.data.actions.type == "move" then
        Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
      end
    end,
  })

  -- stylua: ignore
  vim.list_extend(keys, {
    {"<leader>rf", function() Snacks.rename.rename_file() end, "[R]e[n]ame" },
    { "<leader>rr", vim.lsp.buf.rename, "Rename Symbol" },
  })
end

M["textDocument/typeDefinition"] = function(_, keys)
  vim.list_extend(keys, { "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition" })
end

M["textDocument/formatting"] = function(buffer, keys)
  table.insert(keys, {
    "<leader>cf",
    function()
      LazyVim.try(function()
        return require("conform").format({ bufnr = buffer })
      end, { msg = "[conform.nvim] failed to format" })
    end,
    "Format",
    { "n", "v" },
  })
end

M["textDocument/inlayHint"] = function(buffer, keys)
  vim.lsp.inlay_hint.enable()
  vim.list_extend(keys, {
    "<leader>uh",
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
    end,
    "Toggle Inlay Hints",
  })
end

M["textDocument/documentHighlight"] = function(buffer, keys)
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

return M
