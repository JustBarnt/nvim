local opt = vim.opt_local

-- Core
-- opt.binary = true
-- opt.eol = false
-- opt.fileformat = "unix"
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
opt.eventignore = { "FileType", "UIEnter", "BufReadPre" }

-- Filetype-related
vim.cmd "filetype off"
vim.cmd "filetype indent off"

-- Disable treesitter for log files
vim.treesitter.stop()

vim.schedule(function()
  Snacks.notify.info { "Log file optimization applied." }
end)


