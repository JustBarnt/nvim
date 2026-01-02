local keys = {
  -- Most Used
  { {'n'}, '<leader><space>',   function() Snacks.picker.smart() end,                  { desc = 'Smart Find Files'     } },
  { {'n'}, '<leader>,',         function() Snacks.picker.buffers() end,                { desc = 'Buffers'              } },
  { {'n'}, 'g/',                function() Snacks.picker.grep() end,                   { desc = 'Grep'                 } },
  { {'n'}, '<leader>.',         function() Snacks.scratch.open() end,                  { desc = 'Scratch Buffer'       } },
  { {'n'}, '<leader>e',         function() Snacks.explorer() end,                      { desc = 'File Explorer'        } },
  { {'n'}, '<leader>E',         function() Snacks.explorer({ cwd = vim.uv.cwd() }) end,{ desc = 'File Explorer Root'   } },
  { {'n'}, '[[',                function() Snacks.words.jump(-vim.v.count1) end,       { desc = 'Previous Reference'   } },
  { {'n'}, ']]',                function() Snacks.words.jump(vim.v.count1) end,{ desc = 'Next Reference'   } },

  -- Find
  { {'n'}, '<leader>fb',        function() Snacks.picker.buffers() end,                { desc = 'Buffers'              } },
  { {'n'}, '<leader>ff',        function() Snacks.picker.files() end,                  { desc = 'Files'                } },
  { {'n'}, '<leader>fp',        function() Snacks.picker.projects() end,               { desc = 'Projects'             } },
  { {'n'}, '<leader>fr',        function() Snacks.picker.recent() end,                 { desc = 'Recent'               } },

  -- Search
  { {'n'}, '<leader>s"',        function() Snacks.picker.registers() end,              { desc = 'Registers'            } },
  { {'n'}, '<leader>s/',        function() Snacks.picker.search_history() end,         { desc = 'History'              } },
  { {'n'}, '<leader>sb',        function() Snacks.picker.lines() end,                  { desc = 'Buffer Lines'         } },
  { {'n'}, '<leader>sd',        function() Snacks.picker.diagnostics() end,            { desc = 'Diagnostics'          } },
  { {'n'}, '<leader>sh',        function() Snacks.picker.help() end,                   { desc = 'Help Pages'           } },
  { {'n'}, '<leader>sH',        function() Snacks.picker.highlights() end,             { desc = 'Highlights'           } },
  { {'n'}, '<leader>sl',        function() Snacks.picker.loclist() end,                { desc = 'Location List'        } },
  { {'n'}, '<leader>sq',        function() Snacks.picker.qflist() end,                 { desc = 'Quickfix List'        } },
  { {'n'}, '<leader>sn',        function() Snacks.picker.notifications() end,          { desc = 'Notifications'        } },
  { {'n'}, '<leader>rc',        function() Snacks.debug.run() end,                     { desc = 'Execute Lua Code'     } },
  { {'n'}, '<leader>bd',        function() Snacks.bufdelete() end,                     { desc = 'Delete Buffer'        } },
  { {'n'}, '<leader>bD',        function() Snacks.bufdelete.other() end,               { desc = 'Delete Other Buffers' } },
}

return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  opts = {
    bufdelete = { enabled = true },
    dashboard = { enabled = true },
    explorer = { replace_netrw = true, trash = true },
    input = { enabled = true },
    lazygit = { enabled = vim.fn.has("lazygit") == 1 },
    notifier = { style = "minimal", refresh = 50, top_down = false },
    notify = { enabled = true },
    ---@class snacks.picker
    picker = {
      actions = require("trouble.sources.snacks").actions, 
      formatters = {
        file = {
          filename_first = true,
        },
      },
      sources = {
        explorer  = {
          ignored = true,
          layout = { preset = "sidebar", layout = { position = "right" } },
        }
      },
      win = {
        input = {
          keys = {
            ["<C-t>"] = {
              "trouble_open",
              mode = { "n", "i" },
            }
          }
        },
        preview = {
          wo = {
            statuscolumn = "",
          },
        },
      },
    },
    statuscolumn = { enabled = true },
    words = { enabled = true }
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    Utils.keymaps.enable(keys)
  end,
}
