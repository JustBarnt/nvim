local command = vim.api.nvim_create_user_command
local select = vim.ui.select

---@type FileTypeOpts
local CreateFileOpts = {
  temporary = false,
  filetype = "",
  buftype = "",
  bufhidden = "",
  swapfile = true
}

---@type FileTypeOpts
local TempFileOpts = {
  temporary = false,
  filetype = "",
  buftype = "",
  bufhidden = "",
  swapfile = true,
  ---@param self FileTypeOpts
  name = function(self)
    return "temp." .. self.filetype
  end
}

---@param filetype string filetype
---@param opts? FileTypeOpts buffer type
local function create_buffer(filetype, opts)
  opts = vim.tbl_deep_extend("force", CreateFileOpts, opts)
  vim.cmd("enew")
  vim.bo.buftype = opts.buftype
  vim.bo.bufhiden = opts.bufhidden
  vim.bo.swapfile = opts.swapfile
  vim.bo.filetype = filetype
end


-- Create a tempfile by filetype
command("CreateFile", function()
  local fts = vim.fn.getcompletion("", "filetype")
  select(fts, { prompt = "Select Filetype:" },
    function(choice)
      if choice then
        vim.cmd("enew")
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "hide"
        vim.bo.swapfile = false
        vim.bo.filetype = choice
        vim.api.nvim_buf_set_name(0, "temp." .. choice)
      end
  end)
end, {})
