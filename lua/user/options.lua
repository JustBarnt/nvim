-- Load a nushell specific terminal setup if
-- nushell is installed on this system

vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd"}

if vim.g.nushell == 1 then
  require("user.nushell")
end

-- NOTE: vim.o vs vim.opt
--       vim.o only allows passing simple types like ints, booleans, or string.
--       vim.opt allows passing rich objects like tables

local opt = vim.opt

-- Clipboard and Mouse
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Command Line and Messages
opt.cmdheight = 1
opt.inccommand = "split"

-- Completion
opt.completeopt = { "menuone", "popup", "noselect" }
opt.pumblend = 10
opt.pumheight = 10

-- Cursor and Visual Indicators
opt.colorcolumn = "120"
opt.cursorline = true
opt.guicursor = { "n-v-c:block", "i-ci-ve:hor20", "r-cr:hor20" }
opt.list = true
opt.listchars = { space = "⋅", trail = "⋅", tab = "  ↦" }
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Diff
opt.diffopt = { "internal", "filler", "closeoff", "algorithm:patience", "indent-heuristic", "linematch:60" }

-- Folding
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "", 
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 9999
opt.foldmethod = "indent"
opt.foldtext = ""

-- Formatting
opt.formatoptions = "jcroqlnt"

-- Indentation
opt.cindent = false
opt.cinoptions = { "g2", "h2" }
opt.autoindent = true
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2

-- Navigation and Scrolling
opt.jumpoptions = "view"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.smoothscroll = true

-- Search
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep --smart-case"
opt.ignorecase = true
opt.smartcase = true

-- Sessions
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Spelling
opt.spelllang = { "en" }

-- Splits and Windows
opt.helpheight = math.ceil((vim.o.lines - 1) * 0.25)
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.winminwidth = 5

-- Text Display
opt.conceallevel = 2
opt.linebreak = true
opt.wrap = false

-- Timing
opt.timeoutlen = 300
opt.updatetime = 300

-- UI and Appearance
opt.laststatus = 3
opt.ruler = false
opt.showmode = false
opt.termguicolors = true

-- Undo and History
opt.undofile = true
opt.undolevels = 10000

-- Miscellaneous
opt.autowrite = false
opt.maxmempattern = 10000
opt.virtualedit = "block"
opt.wildmode = { "longest:full", "full" }
opt.wildoptions = { "fuzzy", "pum", "tagfile" }

opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.isfname:append("@-@")
opt.iskeyword:append('-')
opt.whichwrap:append("<,>,[,],h,l")
opt.breakindent = opt.wrap and true or false

-- NOTE: This will contain any "nightly" features I am trying out. As
--       neovim releases updates, nightly features will get moved out
if vim.fn.has "nvim-0.12" == 1 then
  opt.winborder = "rounded"
  opt.diffopt = "internal,filler,closeoff,algorithm:patience,indent-heuristic,inline:char,linematch:40"
end

vim.cmd("colorscheme kanagawa")
