local is_transparent = vim.fn.getenv "TERM" == "xterm-ghostty"

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 10000,
  opts = {
    transparent = is_transparent,
    styles = {
      sidebars = is_transparent and "transparent" or "dark",
      floats = is_transparent and "transparent" or "dark",
    },
  },
}
