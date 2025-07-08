local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function(config)
  config = vim.tbl_deep_extend("force", {}, config or {})
  config.border = "rounded"
  hover(config)
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function(config)
  config = vim.tbl_deep_extend("force", {}, config or {})
  config.border = "rounded"
  signature_help(config)
end

-- TODO: Turn this into a replacement for  codelens.run that when `resovled[i].command.command == ""`
--       it will use my custom version of `editor.action.showReferences`
local showReferences = vim.lsp.commands["editor.action.showReferences"]
vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
  local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
  local params = vim.lsp.util.make_position_params(vim.api.nvim_get_current_win(), client.offset_encoding)
  params.context = { includeDeclaration = false }

  vim.lsp.buf_request(0, 'textDocument/references', params, function(err, results, context)
    if err then
      return
    end
    if not results or vim.tbl_isempty(results) then
      return
    end

    local items = vim.lsp.util.locations_to_items(results, client.offset_encoding)

    vim.fn.setloclist(0, {}, "r", {
      title = "References",
      items = items,
      context = ctx,
    })
    vim.cmd("lopen")
  end)
end
