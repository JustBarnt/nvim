return {
  "folke/tokyonight.nvim",
  enabled = not vim.g.vsneo,
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = true
  }
}
