local opt = vim.opt_local

-- Core
opt.binary = true
opt.eol = false
opt.fileformat = "unix"
opt.shadafile = "NONE"
opt.swapfile = false
opt.undofile = false
opt.backup = false
opt.writebackup = false
opt.hidden = false

-- UI
opt.lazyredraw = true
opt.syntax = "off"
opt.foldenable = false
opt.wrap = false
opt.number = false
opt.relativenumber = false
opt.cursorcolumn = false

local function setup()
  Snacks.notify.info { "Entered a **.log** file running optimizations" }

  -- Filetype-related
  vim.cmd "filetype off"
  vim.cmd "filetype indent off"

  -- Disable treesitter for log files
  vim.treesitter.stop()

  local ok, ts = pcall(require, "vim.treesitter")
  local buf = vim.api.nvim_get_current_buf()
  if ok and ts.highlighter and ts.highlighter.active then
    if ts.highlighter.active[buf] then
      ts.stop(buf)
    end
  end

  vim.schedule(function()
    Snacks.notify.info { "Log file optimization applied." }
  end)
end

setup()
