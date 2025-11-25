
return {
  { {"n"}, "<leader>,",  function() Snacks.picker.buffers() end,                { desc = "Buffers"              } },
  { {"n"}, "g/",         function() Snacks.picker.grep() end,                   { desc = "Grep"                 } },
  { {"n"}, "<leader>.",  function() Snacks.scratch.open() end,                  { desc = "Scratch Buffer"       } },
  { {"n"}, "<leader>e",  function() Snacks.explorer() end,                      { desc = "Scratch Buffer"       } },
  { {"n"}, "<leader>E",  function() Snacks.explorer({ cwd = vim.uv.cwd() }) end,{ desc = "Scratch Buffer"       } },
  { {"n"}, "<leader>ff", function() Snacks.picker.files() end,                  { desc = "Find Files"           } },
  { {"n"}, "<leader>fp", function() Snacks.picker.projects() end,               { desc = "Projects"             } },
  { {"n"}, "<leader>sd", function() Snacks.picker.diagnostics() end,            { desc = "Diagnostics"          } },
  { {"n"}, "<leader>sh", function() Snacks.picker.help() end,                   { desc = "Help Pages"           } },
  { {"n"}, "<leader>sH", function() Snacks.picker.highlights() end,             { desc = "Highlights"           } },
  { {"n"}, "<leader>sl", function() Snacks.picker.loclist() end,                { desc = "Location List"        } },
  { {"n"}, "<leader>sq", function() Snacks.picker.qflist() end,                 { desc = "Quickfix List"        } },
  { {"n"}, "<leader>sn", function() Snacks.picker.notifications() end,          { desc = "Notifications"        } },
  { {"n"}, "<leader>rc", function() Snacks.debug.run() end,                     { desc = "Execute Lua Code"     } },
  { {"n"}, "<leader>bd", function() Snacks.bufdelete() end,                     { desc = "Delete Buffer"        } },
  { {"n"}, "<leader>bD", function() Snacks.bufdelete.other() end,               { desc = "Delete Other Buffers" } },
}
