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
    -- Macro = { fg = M.base_30.red },
    -- Builtin = { fg = M.base_30.blue },
    -- Field = { fg = M.base_30.cyan },
  },

  syntax = {
    Bold = { bold = true },
    Boolean = { link = "Number" },
    Builtin = { fg = M.base_30.blue },
    Character = { bg = M.base_30.green },
    CodeBlock = { bg = M.base_30.black2, fg = M.base_30.white },
    Comment = { fg = M.base_30.light_grey, italic = true },
    Conditional = { link = "Keyword" },
    Constant = { fg = M.base_30.baby_pink },
    Define = { link = "Macro" },
    Delimeter = { italic = true, fg = M.base_30.light_grey },
    Error = { fg = M.base_30.red }, -- (preferred) any erroneous construct
    Exception = { link = "Macro" }, --  try, catch, throw
    Field = { fg = M.base_30.cyan },
    Float = { link = "Number" },
    Function = { fg = M.base_30.nord_blue },
    Identifier = { fg = M.base_30.white },
    Ignore = { fg = M.base_30.grey_fg2 }, -- (preferred) left blank, hidden  |hl-Ignore|
    Include = { link = "Macro" },
    Italic = { italic = true },
    Keyword = { fg = M.base_30.orage, bold = true },
    Label = { link = "Keyword" },
    Macro = { fg = M.base_30.red }, -- same as Define
    Namespace = { fg = M.base_30.yellow },
    None = { bg = "None", fg = "None" },
    Note = { fg = M.base_30.black, bg = M.base_30.nord_blue },
    Number = { link = "Constant" },
    Operator = { fg = M.base_30.white },
    PreCondit = { link = "Macro" }, --  preprocessor #if, #else, #endif, etc.
    PreProc = { link = "Macro" },
    Repeat = { link = "Keyword" },
    Special = { fg = M.base_30.nord_blue },
    SpecialChar = { fg = M.base_30.red },
    Statement = { link = "Keyword" },
    StorageClass = { link = "Keyword" },
    String = { fg = M.base_30.green },
    Structure = { link = "Type" },
    Tag = { link = "Type" },
    Title = { fg = M.base_30.yellow },
    Todo = { bg = M.base_30.yellow, fg = M.base_30.darker_black },
    Type = { fg = M.base_30.yellow },
    Typedef = { link = "Type" },
    Underlined = { underline = true }, -- (preferred) text that stands out, HTML links
    Variable = { fg = M.base_30.white },
  },

  treesitter = {
    --- Literals
    ["@string"] = { link = "String" },
    ["@string.documentation"] = { link = "String" },
    ["@string.escape"] = { fg = M.base_30.baby_pink }, -- For escape characters within a string.
    ["@string.regex"] = { fg = M.base_30.baby_pink }, -- For regexes.
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
    --LSP Semantic Token roups
    ["@lsp.type.boolean"] = { link = "Boolean" },
    ["@lsp.type.builtinType"] = { link = "Type" },
    ["@lsp.type.comment"] = { link = "Comment" },
    ["@lsp.type.enum"] = { link = "Type" },
    ["@lsp.type.enumMember"] = { link = "Field" },
    ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
    ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
    ["@lsp.type.interface"] = { link = "Keyword" },
    ["@lsp.type.keyword"] = { link = "Keyword" },
    ["@lsp.type.namespace"] = { link = "Namespace" },
    ["@lsp.type.number"] = { link = "Number" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.selfKeyword"] = { link = "Builtin" },
    ["@lsp.type.string.rust"] = { link = "String" },
    ["@lsp.type.typeAlias"] = { link = "Type" },
    ["@lsp.type.unresolvedReference"] = { undercurl = true, sp = M.base_30.red },
    ["@lsp.type.variable"] = {}, -- use treesitter styles for regular variables
    ["@lsp.typemod.class.defaultLibrary"] = { link = "Type" },
    ["@lsp.typemod.enum.defaultLibrary"] = { link = "Type" },
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "Constant" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "Function" },
    ["@lsp.typemod.keyword.async"] = { link = "Macro" },
    ["@lsp.typemod.macro.defaultLibrary"] = { link = "Macro" },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "Function" },
    ["@lsp.typemod.operator.injected"] = { link = "Operator" },
    ["@lsp.typemod.string.injected"] = { link = "String" },
    ["@lsp.typemod.type.defaultLibrary"] = { link = "Type" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "Builtin" },
    ["@lsp.typemod.variable.injected"] = { link = "Variable" },
    ["@lsp.typemod.variable.globalScope"] = { link = "Macro" },
    -- Thins that seems to be missing?
    ["@annotation"] = { link = "PreProc" },
    ["@diff.plus"] = { link = "DiffAdd" },
    ["@diff.minus"] = { link = "DiffDelete" },
    ["@diff.delta"] = { link = "DiffChange" },
    ["@character"] = { link = "Character" },
    ["@character.special"] = { link = "SpecialChar" },
    ["@string.special"] = { fg = M.base_30.yellow }, -- For escape characters within a string.
    ["@tag"] = { fg = M.base_30.nord_blue }, -- Tags like html tag names.
    ["@tag.delimiter"] = { fg = M.base_30.white }, -- Tag delimiter like `<` `>` `/`
    ["@tag.attribute"] = { fg = M.base_30.yellow }, -- Tag attribute like `id` `class`
    ["@constant"] = { link = "Constant" },
    ["@number"] = { link = "Constant" },
    ["@float"] = { link = "Constant" },
    ["@boolean"] = { link = "Constant" },
    ["@constant.macro"] = { link = "Constant" },
    ["@constant.builtin"] = { link = "Constant" },
    ["@repeat"] = { link = "Keyword" },
    ["@conditional"] = { link = "Keyword" },
    ["@class"] = { link = "Keyword" },
    ["@include"] = { link = "Include" },
    ["@macro"] = { link = "Macro" },
    ["@module"] = { fg = M.base_30.yellow },
    ["@module.builtin"] = { link = "Builtin" },
    ["@preproc"] = { link = "Macro" },
    ["@attribute"] = { link = "Macro" },
    ["@function.macro"] = { link = "Macro" },
    ["@define"] = { link = "Macro" },
    ["@exception"] = { link = "Macro" },
    ["@function"] = { link = "Function" },
    ["@method"] = { link = "Function" },
    ["@method.call"] = { link = "Function" },
    ["@function.call"] = { link = "Function" },
    ["@function.builtin"] = { link = "Function" },
    ["@property.cpp"] = { fg = M.base_30.cyan },
    ["@namespace"] = { fg = M.base_30.sun },
    ["@type"] = { link = "Type" },
    ["@type.definition"] = { link = "Type" },
    ["@type.qualifier"] = { link = "Keyword" },
    ["@storageclass"] = { link = "Keyword" },
    ["@none"] = { link = "None" },
  },
}

-- set the theme type whether is dark or light
M.type = "dark" -- "or light"

-- this will be later used for users to override your theme table from chadrc
M = require("base46").override_theme(M, "nordic")

return M
