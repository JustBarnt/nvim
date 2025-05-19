local Hover = {}

---@param client vim.lsp.Client
Hover.get_hover_info = function(client)
  local buf = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

  local hover_lines = {}
  vim.lsp.buf_request(buf, "textDocument/hover", params, function(err, results, context)
    if err then
      vim.notify(("Error: %s"):format(err.message))
      return
    end

    if results then
      if results.contents then
        hover_lines = vim.lsp.util.convert_input_to_markdown_lines(results.contents)
        -- Remove empty lines
        while hover_lines[#hover_lines] == "" do
          table.remove(hover_lines, #hover_lines)
        end
      end
    end

    local diag_lines = {}
    local diags = vim.diagnostic.get(buf, {
      lnum = params.position.line,
      severity = { min = vim.diagnostic.severity.WARN },
    })

    if #diags > 0 then
      for _, d in ipairs(diags) do
        local prefix = d.severity == vim.diagnostic.severity.ERROR and "**Error**:" or "**Warn**: "
        local msg = prefix .. d.message:gsub("\n", " ")
        table.insert(diag_lines, msg)
      end
    end

    if #hover_lines == 0 and #diag_lines == 0 then
      vim.notify("No hover or diagnostics found", vim.log.levels.INFO)
      return
    end

    local display = {}
    if #diag_lines > 0 then
      vim.list_extend(display, diag_lines)
    end

    if #hover_lines > 0 and #diag_lines > 0 then
      table.insert(display, "")
      table.insert(display, "---")
      table.insert(display, "")
    end

    if #hover_lines > 0 then
      vim.list_extend(display, hover_lines)
    end

    vim.lsp.util.open_floating_preview(display, "markdown", {
      border = "rounded",
      focusable = true,
      width = math.floor(vim.o.columns * 0.5),
      height = math.floor(vim.o.lines * 0.45),
    })
  end)
end

return Hover
