return {
  "rachartier/tiny-cmdline.nvim",
  event = "VeryLazy",
  config = function()
    vim.o.cmdheight = 0
    require("tiny-cmdline").setup {
      width = {
        value = "70%",
        min = 40,
        max = 80,
      },
      position = {
        x = "50%",
        y = "5%",
      },
      menu_col_offset = 3,
      native_types = { "/", "?" },
      on_reposition = require("tiny-cmdline").adapters.blink,
    }
  end,
}
