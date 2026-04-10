local map = Snacks.keymap

-- Mark Helpers
map.set("n", "<leader>m", Utils.marks.mark, { desc = "Mark line" })
map.set("n", "<leader>dm", Utils.marks.del_mark, { desc = "Delete mark" })
map.set("n", "<leader>Dm", Utils.marks.del_all_marks, { desc = "Delete all mark" })
map.set("n", "m", Utils.marks.jump_to_mark, { desc = "Create Mark" })

-- Better Indenting
map.set("v", "<", "<gv")
map.set("v", ">", ">gv")

-- Lazy
map.set("n", "<leader>l", "<CMD>Lazy<CR>", { desc = "Lazy" })

-- Buffer navigation
map.set("n", "<S-h>", "<CMD>bprevious<CR>", { desc = "Previous Buffer" })
map.set("n", "<S-l>", "<CMD>bnext<CR>", { desc = "Next Buffer" })
map.set("n", "<leader>dB", "<CMD>:bd<CR>", { desc = "Delete Buffer and Window" })

-- Better up/down unless we provide a count like `5j` move by visual lines `gj` instead of logical lines
map.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

-- Windows
map.set("n", "<leader>-", "<C-w>s", { desc = "Split Window Below" })
map.set("n", "<leader>|", "<C-w>v", { desc = "Split Window Right" })
map.set("n", "<C-h>", "<C-w>h", { desc = "Focus Left Window" })
map.set("n", "<C-j>", "<C-w>j", { desc = "Focus Lower Window" })
map.set("n", "<C-k>", "<C-w>k", { desc = "Focus Upper Window" })
map.set("n", "<C-l>", "<C-w>l", { desc = "Focus Right Window" })

-- Move Lines
map.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down" })
map.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Line Up" })

-- Clear Search
map.set("n", "<ESC>", "<CMD>nohlsearch<CR><ESC>", { desc = "Clear Highlight Search" })

-- Saner Searching with `/|?` n -> always search down | N -> always search up
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })


map.set("n", "<leader>Rn", function()
  local session = vim.fn.stdpath("state") .. "/restart_session.vim"
  vim.cmd("mksession! " .. vim.fn.fnameescape(session))
  vim.cmd("restart source " .. vim.fn.fnameescape(session))
end, { desc = "Restart Neovim" })
