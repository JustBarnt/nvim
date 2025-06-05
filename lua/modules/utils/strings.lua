local M = {}

---@param pattern string
---@return string, number
M.escape_pattern = function(pattern)
  local special_chars = "[]\\.*$^+()?{}|="
  return pattern:gsub("[" .. special_chars .. "]", "\\%1")
end

M.replace_word_under_cursor = function()
  local word = vim.fn.expand("<cword>")
  local prompt = "Replace: %s [%d]:"
  local cpos = vim.api.nvim_win_get_cursor(0)
  local ns_id = vim.api.nvim_create_namespace("replace_word_ns")

  local function update_virtual_text(bufnr, input_text)
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, col, {
      virt_text = { { "[" .. #input_text .. "]", "Comment" } },
      virt_text_pos = "eol",
    })
  end

  vim.ui.input({ prompt = string.format(prompt, word, #word) }, function(input)
    if input and #input > 0 then
      vim.cmd(string.format("%%s#%s#%s#g", word, input))
      vim.api.nvim_win_set_cursor(0, cpos)
    end
  end)

  local bufnr = vim.api.nvim_get_current_buf()

  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = bufnr,
    callback = function()
      local input_text = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
      update_virtual_text(bufnr, input_text)
    end,
  })
end

return M
