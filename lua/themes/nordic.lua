-- this line for types, by hovering and autocompletion (lsp required)
-- will help you understanding properties, fields, and what highlightings the color used for
---@class Base46Table
local M = {}
-- UI
M.base_30 = {
  white = "#BBC3D4",
  black = "#242933", -- usually your theme bg
  darker_black = "#15181E", -- 6% darker than black
  black2 = "#2F3442", -- 6% lighter than black
  one_bg = "#373E4E", -- 10% lighter than black
  one_bg2 = "#40485A", -- 6% lighter than one_bg2
  one_bg3 = "#4D566C", -- 6% lighter than one_bg3
  grey = "#7C87A2", -- 40% lighter than black (the % here depends so choose the perfect grey!)
  grey_fg = "#959FB3", -- 10% lighter than grey
  grey_fg2 = "#8691A9", -- 5% lighter than grey
  light_grey = "#60728A",
  red = "#BF616A",
  baby_pink = "#C5727A",
  pink = "#B74E58",
  line = "#42495D", -- 15% lighter than black
  green = "#A3BE8C",
  vibrant_green = "#B1C89D",
  nord_blue = "#81A1C1",
  blue = "#5E81AC",
  seablue = "#88C0D0",
  yellow = "#EBCB8B", -- 8% lighter than yellow
  sun = "#E7C173",
  purple = "#B48EAD",
  dark_purple = "#A97EA1",
  teal = "#80B3B2",
  orange = "#D08770",
  cyan = "#8FBCBB",
  statusline_bg = "#333945",
  lightbg = "#3f4551",
  pmenu_bg = "#A3BE8C",
  folder_bg = "#7797b7",
}

-- check https://github.com/chriskempson/base16/blob/master/styling.md for more info
M.base_16 = {
  base00 = "#242933",
  base01 = "#2F3442",
  base02 = "#373E4E",
  base03 = "#40485A",
  base04 = "#D8DEE9",
  base05 = "#E5E9F0",
  base06 = "#ECEFF4",
  base07 = "#8FBCBB",
  base08 = "#88C0D0",
  base09 = "#81A1C1",
  base0A = "#88C0D0",
  base0B = "#A3BE8C",
  base0C = "#D08770",
  base0D = "#D08770",
  base0E = "#D08770",
  base0F = "#BF616A",
}

-- OPTIONAL
-- overriding or adding highlights for this specific theme only
-- defaults/treesitter is the filename i.e integration there,

M.polish_hl = {
  defaults = {
    Macro = { fg = M.base_30.red },
  },

  syntax = {
    Boolean = { link = "Number" },
    Character = { bg = M.base_30.green },
    Conditional = { link = "Keyword" },
    Constant = { fg = M.base_30.baby_pink },
    Define = { link = "Macro" },
    Delimeter = { italic = true, fg = M.base_30.light_grey },
    Float = { link = "Number" },
    Function = { fg = M.base_30.nord_blue },
    Identifier = { fg = M.base_30.white },
    Include = { link = "Macro" },
    Keyword = { fg = M.base_30.orage, bold = true },
    Label = { link = "Keyword" },
    Number = { link = "Constant" },
    Operator = { fg = M.base_30.white },
    PreProc = { link = "Macro" },
    Repeat = { link = "Keyword" },
    Special = { fg = M.base_30.nord_blue },
    SpecialChar = { fg = M.base_30.red },
    Statement = { link = "Keyword" },
    StorageClass = { link = "Keyword" },
    String = { fg = M.base_30.green },
    Structure = { link = "Type" },
    Tag = { link = "Type" },
    Todo = { bg = M.base_30.yellow, fg = M.base_30.darker_black },
    Type = { fg = M.base_30.yellow },
    Typedef = { link = "Type" },
    Variable = { fg = M.base_30.white },

    Field = { fg = M.base_30.cyan },
  },

  treesitter = {
    --- Literals
    ["@string"] = { link = "String" },
    ["@string.documentation"] = { link = "String" },
    ["@string.escape"] = { fg = M.base_30.purple }, -- For escape characters within a string.
    ["@string.regex"] = { fg = M.base_30.purple }, -- For regexes.
    --- Functions
    ["@constructor"] = { link = "Function" }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
    ["@parameter"] = { fg = M.base_30.white, italic = true }, -- For parameters of a function.
    ["@parameter.builtin"] = { link = "Builtin" }, -- For builtin parameters of a function, e.g. "..." or Smali's pG[1-99]
    --- Keywords
    ["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
    ["@keyword.conditional"] = { link = "Conditional" },
    ["@keyword.coroutine"] = { link = "Macro" }, -- For keywords related to coroutines.
    ["@keyword.debug"] = { link = "Debug" },
    ["@keyword.directive"] = { link = "PreProc" },
    ["@keyword.directive.define"] = { link = "Define" },
    ["@keyword.exception"] = { link = "Exception" },
    ["@keyword.export"] = { link = "Keyword" },
    ["@keyword.function"] = { link = "Keyword" }, -- For keywords used to define a function.
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.operator"] = { link = "Keyword" },
    ["@keyword.repeat"] = { link = "Repeat" },
    ["@keyword.return"] = { link = "Keyword" },
    ["@keyword.storage"] = { link = "StorageClass" },
    ["@label"] = { link = "Keyword" }, -- For labels: `label:` in C and `:label:` in Lua.
    --- Types
    ["@type.builtin"] = { link = "Type" },
    ["@field"] = { link = "Field" }, -- For fields.
    ["@property"] = { link = "Field" },
    --- Identifiers
    ["@variable"] = { link = "Variable" }, -- Any variable name that does not have another highlight.
    ["@variable.builtin"] = { link = "Builtin" }, -- Variable names that are defined by the languages, like `this` or `self`.
    ["@variable.member"] = { link = "Field" },
    --- Text
    -- ['@spell'] = { link = 'Comment' }, -- This seems to interfere with regular text
    -- ["@text.literal.markdown"] = { },
    ["@text"] = { link = "Normal" }, -- For strings considered text in a markup language.
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true }, -- For text to be represented with emphasis.
    ["@text.underline"] = { underline = true }, -- For text to be represented with an underline.
    ["@text.strike"] = { strikethrough = true }, -- For strikethrough text.
    ["@text.title"] = { link = "Title" }, -- Text that is part of a title.
    ["@text.uri"] = { underline = true }, -- Any URI like a link or email.
    ["@text.literal"] = { link = "String" },
    ["@text.literal.markdown_inline"] = { bg = M.base_30.darker_black, fg = M.base_30.white },
    ["@text.reference"] = { link = "Link" },
    ["@text.todo.unchecked"] = { fg = M.base_30.nord_blue }, -- For brackets and parens.
    ["@text.todo.checked"] = { fg = M.base_30.vibrant_green }, -- For brackets and parens.
    ["@text.warning"] = { fg = M.base_30.yellow },
    ["@text.danger"] = { fg = M.base_30.red },
    ["@text.diff.add"] = { link = "DiffAdd" },
    ["@text.diff.delete"] = { link = "DiffDelete" },
    ["@text.todo"] = { link = "Todo" },
    ["@text.note"] = { link = "Note" },
  },
}

-- set the theme type whether is dark or light
M.type = "dark" -- "or light"

-- this will be later used for users to override your theme table from chadrc
M = require("base46").override_theme(M, "nordic")

return M
