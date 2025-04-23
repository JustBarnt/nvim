return {
  "justbarnt/nordic.nvim",
  opts = {
    swap_backgrounds = true,
    cursorline = {
      bold = true,
    },
  },
  config = function(_, opts)
    require("nordic").setup(opts)
  end,
}
