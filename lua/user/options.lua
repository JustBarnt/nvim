-- Load a nushell specific terminal setup if
-- nushell is installed on this system

vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd"}

if vim.g.nushell == 1 then
  require("user.nushell")
end

-- NOTE: vim.o vs vim.opt
--       vim.o only allows passing simple types like ints, booleans, or string.
--       vim.opt allows passing rich objects like tables

-- Clipboard and Mouse
vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"

-- Command Line and Messages
vim.o.cmdheight = 1
vim.o.inccommand = "split"

-- Completion
vim.o.completeopt = { "menuone", "popup", "noselect" }
vim.o.pumblend = 10
vim.o.pumheight = 10

-- Cursor and Visual Indicators
vim.o.colorcolumn = "120"
vim.o.cursorline = true
vim.o.guicursor = { "n-v-c:block", "i-ci-ve:hor20", "r-cr:hor20" }
vim.o.list = true
vim.o.listchars = { space = "⋅", trail = "⋅", tab = "  ↦" }
vim.o.number = true
vim.o.relativenumber = true

-- Diff
vim.o.diffopt = { "internal", "filler", "closeoff", "algorithm:patience", "indent-heuristic", "linematch:60" }

-- Folding
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- Formatting
vim.opt.fillchars:append({
  diff = "╱",
  eob = " ",
  fold = " ",
  foldclose = Utils.ui.icons.folds.close,
  foldopen = Utils.ui.icons.folds.open,
  foldsep = " ",
})
vim.o.formatoptions = "jcroqlnt"

-- Indentation
vim.o.cindent = false
vim.o.cinoptions = { "g2", "h2" }
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2

-- Navigation and Scrolling
vim.o.jumpoptions = "view"
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.smoothscroll = true

-- Search
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sessions
vim.o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Spelling
vim.o.spelllang = { "en" }

-- Splits and Windows
vim.o.helpheight = math.ceil((vim.o.lines - 1) * 0.25)
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.o.winminwidth = 5

-- Text Display
vim.o.conceallevel = 2
vim.o.linebreak = true
vim.o.wrap = false

-- Timing
vim.o.timeoutlen = 300
vim.o.updatetime = 300

-- UI and Appearance
vim.o.laststatus = 3
vim.o.ruler = false
vim.o.showmode = false
vim.o.termguicolors = true

-- Undo and History
vim.o.undofile = true
vim.o.undolevels = 10000

-- Miscellaneous
vim.o.autowrite = false
vim.o.maxmempattern = 10000
vim.o.virtualedit = "block"
vim.o.wildmode = { "longest:full", "full" }
vim.o.wildoptions = { "fuzzy", "pum", "tagfile" }

vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append('-')
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.breakindent = vim.o.wrap and true or false

-- NOTE: This will contain any "nightly" features I am trying out. As
--       neovim releases updates, nightly features will get moved out
if vim.fn.has "nvim-0.12" == 1 then
  vim.o.winborder = "rounded"
  vim.o.diffopt = "internal,filler,closeoff,algorithm:patience,indent-heuristic,inline:char,linematch:40"
  vim.opt.fillchars:append({ foldinner = " " })
end
