local map = Snacks.keymap

map.set("n", "<leader>-", "<C-w>s", { desc = "Split Window Below" })
map.set("n", "<leader>|", "<C-w>v", { desc = "Split Window Right" })

-- Mark Helpers
map.set("n", "<leader>m", Utils.marks.mark, { desc = "Mark line" })
map.set("n", "<leader>dm", Utils.marks.del_mark, { desc = "Delete mark" })
map.set("n", "<leader>Dm", Utils.marks.del_all_marks, { desc = "Delete all mark" })
map.set("n", "m", Utils.marks.jump_to_mark, { desc = "Create Mark" })

-- Lazy
map.set("n", "<leader>l", "<CMD>Lazy<CR>", { desc = "Lazy" })

-- Buffer navigation
map.set("n", "<S-h>", "<CMD>bprevious<CR>", { desc = "Previous Buffer" })
map.set("n", "<S-l>", "<CMD>bnext<CR>", { desc = "Next Buffer" })
map.set("n", "<leader>dB", "<CMD>:bd<CR>", { desc = "Delete Buffer and Window" })

map.set("n", "<leader>Rn", function()
  local session = vim.fn.stdpath("state") .. "/restart_session.vim"
  vim.cmd("mksession! " .. vim.fn.fnameescape(session))
  vim.cmd("restart source " .. vim.fn.fnameescape(session))
end, { desc = "Restart Neovim" })

map.set({ "n", "x" }, "<leader>rw", function()
  local word = vim.fn.expand("<cword>")
  local mode = vim.fn.mode()
  
  if mode == "v" or mode == "V" then
    local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
    word = table.concat(lines, "\n")
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  end

  local prompt = "Replace: %s [%d]:"
  local cpos = vim.api.nvim_win_get_cursor(0)
  local ns_id = vim.api.nvim_create_namespace("replace_word_ns")

  local function update_virtual_text(bufnr, input_text)
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, col, {
      virt_text = { { "[" .. #input_text .. "]", "Comment" } },
      virt_text_pos = "eol",
    })
  end

  vim.ui.input({ prompt = string.format(prompt, word, #word) }, function(input)
    if input and #input > 0 then
      local pattern = "\\V" .. vim.fn.escape(word, "\\#"):gsub("\n", "\\n")
      vim.cmd(string.format("%%s#%s#%s#g", pattern, vim.fn.escape(input, "\\#&~")))
      cpos[1] = math.min(cpos[1], vim.api.nvim_buf_line_count(0))
      vim.api.nvim_win_set_cursor(0, cpos)
    end
  end)

  local bufnr = vim.api.nvim_get_current_buf()

  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = bufnr,
    callback = function()
      local input_text = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
      update_virtual_text(bufnr, input_text)
    end,
  })
end, { desc = "Replace `<cword>` or visual selection in buffer" })
