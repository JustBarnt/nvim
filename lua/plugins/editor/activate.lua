return {
  -- dir = "D:/Personal/Github/activate.nvim",
  "justbarnt/activate.nvim",
  keys = {
    {
      "<leader>P",
      "<CMD>lua require'activate'.list_plugins()<CR>",
      desc = "Plugins"
    }
  },
  ---@class Activate.Config
  opts = { },
  dependencies = {
    "nvim-telescope/telescope.nvim"
  }
}
