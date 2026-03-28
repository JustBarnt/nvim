return {
  {
    "seblyng/roslyn.nvim",
    enabled = false,
    ft = "cs",
    ---@type RoslynNvimConfig
    opts = {
      filewatching = "auto",
      broad_search = false,
      lock_target = true,
    }
  }
}
