return {
  "rachartier/tiny-cmdline.nvim",
  event = "VeryLazy",
  config = function()
    vim.o.cmdheight = 0
    require("tiny-cmdline").setup {
      width = {
        fraction = 0.7,
        min = 40,
        max = 80,
      },
      position = {
        x = 0.5,
        y = 0,
      },
      on_reposition = require("tiny-cmdline").adapters.blink,
    }
  end,
}
