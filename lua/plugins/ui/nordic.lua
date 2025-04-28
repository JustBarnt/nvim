return {
  "justbarnt/nordic.nvim",
  enabled = false,
  opts = {
    on_highlight = function(hl, p)
      hl.Visual = { bg = p.gray1 }
    end,
    swap_backgrounds = true,
    cursorline = {
      bold = true,
    },
  },
}
