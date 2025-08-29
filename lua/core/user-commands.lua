vim.api.nvim_create_user_command("TempFile", function()
  local fts = vim.fn.getcompletion("", "filetype")

  vim.ui.select(fts, {
    prompt = "Select Filetype:",
  }, function(choice)
      if choice then
        vim.cmd "enew"
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "hide"
        vim.bo.swapfile = false
        vim.bo.filetype = choice
        vim.api.nvim_buf_set_name(0, "temp." .. choice)
      end
    end)
end, {})

vim.api.nvim_create_user_command("ConvertEOL", function(opts)
  local fmt = opts.args
  if fmt ~= "unix" and fmt ~= "dos" and fmt ~= "mac" then
    vim.notify("Unsupported file format: " .. fmt, vim.log.levels.ERROR, {
      title = "ConvertEOL",
    })
  end
  vim.bo.fileformat = fmt
  vim.cmd [[write]]
  vim.notify("File converted to: " .. fmt, vim.log.levels.INFO, {
    title = "ConvertEOL",
  })
end, { nargs = 1 })

vim.api.nvim_create_user_command("IncMatches", function(opts)
  local pattern = opts.args
  -- (Optional conversion: if you want to use \S as in common regex, convert it to Lua’s %S)
  pattern = pattern:gsub("\\S", "%%S")

  local counter = 0
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    if line:find(pattern) then
      counter = counter + 1
      lines[i] = line:gsub(pattern, function(m)
        if counter == 1 then
          return m
        else
          return m .. tostring(counter)
        end
      end)
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end, {
  nargs = 1,
  desc = "Scan the buffer for words matching the given pattern and append an incrementing counter (per new line)",
})
