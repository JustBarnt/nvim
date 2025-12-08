local keys = {
  { {"n"}, "<leader>,",  function() Snacks.picker.buffers() end,                { desc = "Buffers"              } },
  { {"n"}, "g/",         function() Snacks.picker.grep() end,                   { desc = "Grep"                 } },
  { {"n"}, "<leader>.",  function() Snacks.scratch.open() end,                  { desc = "Scratch Buffer"       } },
  { {"n"}, "<leader>e",  function() Snacks.explorer() end,                      { desc = "File Explorer"        } },
  { {"n"}, "<leader>E",  function() Snacks.explorer({ cwd = vim.uv.cwd() }) end,{ desc = "File Explorer Root"   } },
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

return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  opts = {
    bufdelete = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = false, replace_netrw = true, trash = true },
    input = { enabled = true },
    lazygit = { enabled = vim.fn.has("lazygit") == 1 },
    notifier = { style = "minimal", refresh = 50, top_down = false },
    notify = { enabled = true },
    ---@class snacks.picker
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
      sources = {
        explorer  = {
          layout = { preset = "sidebar", layout = { position = "right" } },
        }
      },
      win = {
        preview = {
          wo = {
            statuscolumn = "",
          },
        },
      },
    },
    statuscolumn = { enabled = true },
  },
  keys = {
    { "<leader>,",  function() Snacks.picker.buffers() end,                { desc = "Buffers"              } },
    { "g/",         function() Snacks.picker.grep() end,                   { desc = "Grep"                 } },
    { "<leader>.",  function() Snacks.scratch.open() end,                  { desc = "Scratch Buffer"       } },
    { "<leader>e",  function() Snacks.explorer() end,                      { desc = "File Explorer"        } },
    { "<leader>E",  function() Snacks.explorer({ cwd = vim.uv.cwd() }) end,{ desc = "File Explorer Root"   } },
    { "<leader>ff", function() Snacks.picker.files() end,                  { desc = "Find Files"           } },
    { "<leader>fp", function() Snacks.picker.projects() end,               { desc = "Projects"             } },
    { "<leader>sd", function() Snacks.picker.diagnostics() end,            { desc = "Diagnostics"          } },
    { "<leader>sh", function() Snacks.picker.help() end,                   { desc = "Help Pages"           } },
    { "<leader>sH", function() Snacks.picker.highlights() end,             { desc = "Highlights"           } },
    { "<leader>sl", function() Snacks.picker.loclist() end,                { desc = "Location List"        } },
    { "<leader>sq", function() Snacks.picker.qflist() end,                 { desc = "Quickfix List"        } },
    { "<leader>sn", function() Snacks.picker.notifications() end,          { desc = "Notifications"        } },
    { "<leader>rc", function() Snacks.debug.run() end,                     { desc = "Execute Lua Code"     } },
    { "<leader>bd", function() Snacks.bufdelete() end,                     { desc = "Delete Buffer"        } },
    { "<leader>bD", function() Snacks.bufdelete.other() end,               { desc = "Delete Other Buffers" } },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    -- Utils.keymaps.enable(keys)
  end,
}
