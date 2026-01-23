local lsp = vim.lsp

---@param count integer
---@param severity? vim.diagnostic.Severity
local function diagnostic_goto(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, count = count }
  end
end

---@class config.keys
local M = {}

-- stylua: ignore start
---@type UserKeymaps[]
M.base = {
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

---@type UserKeymaps[]
M.lsp = {
  { { "n" },      "K",          function() require("hover").open() end,               { desc = "Hover"                      } },
  { { "n" },      "gd",         "<CMD>Glance definitions<CR>",                        { desc = "Goto Definition"            } },
  { { "n" },      "gD",         function() Snacks.picker.lsp_declarations() end,      { desc = "Goto Declaration"           } },
  { { "n" },      "grr",        "<CMD>Glance references<CR>",                         { desc = "Goto References"            } },
  { { "n" },      "grt",        "<CMD>Glance type_definitions<CR>",                   { desc = "Goto Type Definition"       } },
  { { "n" },      "gro",        function() Snacks.picker.lsp_symbols() end,           { desc = "Document Symbols"           } },
  { { "n" },      "grO",        function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace Symbols"          } },
  { { "n" },      "gri",        "<CMD>Glance implementations<CR>",                    { desc = "Goto Implementation"        } },
  { { "n" },      "<leader>uc", lsp.codelens.run,                                     { desc = "Run Codelens"               } },
  { { "n" },      "<leader>uC", lsp.codelens.refresh,                                 { desc = "Refresh & Display Codelens" } },
  { { "i" },      "<C-s>",      lsp.buf.signature_help,                               { desc = "Signature Helper"           } },
  { { "n" },      "grn",        lsp.buf.rename,                                       { desc = "Symbol Rename"              } },
  { { "n" },      "grf",        lsp.buf.format,                                       { desc = "Code Format"                } },
  { { "n" },      "grh",        lsp.buf.typehierarchy,                                { desc = "Show Type Hierarchy"        } },
  { { "n", "v" }, "gra",        lsp.buf.code_action,                                  { desc = "Code Actions"               } },

  -- Diagnostic Keymaps
  { { "n" },      "gl",         vim.diagnostic.open_float,                            { desc = "Get Diagnostics"            } },
  { { "n" },      "]d",         diagnostic_goto(1),                                   { desc = "Next Diagnostic"            } },
  { { "n" },      "[d",         diagnostic_goto(-1),                                  { desc = "Previous Diagnostic"        } },
  { { "n" },      "]e",         diagnostic_goto(1, 1),                                { desc = "Next Error"                 } },
  { { "n" },      "[e",         diagnostic_goto(-1, 1),                               { desc = "Previous Error"             } },
  { { "n" },      "]w",         diagnostic_goto(1, 2),                                { desc = "Next Warning"               } },
  { { "n" },      "[w",         diagnostic_goto(-1, 2),                               { desc = "Previous Warning"           } },
}

---@type UserKeymaps[]
M.lsp_rust = {
  -- Code Actions (grouped, better than vim.lsp.buf.code_action for Rust)
  { { "n", "v" }, "gra",         function() vim.cmd.RustLsp('codeAction') end,                    { desc = "Code Actions"           } },
  -- Hover with actions (better than standard hover)
  { { "n" },      "K",           function() vim.cmd.RustLsp({ 'hover', 'actions' }) end,          { desc = "Hover Actions"          } },
  -- Run/Execute
  { { "n" },      "<leader>rr",  function() vim.cmd.RustLsp('runnables') end,                     { desc = "Show All Runnables"              } },
  { { "n" },      "<leader>rR",  function() vim.cmd.RustLsp({ 'runnables', bang = true }) end,    { desc = "Rerun Last Runnable"    } },
  { { "n" },      "<leader>run", function() vim.cmd.RustLsp('run') end,                           { desc = "Run (Current Position)"  } },
  -- Debug
  { { "n" },      "<leader>rd",  function() vim.cmd.RustLsp('debuggables') end,                   { desc = "Debuggables"            } },
  { { "n" },      "<leader>rD",  function() vim.cmd.RustLsp({ 'debuggables', bang = true }) end,  { desc = "Rerun Last Debuggable"  } },
  { { "n" },      "<leader>dbg", function() vim.cmd.RustLsp('debug') end,                         { desc = "Debug (current context)"} },
  -- Tests
  { { "n" },      "<leader>rt",  function() vim.cmd.RustLsp('testables') end,                     { desc = "Testables"              } },
  { { "n" },      "<leader>rT",  function() vim.cmd.RustLsp({ 'testables', bang = true }) end,    { desc = "Rerun Last Testable"    } },
  -- Error explanation (shows rust error index docs)
  { { "n" },      "<leader>re",  function() vim.cmd.RustLsp('explainError') end,                  { desc = "Explain Error"          } },
  { { "n" },      "<leader>rec", function() vim.cmd.RustLsp({ 'explainError', 'cycle' }) end,     { desc = "Explain Error (cycle)"  } },
  { { "n" },      "<leader>rep", function() vim.cmd.RustLsp({ 'explainError', 'cycle_prev' }) end,{ desc = "Explain Error (prev)"   } },
  -- Open Cargo.toml
  { { "n" },      "<leader>rc",  function() vim.cmd.RustLsp('openCargo') end,                     { desc = "Open Cargo.toml"        } },
  -- Join lines (Rust-aware)
  { { "n" },      "J",           function() vim.cmd.RustLsp('joinLines') end,                     { desc = "Join Lines"             } },
  -- Syntax tree
  { { "n" },      "<leader>rs",  function() vim.cmd.RustLsp('syntaxTree') end,                    { desc = "Syntax Tree"            } },
  -- Workspace/Server management
  { { "n" },      "<leader>rw",  function() vim.cmd.RustLsp('reloadWorkspace') end,               { desc = "Reload Workspace"       } },
  { { "n" },      "<leader>rsr", function() vim.cmd.RustLsp('ssr') end,                           { desc = "Structural Search Replace" } },
  -- Workspace symbols
  { { "n" },      "<leader>rws", function() vim.cmd.RustLsp('workspaceSymbol') end,               { desc = "Workspace Symbol"       } },
  -- Related diagnostics
  { { "n" },      "<leader>rrd", function() vim.cmd.RustLsp('relatedDiagnostics') end,            { desc = "Related Diagnostics"    } },
}
-- stylua: ignore end

return M
