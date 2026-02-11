return {
  "DrKJeff16/project.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  opts = {
    snacks = {
      enabled = true,
      opts = {
        sort = 'newest',
        hidden = false,
        title = "Select Project",
        layout = "select"
      }
    }
  }
}
