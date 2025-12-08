local ok, gs = pcall(require, "gitsigns")
local keys = {}


if ok then
  local function next_hunk()
    if vim.wo.diff then 
      vim.cmd.normal({"]c", bang = true})
    else 
      ---@diagnostic disable-next-line: param-type-mismatch
      gs.nav_hunk("next") 
    end
  end

  local function prev_hunk()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      ---@diagnostic disable-next-line: param-type-mismatch
      gs.nav_hunk("prev")
    end
  end

  local function first_hunk()
      ---@diagnostic disable-next-line: param-type-mismatch
    gs.nav_hunk("first") 
  end

  local function last_hunk()
      ---@diagnostic disable-next-line: param-type-mismatch
    gs.nav_hunk("last") 
  end

  ---@type UserKeymaps[]
  keys = {
    { {"n"}, "]h", next_hunk,                                                             { desc = "Next Hunk"     } },
    { {"n"}, "[h", prev_hunk,                                                             { desc = "Previous Hunk" } },
    { {"n"}, "]H", first_hunk,                                                            { desc = "First Hunk"    } },
    { {"n"}, "[H", last_hunk,                                                             { desc = "Last Hunk"     } },
    { {"n", "v"}, "<leader>ghs", "<CMD>Gitsigns stage_hunk<CR>",                          { desc = "Stage Hunk"    } },
    { {"n", "v"}, "<leader>ghu", "<CMD>Gitsigns undo_stage_hunk<CR>",                     { desc = "Unstage Hunk"  } },
    { {"n", "v"}, "<leader>ghr", "<CMD>Gitsigns reset_hunk<CR>",                          { desc = "Reset Hunk"    } },
    { {"n", "v"}, "<leader>ghr", "<CMD>Gitsigns preview_hunk_inline<CR>",                 { desc = "Preview Hunk"  } },
  }
end

return {
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
    current_line_blame_opts = { virt_text = true, virt_text_pos = "right_align" },
    current_line_blame_formatter = "<author> | <author_time:%c>",
    update_debounce = 200,
    on_attach = function(bufnr)
      Utils.keymaps.make_buffer_only(keys, bufnr)
    end,
  }
}
