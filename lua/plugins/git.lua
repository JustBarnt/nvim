return {
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff"
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = { virt_text = true, virt_text_pos = "right_align" },
      current_line_blame_formatter = "<author> | <author_time:%c>",
      update_debounce = 200,
      -- on_attach = function(bufnr)
      --   Utils.keymaps.make_buffer_only(keys, bufnr)
      -- end,
    },
    keys = {
      { "]h",          "<CMD>Gitsigns next_hunk<CR>",           desc = "Next Hunk" },
      { "[h",          "<CMD>Gitsigns prev_hunk<CR>",           desc = "Previous Hunk" },
      { "]H",          "<CMD>Gitsigns nav_hunk \"first\"<CR>",  desc = "First Hunk" },
      { "[H",          "<CMD>Gitsigns nav_hunk \"last\"<CR>",   desc = "Last Hunk" },
      { "<leader>ghs", "<CMD>Gitsigns stage_hunk<CR>",          desc = "Stage Hunk" },
      { "<leader>ghu", "<CMD>Gitsigns undo_stage_hunk<CR>",     desc = "Unstage Hunk" },
      { "<leader>ghr", "<CMD>Gitsigns reset_hunk<CR>",          desc = "Reset Hunk" },
      { "<leader>ghr", "<CMD>Gitsigns preview_hunk_inline<CR>", desc = "Preview Hunk" },
    }
  }
}
