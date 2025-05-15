-- leader key
-- you should use vim.keycode to translate keycodes instead of string values
vim.g.mapleader = vim.keycode "<space>"
vim.g.maplocalleader = vim.keycode "/"

vim.opt.sh = "nu"

-- WARN: disable usage of temp files for shell commands
-- Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
-- When set to `false` the stdin pipe will be used instead
-- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
--       according to: https://github.com/neovim/neovim/issues/33012 `shelltemp` is now set to be false by default on nightly
vim.opt.shelltemp = false

-- string to be used to put the output of shell commands in a temp file
-- 1. when 'shelltemp' is `true`
-- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set
--    to use an external diff command: `set diffopt-=internal`
vim.opt.shellredir = "out+err> %s"

-- flags for nu:
-- * `--stdin`       redirect all input to -c
-- * `--no-newline`  do not append '\n' to stdout
-- * `--commands -c` execute a command
vim.opt.shellcmdflag = "--stdin --no-newline -c"

-- disable all escaping and quoting
vim.opt.shellxescape = ""
vim.opt.shellxquote = ""
vim.opt.shellquote = ""

-- string to be used with `:make` command to:
-- 1. save teh stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
-- 2. show the stdout, stderr and the return_code on the screen
-- NOTE: `ansi strip` removes all ansi coloring from nushell errors
vim.opt.shellpipe = '| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record'

-- NOTE: Add custom nu config and env to `vim.opt.sh`

-- if jit.os == "Windows" then
--   local command = ("nu --env-config %s\\nushell\\env.nu --config %s\\nushell\\config.nu"):format(vim.env.XDG_CONFIG_HOME, vim.env.XDG_CONFIG_HOME)
--   vim.opt.sh = command
-- else
--   vim.opt.sh = "nu --env-config ~/.config/nushell/env.nu --config ~/.config/nushell/config.nu"
-- end


--- TODO: various global options
--- similar to lazyvim so I can easily toggle things like autoformat
vim.g.show_lnum_and_relnum = false

-- LSP auto formatting
vim.g.autoformat_ignore = { "xml" }
vim.g.autoformat = false

-- Root dir
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- NOTE: vim.o vs. vim.opt
--       vim.o only allows passing simple types like integers, booleans, or strings to the option
--       while vim.opt allows passing rich objects instead

-- general options
vim.o.helpheight = math.ceil((vim.o.lines - 1) * 0.25)
vim.o.autowrite = true
vim.o.clipboard = "unnamedplus"
vim.o.guicursor = "n-v-c:block,i-ci-ve:hor20,r-cr:hor20"
vim.o.conceallevel = 2
vim.o.laststatus = 3 -- Global Statusline
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
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }
vim.o.cmdheight = 0
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.timeoutlen = 300
vim.o.virtualedit = "block"
vim.o.wildmode = "longest:full,full"
vim.o.wrap = false
vim.o.breakindent = vim.o.wrap and true or false
vim.opt.isfname:append "@-@"
vim.opt.diffopt:append "linematch:60" -- second stage diff to align lines

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

-- Session options
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Completion Window/Popup settings
vim.o.completeopt = "menuone,popup,fuzzy"
vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.winminwidth = 5
vim.o.maxmempattern = 10000

--- NOTE: New in neovim nightly as of 2025-03-18, but most current plugins have issues if this is set
-- vim.o.winborder = "rounded"

-- Fold settings
vim.opt.foldlevel = 99
vim.opt.smoothscroll = true
vim.opt.foldexpr = "v:lua.require'helpers.folds'.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldtext = ""

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

-- Spelling
vim.opt.spelllang = { "en" }

-- Splits
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true

-- Terminal
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true
