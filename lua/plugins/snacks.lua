-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  --stylua: ignore-start
  keys = {
    -- Most Used
    { '<leader>.',   function() Snacks.scratch.open() end,              desc = 'Scratch Buffer' },
    { '<leader>e',   function() Snacks.explorer() end,                  desc = 'File Explorer' },
    { '<leader>:',   function() Snacks.picker.command_history() end,    desc = 'File Explorer' },
    { 'g/',          function() Snacks.picker.grep() end,               desc = 'Grep' },
    { '[[',          function() Snacks.words.jump(-vim.v.count1) end,   desc = 'Previous Reference' },
    { ']]',          function() Snacks.words.jump(vim.v.count1) end,    desc = 'Next Reference' },

    -- Find
    { '<leader>ff',  function() Snacks.picker.files() end,              desc = 'Files' },
    { '<leader>fp',  function() Snacks.picker.projects() end,           desc = 'Projects' },
    { '<leader>fr',  function() Snacks.picker.recent() end,             desc = 'Recent' },

    -- Git
    { '<leader>gsd', function() Snacks.picker.git_diff() end,           desc = "Search Git Diffs"},

    -- Search
    { '<leader>s"',  function() Snacks.picker.registers() end,          desc = 'Registers' },
    { '<leader>s/',  function() Snacks.picker.search_history() end,     desc = 'History' },
    { '<leader>sl',  function() Snacks.picker.lines() end,              desc = 'Buffer Lines' },
    { '<leader>sb',  function() Snacks.picker.grep_buffers() end,       desc = 'Grep Buffers' },
    { '<leader>sw',  function() Snacks.picker.grep_word() end,          desc = 'Grep Buffers' },
    { '<leader>sd',  function() Snacks.picker.diagnostics() end,        desc = 'Diagnostics' },
    { '<leader>sD',  function() Snacks.picker.diagnostics_buffer() end, desc = 'Diagnostics' },
    { '<leader>sh',  function() Snacks.picker.help() end,               desc = 'Help Pages' },
    { '<leader>sH',  function() Snacks.picker.highlights() end,         desc = 'Highlights' },
    { '<leader>sn',  function() Snacks.picker.notifications() end,      desc = 'Notifications' },

    -- Terminal
    { "<leader>tt",  function() Snacks.terminal() end,                  desc = "Terminal (cwd)" },

    -- Misc
    { '<leader>cr',  function() Snacks.debug.run() end,                 desc = 'Execute Lua Code' },
    { '<leader>db',  function() Snacks.bufdelete() end,                 desc = 'Delete Buffer' },
    { '<leader>dob', function() Snacks.bufdelete.other() end,           desc = 'Delete Other Buffers' },
  },
  --stylua: ignore-end
  ---@type snacks.Config
  opts = {
    animate = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = { enabled = true },
    explorer = { replace_netrw = true, trash = true },
    input = { enabled = true },
    image = { enabled = true },
    lazygit = { enabled = vim.fn.has("lazygit") == 1 },
    notifier = { style = "minimal", refresh = 50, top_down = false },
    notify = { enabled = true },
    picker = {
      debug = { score = true },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      previewers = {
        diff = { cmd = "delta" },
        file = {
          max_size = 1024 * 1024 * 4, -- 4MB
          max_line_length = 2000
        }
      },
      sources = {
        explorer = {
          ignored = true,
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
    quickfile = { enabled = true }, -- When doing `nvim <filename>` load it as quickly as possible before loading plugins
    rename = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      win = {
        keys = {
          nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window",  expr = true, mode = "t" },
          nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
        }
      }
    },
    words = { enabled = true }
  }
}
