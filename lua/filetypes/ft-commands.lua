-- TODO: Move this to a plugin

local command = vim.api.nvim_create_user_command

---@param opts FileTypeOpts
local function create_buffer(opts)
  vim.cmd("enew")
  vim.bo.buftype = opts.buftype
  vim.bo.bufhidden = opts.bufhidden
  vim.bo.swapfile = opts.swapfile
  vim.bo.filetype = opts.filetype

  -- Set buffer name for temp files
  if opts.temporary then
    vim.api.nvim_buf_set_name(0, "temp." .. opts.filetype)
  end
end

-- Create a temporary file by filetype
command("TempFile", function(opts)
  ---@type string
  local ft = opts.args

  if ft == "" then
    print("Please specify a filetype")
    return
  end

  create_buffer({
    temporary = true,
    filetype = ft,
    buftype = "nofile",
    bufhidden = "hide",
    swapfile = false,
  })
end, {
  nargs = 1,
  complete = "filetype",
})

-- Create a regular file by filetype
command("CreateFile", function(opts)
  ---@type string
  local ft = opts.args

  if ft == "" then
    print("Please specify a filetype")
    return
  end

  create_buffer({
    temporary = false,
    filetype = ft,
    buftype = "",
    bufhidden = "",
    swapfile = true,
  })
end, {
  nargs = 1,
  complete = "filetype",
})
