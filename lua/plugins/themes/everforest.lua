return {
  "neanias/everforest-nvim",
  priority = 1000,
  lazy = false,
  opts = {
    background = "medium",
    transparent_background_level = 2
  },
  config = function(_, opts)
    require("everforest").setup(opts)
  end
}
