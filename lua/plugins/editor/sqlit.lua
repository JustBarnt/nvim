return {
  "Maxteabag/sqlit.nvim",
  opts = {},
  keys = {
    { "<leader>od", function() require("sqlit").open() end, desc = "Database (Sqlit)" }
  }
}
