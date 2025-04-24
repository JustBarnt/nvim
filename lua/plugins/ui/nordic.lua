return {
  "justbarnt/nordic.nvim",
  opts = {
    on_highlight = function(hl, p)
      hl.Visual = { bg = p.gray1 }
    end,
    swap_backgrounds = true,
    cursorline = {
      bold = true,
    },
  },
  config = function(_, opts)
    require("nordic").setup(opts)
  end,
}
