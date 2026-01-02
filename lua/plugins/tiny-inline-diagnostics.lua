return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  opts = {
    options = {
      show_source = {
        enabled = true,
      },
      use_icons_from_diagnostics = true,
    },
  }
}
