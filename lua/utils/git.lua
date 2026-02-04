---@class utils.git
local M = {}

function M.gitsigns_on_attach(buffer)
  local gitsigns = require("gitsigns")
  local map = Snacks.keymap.set

  -- Navigation
  map("n", ']c', function()
    if vim.wo.diff then
      vim.cmd.normal({ ']c', bang = true })
    else
      gitsigns.nav_hunk("prev")
    end
  end, { buffer = buffer })

  map("n", '[c', function()
    if vim.wo.diff then
      vim.cmd.normal({ '[c', bang = true })
    else
      gitsigns.nav_hunk("next")
    end
  end, { buffer = buffer })

  -- Actions
  map("n", '<leader>hs', gitsigns.stage_hunk, { desc = "Stage Hunk", buffer = buffer })
  map("n", '<leader>hr', gitsigns.reset_hunk, { desc = "Reset Hunk", buffer = buffer })

  map("v", "<leader>hs", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage Hunk (Visual)", buffer = buffer })

  map("v", "<leader>hr", function()
    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset Hunk (Visual)", buffer = buffer })

  map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer", buffer = buffer })
  map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer", buffer = buffer })
  map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk", buffer = buffer })
  map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Hunk (Inline)", buffer = buffer })
  map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This", buffer = buffer })
  map("n", "<leader>hd", function() gitsigns.diffthis("~") end, { desc = "Diff This (Root)", buffer = buffer })

  map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame Line", buffer = buffer })

  -- Quickfix
  map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { desc = "Add all hunks to Quickfix", buffer = buffer })
  map("n", "<leader>hq", gitsigns.setqflist, { desc = "Add buffer hunks to Quickfix", buffer = buffer })

  -- Toggles
  map("n", "<leader>ugb", gitsigns.toggle_current_line_blame, { desc = "Toggle: Current Line Blame (GitSigns)", buffer = buffer })
  map("n", "<leader>ugw", gitsigns.toggle_word_diff, { desc = "Toggle: Word Diff (GitSigns)", buffer = buffer })

  -- Text object
  map({"o", "x"}, 'ih', gitsigns.select_hunk, { desc = "inner hunk", buffer = buffer })
end

return M
