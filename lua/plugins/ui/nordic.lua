return {
  "nordic.nvim",
  opts = {},
  config = function(_, opts)
    require("nordic").setup(opts)
  end,
}
