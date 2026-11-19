return {
  "chrisgrieser/nvim-origami",
  enabled = not vim.g.vsneo,
  event = "VeryLazy",
  opts = {
    foldKeymaps = { setup = false },
    autoFold = { enabled = false },
  },
  config = function(_, opts)
    require("origami").setup(opts)
  end,
}
