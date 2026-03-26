return {
  -- "jeangiraldoo/codedocs.nvim",
  dir = "D:/Personal/Github/codedocs.nvim",
  keys = {
    {
      "<leader>k", 
      function()
        require("codedocs").insert_docs()
      end,
    desc = "Insert CodeDocs"}
  },
  opts = {}
}
