return {
  "LudoPinelli/comment-box.nvim",
  cmd = {
    "CBcatalog",
    "CBllbox",
    "CBllline",
    "CBline",
    "CBalbox15",
    "CBd",
    "CBy"
  },
  keys = {
    { "<leader>cbb", "<CMD>CBllbox<CR>", desc = "Comment Box" },
    { "<leader>cbt", "<CMD>CBllline<CR>", desc = "Comment Box Title" },
    { "<leader>cbl", "<CMD>CBline<CR>", desc = "Comment Box Line" },
    { "<leader>cbB", "<CMD>CBalbox15<CR>", desc = "Comment Box Alt" },
    { "<leader>cbd", "<CMD>CBd<CR>", desc = "Delete Comment Box" },
    { "<leader>cby", "<CMD>CBy<CR>", desc = "Yank Comment Box" },
  }
}

