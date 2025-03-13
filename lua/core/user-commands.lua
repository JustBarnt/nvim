vim.api.nvim_create_user_command("ConvertEOL", function(opts)
  local fmt = opts.args
  if fmt ~= "unix" and fmt ~= "dos" and fmt ~= "mac" then
    vim.notify("Unsupported file format: " .. fmt, vim.log.levels.ERROR, {
      title = "ConvertEOL",
    })
  end
  vim.bo.fileformat = fmt
  vim.cmd[[write]]
  vim.notify("File converted to: " .. fmt, vim.log.levels.INFO, {
    title = "ConvertEOL"
  })
end, { nargs = 1})
