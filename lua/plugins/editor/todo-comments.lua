return {
  "folke/todo-comments.nvim",
  event = "BufReadPre",
  opts = {},
  config = function(_, opts)
    require("todo-comments").setup(opts)
  end
}
