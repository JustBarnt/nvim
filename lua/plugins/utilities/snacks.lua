return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  opts = Config.plugins.snacks,
  config = function(_, opts)
    require("snacks").setup(opts)
    Keymaps:activate("snacks")
  end,
}
