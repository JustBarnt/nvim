---@class PluginConfigs.snacks
local M = {}

M.config = {
  bufdelete = { enabled = true },
  dashboard = { enabled = true },
  explorer = {
    replace_netrw = true,
    trash = true
  },
  input = { enabled = true },
  lazygit = { enabled = vim.fn.has("lazygit") == 1 },
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
}

-- TODO: I want to move this to keymaps?
--stylua: ignore
M.keys = {
  { "<leader>,",  function() Snacks.picker.buffers() end,                 "Buffers" },
  { "g/",         function() Snacks.picker.grep() end,                    "Grep" },
  { "<leader>.",  function() Snacks.scratch.open() end,                   "Scratch Buffer" },
  { "<leader>e",  function() Snacks.explorer() end,                       "Scratch Buffer" },
  { "<leader>E",  function() Snacks.explorer({ cwd = vim.uv.cwd() }) end, "Scratch Buffer" },
  { "<leader>ff", function() Snacks.picker.files() end,                   "Find Files" },
  { "<leader>fp", function() Snacks.picker.projects() end,                "Projects" },
  { "<leader>sd", function() Snacks.picker.diagnostics() end,             "Diagnostics" },
  { "<leader>sh", function() Snacks.picker.help() end,                    "Help Pages" },
  { "<leader>sH", function() Snacks.picker.highlights() end,              "Highlights"},
  { "<leader>sl", function() Snacks.picker.loclist() end,                 "Location List" },
  { "<leader>sq", function() Snacks.picker.qflist() end,                  "Quickfix List" },
  { "<leader>rc", function() Snacks.debug.run() end,                      "Execute Lua Code" },
  { "<leader>bd", function() Snacks.bufdelete() end,                      "Delete Buffer" },
  { "<leader>bD", function() Snacks.bufdelete.other() end,                "Delete All But Active Buffers" },
}

return M
