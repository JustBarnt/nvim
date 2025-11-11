-- Load a nushell specific terminal setup if
-- nushell is installed on this system
if vim.g.nushell then
  require("user.nushell")
end

-- NOTE: vim.o vs vim.opt
--       vim.o only allows passing simple types like ints, booleans, or string.
--       vim.opt allows passing rich objects like tables

-- general options
vim.o.colorcolumn = "80"
vim.o.helpheight = math.ceil((vim.o.lines - 1) * 0.25)
vim.o.autowrite = false
vim.o.clipboard = "unnamedplus"
vim.o.guicursor = "n-v-c:block,i-ci-ve:hor20,r-cr:hor20"
vim.o.conceallevel = 2
vim.o.laststatus = 3 -- Global Statusline
vim.o.cursorline = true
vim.opt.list = true
vim.opt.listchars = { space = "⋅", trail = "⋅", tab = "  ↦" }
vim.o.mouse = "a"
vim.o.ruler = false
vim.o.scrolloff = 4
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }
vim.o.cmdheight = 1
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.timeoutlen = 1000
vim.o.virtualedit = "block"
vim.o.wildmode = "longest:full,full"
vim.o.linebreak = true
vim.o.wrap = false
vim.o.breakindent = vim.o.wrap and true or false
vim.opt.isfname:append "@-@"

if vim.fn.has "nvim-0.12" == 1 then
  vim.o.diffopt = "internal,filler,closeoff,algorithm:patience,indent-heuristic,inline:char,linematch:40"
elseif vim.fn.has "nvim-0.11" == 1 then
  vim.o.diffopt = "internal,filler,closeoff,algorithm:patience,indent-heuristic,linematch:40"
end

-- File History
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200

-- Tab stop
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smoothscroll = true

-- Session options
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Completion Window/Popup settings
vim.o.completeopt = "menuone,popup,fuzzy"
vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.winminwidth = 5
vim.o.maxmempattern = 10000

-- Fold settings
vim.o.foldcolumn = "1"
vim.o.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.foldexpr = "v:lua.require'helpers.folds'.foldexpr()"
vim.opt.foldmethod = "expr"
vim.wo.foldtext = ""
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  foldinner = " ",
  diff = "╱",
  msgsep = "─",
}

-- Format settings
vim.o.formatexpr = "v:lua.require'helpers.folds'.formatexpr()"
vim.o.formatoptions = "jcroqlnt"

-- Grep settings
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep --smart-case"

-- Search/subsitute settings
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.jumpoptions = "view"
vim.o.smartcase = true
vim.opt.whichwrap:append "<,>,[,]"

-- Spelling
vim.opt.spelllang = { "en" }

-- Splits
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true

-- Terminal
vim.o.termguicolors = true

-- Numbers
vim.o.number = true
vim.o.relativenumber = true
