return {
  "rebelot/kanagawa.nvim",
  priority = 10000,
  opts = {
    compile = false, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = { bold = true },
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = { bold = true, italic = true },
    transparent = false, -- do not set background color
    dimInactive = true, -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    theme = "wave", -- Load "wave" theme
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
  end
}
