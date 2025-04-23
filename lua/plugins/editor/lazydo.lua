return {
  "Dan7h3x/LazyDo",
  event = "VeryLazy",
  branch = "main",
  cmd = { "LazyDoToggle", "LazyDoPin", "LazyDoToggleStorage" },
  keys = { -- recommended keymap for easy toggle LazyDo in normal and insert modes (arbitrary)
    {
      "<F2>",
      "<ESC><CMD>LazyDoToggle<CR>",
      mode = { "n", "i" },
    },
  },
  opts = function(_, opts)
    return {
      storage = {
        startup_detect = true, -- Auto-detect projects on startup
        project = {
          enabled = true,
          auto_detect = true,
        },
      },
    }
  end,
}
