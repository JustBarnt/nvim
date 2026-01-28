return {
  {
     "NeogitOrg/neogit",
     lazy = true,
     dependencies = {
       "nvim-lua/plenary.nvim",
       "sindrets/diffview.nvim",
       "folke/snacks.nvim"
     },
     cmd = "Neogit",
     keys = {
       { "<leader>gg", "<CMD>Neogit<CR>", desc = "Show Neogit"}
     },
     opts = {
      initial_branch_name = "main",
     }
  },
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff"
  },
  {
    "lewis6991/gitsigns.nvim",
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
      current_line_blame_opts = { virt_text = true, virt_text_pos = "eol" },
      current_line_blame_formatter = "<author> | <author_time:%c>",
      update_debounce = 200,
      on_attach = Utils.git.gitsigns_on_attach,
    },
  }
}
