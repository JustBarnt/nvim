return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  opts = Config.plugins.snacks.opts,
  config = function(_, opts)
    require("snacks").setup(opts)
    Utils.keymaps.enable(Config.plugins.snacks.keys)
  end,
}
