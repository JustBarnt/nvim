return {
  {
     "rachartier/tiny-code-action.nvim",
     dependencies = {
       "nvim-lua/plenary.nvim",
       "folke/snacks.nvim"
     },
     event = "LspAttach",
     opts = {
       backend = vim.fn.executable("delte") == 1 and "delta" or "vim",
       picker = "snacks",
     }
  }
}
