return {
  "folke/todo-comments.nvim",
  event = "BufReadPre",
  opts = {
    highlight = {
      multiline = true,
      multiline_pattern = "^.",
      multiline_context = 10,
      before = "",
      keyword = "bg",
      after = "bg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },
    keywords = {
      FIX = {
        icon = " ",
        color = "error",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
  },
  keys = {
    { "<leader>st", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "BUG", "HACK" } }) end, desc = "Todo" }
  },
}
