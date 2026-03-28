return {
  "jeangiraldoo/codedocs.nvim",
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
