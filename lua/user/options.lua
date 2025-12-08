-- Load a nushell specific terminal setup if
-- nushell is installed on this system
if vim.g.nushell then
  require("user.nushell")
end

-- NOTE: vim.o vs vim.opt
--       vim.o only allows passing simple types like ints, booleans, or string.
--       vim.opt allows passing rich objects like tables

local options = {
  -- Clipboard and Mouse
  clipboard = "unnamedplus",
  mouse = "a",

  -- Command Line and Messages
  cmdheight = 0,
  inccommand = "split",
  shortmess = "aoOtTIcC",

  -- Completion
  completeopt = { "menuone", "popup", "noselect" },
  pumblend = 10,
  pumheight = 10,

  -- Cursor and Visual Indicators
  colorcolumn = "120",
  cursorline = true,
  guicursor = { "n-v-c:block", "i-ci-ve:hor20", "r-cr:hor20" },
  list = true,
  listchars = { space = "⋅", trail = "⋅", tab = "  ↦" },
  number = true,
  relativenumber = true,

  -- Diff
  diffopt = { "internal", "filler", "closeoff", "algorithm:patience", "indent-heuristic", "linematch:60" },

  -- Folding
  foldcolumn = "1",
  foldlevel = 99,
  foldlevelstart = 99,

  -- Formatting
  fillchars = {
    diff = "╱",
    eob = " ",
    fold = " ",
    foldclose = Config.ui.icons.folds.close,
    foldopen = Config.ui.icons.folds.open,
    foldsep = " ",
  },

  -- formatexpr = "v:lua.require'helpers.folds'.formatexpr()",
  formatoptions = "jcroqlnt", -- Instructions to format text

  -- Indentation
  cindent = false,
  cinoptions = { "g2", "h2" },
  autoindent = true,
  expandtab = true,
  shiftround = true,
  shiftwidth = 2,
  smartindent = true,
  tabstop = 2,

  -- Navigation and Scrolling
  jumpoptions = "view",
  scrolloff = 4,
  sidescrolloff = 8,
  smoothscroll = true,

  -- Search
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep --smart-case",
  ignorecase = true,
  smartcase = true,

  -- Sessions
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },

  -- Spelling
  spelllang = { "en" },

  -- Splits and Windows
  helpheight = math.ceil((vim.o.lines - 1) * 0.25),
  splitbelow = true,
  splitkeep = "screen",
  splitright = true,
  winminwidth = 5,

  -- Text Display
  conceallevel = 2,
  linebreak = true,
  wrap = false,

  -- Timing
  timeoutlen = 1000,
  updatetime = 200,

  -- UI and Appearance
  laststatus = 3,
  ruler = false,
  showmode = false,
  termguicolors = true,

  -- Undo and History
  undofile = true,
  undolevels = 10000,

  -- Miscellaneous
  autowrite = false,
  maxmempattern = 10000,
  virtualedit = "block",
  wildmode = { "longest:full", "full" },
  wildoptions = { "fuzzy", "pum", "tagfile" },
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append('-')
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.breakindent = vim.o.wrap and true or false

-- NOTE: This will contain any "nightly" features I am trying out. As
--       neovim releases updates, nightly features will get moved out
if vim.fn.has "nvim-0.12" == 1 then
  vim.o.diffopt = "internal,filler,closeoff,algorithm:patience,indent-heuristic,inline:char,linematch:40"
  table.insert(vim.opt.fillchars, { foldinner = " " })
end
