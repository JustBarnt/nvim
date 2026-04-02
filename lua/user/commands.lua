local command = vim.api.nvim_create_user_command

command("IncMatches", function(opts)
  local pattern = opts.args
  pattern = pattern:gsub("\\S", "%%S")

  local counter = 0
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    if line:find(pattern) then
      counter = counter + 1
      lines[i] = lines:gsub(pattern, function(m)
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
  desc = "Scan the buffer for words matching the given pattern and append an incrementing counter (per new line)"
})

--https://github.com/Rishabh672003/Neovim/blob/a4bd428f73198ab00267123e954ce970767cd4bf/lua/rj/autocommands.lua#L56C1-L60C20-
command("Grep", function(opts)
  local command = string.format('silent cgetexpr system("rg --vimgrep -S %s")', opts.args)
  vim.cmd(command)
  vim.cmd("copen")
end, { nargs = 1 })

local format_filetypes = { "xml" }

command("Format", function(opts)
  local ft = opts.args

  if ft == "xml" then
    vim.cmd([['<,'>!powershell -Command "$xml=[xml][Console]::In.ReadToEnd();$sw=New-Object System.IO.StringWriter;$xw=New-Object System.Xml.XmlTextWriter($sw);$xw.Formatting='Indented';$xw.Indentation=2;$xml.WriteTo($xw);$sw.ToString()"]])
  else
    vim.notify(("Format: filetype: %s not supported yet"):format(ft))
  end
end, {
    nargs = 1,
    range = true,
    desc = "Format visual selections by filetype",
    complete = function(arglead)
      return vim.tbl_filter(function(ft)
        return ft:find(arglead, 1, true) ~= nil
      end, format_filetypes)
    end,
  })
