return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
  opts = {
    default = {
      disable_diagnostics = false,
    },
    view = {
      merge_tool = {
        disable_diagnostics = false,
        winbar_info = true,
      },
    },
    enhanced_diff_hl = true, -- see ':h diffview-config-enhanced_diff_hl'
    hooks = {
      diff_buf_win_enter = function()
        vim.opt_local.foldenable = false
      end,
    },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "diffview")
    local actions = require("diffview.actions")
    require("diffview").setup(opts)
  end,
  keys = {
    -- use [c and [c to navigate diffs (vim built in), see :h jumpto-diffs
    -- use ]x and [x to navigate conflicts
    { "<leader>gdc", ":DiffviewOpen origin/main...HEAD", desc = "Compare commits" },
    { "<leader>gdq", ":DiffviewClose<CR>", desc = "Close Diffview tab" },
    { "<leader>gdh", ":DiffviewFileHistory %<CR>", desc = "File history" },
    { "<leader>gdH", ":DiffviewFileHistory<CR>", desc = "Repo history" },
    { "<leader>gdm", ":DiffviewOpen<CR>", desc = "Solve merge conflicts" },
    { "<leader>gdo", ":DiffviewOpen main", desc = "DiffviewOpen" },
    { "<leader>gdt", ":DiffviewOpen<CR>", desc = "DiffviewOpen this" },
    { "<leader>gdp", ":DiffviewOpen origin/main...HEAD --imply-local", desc = "Review current PR" },
    {
      "<leader>gdP",
      ":DiffviewFileHistory --range=origin/main...HEAD --right-only --no-merges --reverse",
      desc = "Review current PR (per commit)",
    },
  },
}
