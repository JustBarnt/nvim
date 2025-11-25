---@type UserKeymaps[]
return {
  -- Better up/down unless we provide a count like `5j` move by visual lines `gj` instead of logical lines
  { {"n", "x"}, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true } },
  { {"n", "x"}, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true } },

  -- Windows
  { {"n"}, "<leader>-", "<C-w>s",  { desc = "Split Window Below" } },
  { {"n"}, "<leader>|", "<C-w>v",  { desc = "Split Window Right" } },
  { {"n"}, "<leader>wd", "<C-w>c", { desc = "Delete Window"      } },


  -- Window movement
  { {"n"}, "<C-h>", "<C-w>h", { desc = "Focus Left Window"  } },
  { {"n"}, "<C-j>", "<C-w>j", { desc = "Focus Lower Window" } },
  { {"n"}, "<C-k>", "<C-w>k", { desc = "Focus Upper Window" } },
  { {"n"}, "<C-l>", "<C-w>l", { desc = "Focus Right Window" } },

  -- Resize Windows
  { {"n"}, "<C-Left>",  "<CMD>vertical resize -2<cr>", { desc = "Decrease Window Width"  } },
  { {"n"}, "<C-Down>",  "<CMD>resize -2<cr>",          { desc = "Decrease Window Height" } },
  { {"n"}, "<C-Up>",    "<CMD>resize +2<cr>",          { desc = "Increase Window Height" } },
  { {"n"}, "<C-Right>", "<CMD>vertical resize +2<cr>", { desc = "Increase Window Width"  } },

  -- Move Lines
  { {"v"}, "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down" } },
  { {"v"}, "K", ":m '<-2<CR>gv=gv", { desc = "Move Line Up"   } },

  -- Clear Search
  { {"n"}, "<ESC>", "<CMD>nohlsearch<CR><ESC>", { desc = "Clear Highlight Search" } },

  -- Saner Searching with `/|?` n -> always search down | N -> always search up
  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  { {"n"}, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" }},
  { {"x"}, "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result" }},
  { {"o"}, "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result" }},
  { {"n"}, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" }},
  { {"x"}, "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result" }},
  { {"o"}, "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result" }},

  -- Better Indenting
  { {"v"}, "<", "<gv" },
  { {"v"}, ">", ">gv" },

  -- Lazy
  { {"n"}, "<leader>l", "<CMD>Lazy<CR>",      { desc = "Lazy" }},
}
