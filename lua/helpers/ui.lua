---@class helpers.ui
local M = {}

function M.pad_str(in_str, width, align)
  local num_spaces = width - #in_str
  if num_spaces < 1 then
    num_spaces = 1
  end
  local spaces = string.rep(" ", num_spaces)
  if align == "left" then
    return table.concat({ in_str, spaces })
  end
  return table.concat({ spaces, in_str })
end

function M.hl_str(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
end

function M.group_number(num, sep)
  if num < 999 then
    return tostring(num)
  else
    num = tostring(num)
    return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^,", "")
  end
end

M.icons = {
  misc = {
    lsp = "󱁜",
    dots = "󰇘",
    branch = "",
    bullet = "•",
    o_bullet = "○",
    check = "✔",
    d_chev = "∨",
    file = "╼ ",
    hamburger = "≡",
    lock = "",
    r_chev = ">",
    location = "⌘",
    up_tri = "▲",
    info_i = "¡",
  },
  ft = {
    octo = "",
  },
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = "󱄽 ",
    String = " ",
    Struct = "󰆼 ",
    Supermaven = " ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
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
    -- "Package", -- remove package since luals uses it for control flow structures
    "Property",
    "Struct",
    "Trait",
  },
}

M.bg = "#000000"
M.fg = "#ffffff"

---@param group string|string[] hl group to get color from
---@param prop? string property to get. Defaults to 'fg'
function M.color(group, prop)
  prop = prop or "fg"
  group = type(group) == "table" and group or { group }

  ---@cast group string[]
  for _, g in ipairs(group) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
    if hl[prop] then
      return string.format("#%06x", hl[prop])
    end
  end
end

local hl_groups = {}
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("util_hl", { clear = true }),
  callback = function(args)
    for hl_group, hl in pairs(hl_groups) do
      vim.api.nvim_set_hl(0, hl_group, hl)
    end
  end,
})

--- Enusures the hl groups are always set, even after a colorscheme change.
---@param groups table<string, string|vim.api.keyset.highlight>
---@param opts {prefix?:string, default?:boolean, managed?:boolean}
function M.set_hl(groups, opts)
  opts = opts or {}
  for hl_group, hl in pairs(groups) do
    hl_group = opts.prefix and opts.prefix .. hl_group or hl_group
    hl = type(hl) == "string" and { link = hl } or hl --[[@as vim.api.keyset.highlight]]
    hl.default = opts.default
    if opts.managed ~= false then
      hl_groups[hl_group] = hl
    end
    vim.api.nvim_set_hl(0, hl_group, hl)
  end
end
return M
