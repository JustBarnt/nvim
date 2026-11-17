return {
  "Maxteabag/sqlit.nvim",
  enabled = not vim.g.vsneo,
  opts = {},
  keys = {
    { "<leader>od", function() require("sqlit").open() end, desc = "Database (Sqlit)" }
  }
}
