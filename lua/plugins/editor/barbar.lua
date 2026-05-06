return {
  "romgrk/barbar.nvim",
  init = function() vim.g.barbar_auto_setup = false end,
  config = function()
    require("barbar").setup({
      auto_hide = 1,
      icons = {
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = Utils.ui.icons.diagnostics.Error },
          [vim.diagnostic.severity.WARN] = { enabled = true, icon = Utils.ui.icons.diagnostics.Warn },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = false },
        },
        gitsigns = {
          added = { enabled = false },
          changed = { enabled = false },
          removed = { enabled = false },
        },
      }
    })

    Snacks.keymap.set("n", "<S-h>", "<CMD>BufferPrevious<CR>", {desc = "Previous Buffer"})
    Snacks.keymap.set("n", "<S-l>", "<CMD>BufferNext<CR>", {desc = "Next Buffer"})
    Snacks.keymap.set("n", "<A-h>", "<CMD>BufferMovePrevious<CR>", {desc = "Move Buffer Left"})
    Snacks.keymap.set("n", "<A-l>", "<CMD>BufferMoveNext<CR>", {desc = "Move Buffer Right"})
  end
}

