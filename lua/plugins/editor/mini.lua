return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.ai").setup { n_lines = 500 }
    require("mini.surround").setup { n_lines = 500 }
    require("mini.move").setup { mappings = { left = "H", down = "J", right = "L", up = "K" } }
    require("mini.operators").setup()
    require("mini.splitjoin").setup()
  end,
}
