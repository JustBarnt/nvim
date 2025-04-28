return {
  dir = "D:/Personal/nvim-plugins/nordic.nvim",
  -- "justbarnt/nordic.nvim",
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
