return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = Config.plugins.whichkey.opts,
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    Utils.keymaps.enable(Config.plugins.whichkey.keys)
  end
}
