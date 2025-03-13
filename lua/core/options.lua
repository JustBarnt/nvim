-- leader key
-- you should use vim.keycode to translate keycodes instead of string values
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

--- TODO: various global options
--- similar to lazyvim so I can easily toggle things like autoformat

-- LSP auto formatting
vim.g.autoformat = true

-- Root dir
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- NOTE: vim.o vs. vim.opt
--       vim.o only allows passing simple types like integers, booleans, or strings to the option
--       while vim.opt allows passing rich objects instead

-- general options
vim.o.autowrite = true
vim.o.clipboard = "unnamedplus"
vim.o.guicursor = 'n-v-c:block,i-ci-ve:hor20,r-cr:hor20'
vim.o.conceallevel = 2
vim.o.cursorline = true
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.o.list = true
vim.o.mouse = "a"
vim.o.ruler = false
vim.o.scrolloff = 4
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true})
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.signcolumn = "yes"
vim.o.timeoutlen = 300
vim.o.virtualedit = "block"
vim.o.wildmode = "longest:full,full"
vim.o.winminwidth = 5
vim.o.wrap = false
vim.opt.isfname:append("@-@")
vim.opt.diffopt:append("linematch:60") -- second stage diff to align lines

-- File History
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200

-- Tab stop
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

-- Session options
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Completion Window
vim.o.completeopt = "menu,menuone,popup,fuzzy"
vim.o.pumblend = 10
vim.o.pumheight = 10

-- Line Numbers
vim.o.number = true
vim.o.relativenumber = true

-- Fold settings
vim.o.foldlevel = 99
vim.o.smoothscroll = true
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldmethod = 'expr'
vim.o.foldtext = ""

-- Format settings
vim.o.formatexpr = "v:lua.vim.lsp.formatexpr()"
vim.o.formatoptions = "jcroqlnt"

-- Grep settings
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep"

-- Search/subsitute settings
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.jumpoptions = "view"
vim.o.smartcase = true

-- Spelling
vim.opt.spelllang = { "en" }

-- Splits
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true

-- Terminal
vim.o.termguicolors = true
