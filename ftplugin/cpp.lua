local set = vim.opt_local

set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.autoindent = true
set.smartindent = true
set.cindent = true
set.showmatch = true
set.colorcolumn = "80"

vim.cmd [[
  setlocal cinoptions=:0,p0,t0,+0,(0,u0,W4
]]
