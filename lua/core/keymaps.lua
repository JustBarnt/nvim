local map = Helpers.safe_keymap_set
local strings = require "modules.utils.strings"

map({"n", "v"}, "<leader>rw", strings.replace_word_under_cursor, { desc = "Replace `<cword>` instance in buffer" })

map("n", "<leader>m", Helpers.marks.mark, { desc = "Mark line" })
map("n", "<leader>dm", Helpers.marks.del_mark, { desc = "Delete mark" })
map("n", "<leader>Dm", Helpers.marks.del_all_marks, { desc = "Delete all mark" })
map("n", "m", Helpers.marks.jump_to_mark, { desc = "Create Mark" })

-- better up/down
-- unless we provide a count like `5j|5k` we actually move by visual lines using `gj|gk` instead of
-- logical lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Buffers
-- stylua: ignore start
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc =  "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
-- stylua: ignore end

-- Move Lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd "noh"
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map({ "n" },"<C-q>", "<cmd>wq<cr><esc>", { desc  = "Save and Close Buffer"})

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>nf", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<leader>nt", "<cmd>TempFile", { desc = "New Temp File" })

---@param severity? vim.diagnostic.Severity
---@param count integer
local diagnostic_goto = function(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, count = count }
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(1), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(-1), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(1, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(-1, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(1, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(-1, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start

Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")

--stylua: ignore end

map("n", "<leader>uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(("Autoformatting turned: %s"):format(vim.g.autoformat and "on" or "off"), vim.log.levels.INFO)
end, { desc = "Toggle Autoformatting" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input "I"
end, { desc = "Inspect Tree" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Color Column
local cur_cc = {}

local function append_cc()
  local buf = vim.api.nvim_get_current_buf()
  if not cur_cc[buf] then
    cur_cc[buf] = vim.opt_local.colorcolumn:get()
  end

  vim.ui.input({ prompt = "Color Column" }, function(input)
    local new_cc = tonumber(input)
    vim.validate("new_cc", new_cc, "number")
    vim.opt_local.colorcolumn:append(input)
  end)
end

local function restore_cc()
  local buf = vim.api.nvim_get_current_buf()
  local orig = cur_cc[buf]

  if orig ~= nil then
    vim.opt_local.colorcolumn = orig
    cur_cc[buf] = nil
  end
end

map("n", "<leader>uca", append_cc, { desc = "Appends to Color Column [Buffer]" })
map("n", "<leader>ucr", restore_cc, { desc = "Restores Color Column [Buffer]" })
