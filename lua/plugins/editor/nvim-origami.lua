return {
  "chrisgrieser/nvim-origami",
  enabled = not vim.g.vsneo,
  event = "VeryLazy",
  opts = {
    foldKeymaps = { setup = false },
    autoFold = { enabled = false },
  },
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
  config = function(_, opts)
    require("origami").setup(opts)
  end,
}
