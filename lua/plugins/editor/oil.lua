return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = false,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    lsp_file_methods = {
      autosave_changes = "unmodified",
    },
  },
  lazy = false,
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(opts)
    vim.keymap.set("n", "-", oil.toggle_float, { desc = "Open Parent Directory" })
  end,
}
