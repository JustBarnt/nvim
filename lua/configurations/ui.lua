---@class config.ui
local M = {}

M.icons = {
  folds = {
    open = "",
    close = ""
  },
  misc = {
    lsp = "󱁜 ",
    dots = "󰇘 ",
    branch = " ",
    bullet = "• ",
    dot = " ",
    check = " ",
    chev = {
      down = " ",
      right = " ",
      up = " ",
    },
    file = "╼ ",
    hamburger = "󰍜 ",
    lock = " ",
    location = " ",
    info_i = " ",
    package = {
      installed = "󱧕 ",
      uninstalled = "󱧖 ",
      updates = "󰏗 "
    },
  },
  ft = {
    octo = " ",
  },
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    lsp = {
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = "󰊕 ",
      Interface = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Operator = " ",
      Property = "󰜢 ",
      Reference = " ",
      Snippet = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
    Array = " ",
    Boolean = "󰨙 ",
    Collapsed = " ",
    Control = " ",
    Namespace = "󰦮 ",
    Number = "󰎠 ",
    Object = " ",
    Package = " ",
    String = " ",
  },
}

---@type table<string, string[]|boolean>?
M.kind_filter = {
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
  markdown = false,
  help = false,
  -- you can specify a different filter for each filetype
  lua = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
}

return M
