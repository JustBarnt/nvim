return {
  "folke/todo-comments.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    { "<leader>st", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "BUG", "HACK" }}) end, desc = "Todo" }
  },
}
