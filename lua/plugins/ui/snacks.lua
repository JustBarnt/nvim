---@module "snacks"

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
  "snacks.nvim",
  opts = {
    bufdelete = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = vim.fn.has "lazygit" == 1 },
    notifier = {
      style = "minimal",
      refresh = 500,
      top_down = false,
    },
    notify = {
      enabled = true,
    },
    ---@class snacks.picker
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
      win = {
        preview = {
          wo = {
            statuscolumn = "",
          },
        },
      },
    },
    profiler = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      shell = "nu.exe",
      win = {
        keys = {
          nav_h = { "<C-h>", term_nav "h", desc = "Go to Left Window", expr = true, mode = "t" },
          nav_j = { "<C-j>", term_nav "j", desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", term_nav "k", desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", term_nav "l", desc = "Go to Right Window", expr = true, mode = "t" },
        },
      },
    },
    toggle = {
      map = Helpers.safe_keymap_set,
    },
    words = { enabled = true },
  },
  --stylua: ignore
  keys = {
    -- Top Pickers & Explorer
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>.", function() Snacks.scratch.open() end, desc = "Scratch Buffer" },
    -- find
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>shi", function() Snacks.picker.highlights() end, desc = "Highlights"},
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sz", function() Snacks.picker.zoxide() end, desc = "Use Zoxide to find a directory" },
  },
}
