-- this line for types, by hovering and autocompletion (lsp required)
-- will help you understanding properties, fields, and what highlightings the color used for
---@class Base46Table
local M = {}
-- UI
M.base_30 = {
  white = "#C0C8D8",
  black = "#242933", -- usually your theme bg
  darker_black = "#15181E", -- 6% darker than black
  black2 = "#2F3442", -- 6% lighter than black
  one_bg = "#373E4E", -- 10% lighter than black
  one_bg2 = "#40485A", -- 6% lighter than one_bg2
  one_bg3 = "#4C566A", -- 6% lighter than one_bg3
  grey = "#4C566A", -- 40% lighter than black (the % here depends so choose the perfect grey!)
  grey_fg = "#959FB3", -- 10% lighter than grey
  grey_fg2 = "#8691A9", -- 5% lighter than grey
  light_grey = "#60728A",
  red = "#BF616A",
  baby_pink = "#BE9DB8",
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
  base00 = M.base_30.black,
  base01 = M.base_30.black2,
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
  -- stylua: ignore start
  defaults = {
    ['@lsp.type.variable.global']               = { link = "@namespace" },
    ['@lsp.mod.global']                         = { link = "@namespace" },

    -- LSP Typemod Highlights
    ['@lsp.typemod.class.defaultLibrary']       = { link = 'Type' },
    ['@lsp.typemod.enum.defaultLibrary']        = { link = 'Type' },
    ['@lsp.typemod.enumMember.defaultLibrary']  = { link = 'Constant' },
    ['@lsp.typemod.function.defaultLibrary']    = { link = 'Function' },
    ['@lsp.typemod.keyword.async']              = { link = 'Macro' },
    ['@lsp.typemod.macro.defaultLibrary']       = { link = 'Macro' },
    ['@lsp.typemod.method.defaultLibrary']      = { link = 'Function' },
    ['@lsp.typemod.operator.injected']          = { link = 'Operator' },
    ['@lsp.typemod.string.injected']            = { link = 'String' },
    ['@lsp.typemod.type.defaultLibrary']        = { link = 'Type' },
    ['@lsp.typemod.variable.defaultLibrary']    = { link = 'Builtin' },
    ['@lsp.typemod.variable.globalScope']       = { link = 'Macro' },
    ['@lsp.typemod.variable.injected']          = { link = 'Variable' },

    -- Basic / UI groups
    NormalFloat                             = { fg = M.base_30.white, bg = M.base_30.black },

    -- Text‐style groups
    Underlined                              = { underline = true },
    Bold                                    = { bold = true },
    Italic                                  = { italic = true },

    -- Markdown / markup helpers
    CodeBlock                               = { fg = M.base_30.white, bg = M.base_30.black },
    Link                                    = { fg = M.base_30.blue, underline = true },
    htmlH1                                  = { fg = M.base_30.yellow, bold = true },
    htmlH2                                  = { fg = M.base_30.orange },
    mkdHeading                              = { link = 'htmlH1' },
    mkdCode                                 = { link = 'CodeBlock' },
    mkdCodeDelimiter                        = { link = 'CodeBlock' },
    mkdCodeStart                            = { fg = M.base_30.cyan, bold = true },
    mkdCodeEnd                              = { fg = M.base_30.cyan, bold = true },
    mkdLink                                 = { link = 'Link' },
    markdownHeadingDelimiter                = { link = 'mkdHeading' },
    markdownCode                            = { link = 'CodeBlock' },
    markdownCodeBlock                       = { link = 'CodeBlock' },
    markdownH1                              = { link = 'htmlH1' },
    markdownH2                              = { link = 'htmlH2' },
    markdownLinkText                        = { link = 'Link' },

    -- Special / misc
    Special                                 = { fg = M.base_30.blue },
    Namespace                               = { fg = M.base_30.sun },

    -- Diagnostics & LSP
    Error                                  = { fg = M.base_30.red },
    Todo                                   = { fg = M.base_30.black, bg = M.base_30.sun },
    Note                                   = { fg = M.base_30.black, bg = M.base_30.cyan },
    debugPC                                = { bg = M.base_30.darker_black },
    debugBreakpoint                        = { fg = M.base_30.pink },
    LspReferenceText                       = { bg = M.base_30.white },
    LspReferenceRead                       = { bg = M.base_30.white },
    LspReferenceWrite                      = { bg = M.base_30.white },
    DiagnosticError                        = { fg = M.base_30.red },
    DiagnosticWarn                         = { fg = M.base_30.yellow },
    DiagnosticInfo                         = { fg = M.base_30.cyan },
    DiagnosticHint                         = { fg = M.base_30.vibrant_green },
    DiagnosticVirtualTextError             = { fg = M.base_30.red, bg = M.base_30.grey, bold = true },
    DiagnosticVirtualTextWarn              = { fg = M.base_30.yellow, bg = M.base_30.grey },
    DiagnosticVirtualTextWarning           = { fg = M.base_30.yellow, bg = M.base_30.grey },
    DiagnosticVirtualTextInfo              = { fg = M.base_30.cyan, bg = M.base_30.grey },
    DiagnosticUnderlineError               = { undercurl = true, sp = M.base_30.red },
    DiagnosticUnderlineWarn                = { undercurl = true, sp = M.base_30.yellow },
    DiagnosticUnderlineInfo                = { undercurl = true, sp = M.base_30.cyan },
    DiagnosticUnderlineHint                = { undercurl = true, sp = M.base_30.vibrant_green },
    DiagnosticText                         = { bg = M.base_30.black_float },
    LspSignatureActiveParameter            = { underline = true, bold = true, bg = M.base_30.black_float },
    LspCodeLens                            = { link = "Comment" },
    LspInfoBorder                          = { link = 'FloatBorder' },
    ALEErrorSign                           = { fg = M.base_30.red },
    ALEWarningSign                         = { fg = M.base_30.yellow },

    -- Spell‐checking
    SpellBad                               = { undercurl = true, sp = M.base_30.red },
    SpellCap                               = { undercurl = true, sp = M.base_30.yellow },
    SpellLocal                             = { undercurl = true, sp = M.base_30.cyan },
    SpellRare                              = { undercurl = true, sp = M.base_30.vibrant_green },
  },
  --stylua: ignore end

  syntax = {
    -- Function-like
    Function = { fg = M.base_30.seablue },

    -- Keyword-like
    Keyword = { fg = M.base_30.orange, bold = true },
    Statement = { link = "Keyword" },
    Conditional = { link = "Keyword" },
    Repeat = { link = "Keyword" },
    Label = { link = "Keyword" },
    StorageClass = { link = "Keyword" },

    -- Type-like
    Type = { fg = M.base_30.sun },
    Structure = { link = "Type" },
    Typedef = { link = "Type" },

    -- Constant-like
    Constant = { fg = M.base_30.baby_pink },
    Number = { link = "Constant" },
    Float = { link = "Constant" },
    Boolean = { link = "Constant" },

    -- String-like
    String = { fg = M.base_30.green },
    Character = { link = "String" },

    -- Variable-like
    Variable = { fg = M.base_30.white },
    Identifier = { link = "Variable" },

    -- Builtin-like
    Builtin = { fg = M.base_30.blue },

    -- Field/Property-like
    Field = { fg = M.base_30.cyan },

    -- Operator-like
    Operator = { fg = M.base_30.white },

    -- Delimiter/Punctuation
    Delimiter = { italic = true, fg = M.base_30.grey_fg2 },

    -- Comment-like
    Comment = { fg = M.base_30.one_bg3 },

    -- Macro/Preprocessor-like
    Macro = { fg = M.base_30.red },
    Exception = { link = "Macro" },
    PreProc = { link = "Macro" },
    Include = { link = "Macro" },
    Define = { link = "Macro" },
    PreCondit = { link = "Macro" },
  },

  -- stylua: ignore start
  treesitter = {
    -- Comments
    ['@comment']                                = { link = 'Comment' },
    ['@comment.documentation']                  = { link = 'Comment' },
    ['@comment.error']                          = { fg   = M.base_30.red },
    ['@comment.hint']                           = { fg   = M.base_30.vibrant_green },
    ['@comment.info']                           = { fg   = M.base_30.cyan },
    ['@comment.note']                           = { fg   = M.base_30.vibrant_green },
    ['@comment.todo']                           = { fg   = M.base_30.nord_blue },
    ['@comment.warning']                        = { fg   = M.base_30.yellow },

    -- Operators
    ['@operator']                               = { link = 'Operator' },

    -- Punctuation
    ['@punctuation.bracket']                    = { link = '@operator' },
    ['@punctuation.delimiter']                  = { link = 'Delimiter' },
    ['@punctuation.special']                    = { link = 'Macro' },
    ['@punctuation.special.markdown']           = { fg   = M.base_30.orange, bold = true },

    -- Literals (Strings)
    ['@string']                                 = { link = 'String' },
    ['@string.documentation']                   = { link = 'String' },
    ['@string.escape']                          = { fg   = M.base_30.baby_pink },
    ['@string.regex']                           = { fg   = M.base_30.baby_pink },
    ['@string.special']                         = { fg   = M.base_30.yellow },

    -- Numbers & Constants
    ['@boolean']                                = { link = 'Constant' },
    ['@constant']                               = { link = 'Constant' },
    ['@constant.builtin']                       = { link = 'Constant' },
    ['@constant.macro']                         = { link = 'Constant' },
    ['@diff.delta']                             = { link = 'DiffChange' },
    ['@diff.minus']                             = { link = 'DiffDelete' },
    ['@diff.plus']                              = { link = 'DiffAdd' },
    ['@float']                                  = { link = 'Constant' },
    ['@number']                                 = { link = 'Constant' },

    -- Functions & Methods
    ['@constructor']                            = { link = 'Function' },
    ['@function']                               = { link = 'Function' },
    ['@function.builtin']                       = { link = 'Function' },
    ['@function.call']                          = { link = 'Function' },
    ['@function.macro']                         = { link = 'Macro' },
    ['@method']                                 = { link = 'Function' },
    ['@method.call']                            = { link = 'Function' },

    -- Parameters
    ['@parameter']                              = { fg   = M.base_30.white,      italic = true },
    ['@parameter.builtin']                      = { link = 'Builtin' },

    -- Keywords
    ['@conditional']                            = { link = 'Keyword' },
    ['@class']                                  = { link = 'Keyword' },
    ['@include']                                = { link = 'Include' },
    ['@keyword']                                = { link = 'Keyword' },
    ['@keyword.conditional']                    = { link = 'Conditional' },
    ['@keyword.coroutine']                      = { link = 'Macro' },
    ['@keyword.debug']                          = { link = 'Debug' },
    ['@keyword.directive']                      = { link = 'PreProc' },
    ['@keyword.directive.define']               = { link = 'Define' },
    ['@keyword.exception']                      = { link = 'Exception' },
    ['@keyword.export']                         = { link = 'Keyword' },
    ['@keyword.function']                       = { link = 'Keyword' },
    ['@keyword.import']                         = { link = 'Include' },
    ['@keyword.operator']                       = { link = 'Keyword' },
    ['@keyword.repeat']                         = { link = 'Repeat' },
    ['@keyword.return']                         = { link = 'Keyword' },
    ['@keyword.storage']                        = { link = 'StorageClass' },
    ['@label']                                  = { link = 'Keyword' },
    ['@macro']                                  = { link = 'Macro' },
    ['@preproc']                                = { link = 'Macro' },
    ['@repeat']                                 = { link = 'Keyword' },
    ['@storageclass']                           = { link = 'Keyword' },

    -- Types & Fields & Properties
    ['@field']                                  = { link = 'Field' },
    ['@property']                               = { link = 'Field' },
    ['@property.cpp']                           = { fg   = M.base_30.cyan },
    ['@type.builtin']                           = { link = 'Type' },
    ['@type.definition']                        = { link = 'Type' },
    ['@type.qualifier']                         = { link = 'Keyword' },
    ['@type']                                   = { link = 'Type' },

    -- Identifiers & Namespaces & Modules
    ['@annotation']                             = { link = 'PreProc' },
    ['@attribute']                              = { link = 'Macro' },
    ['@character']                              = { link = 'Character' },
    ['@character.special']                      = { link = 'SpecialChar' },
    ['@module']                                 = { fg   = M.base_30.yellow },
    ['@module.builtin']                         = { link = 'Builtin' },
    ['@variable']                               = { fg = M.base_30.white },
    ['@variable.builtin']                       = { link = 'Builtin' },
    ['@variable.member']                        = { link = 'Field' },
    ['@namespace']                              = { fg = M.base_30.sun },
    ['@namespace.builtin']                      = { link = "@namespace" },

    -- Text
    ['@text']                                   = { link = 'Normal' },
    ['@text.danger']                            = { fg   = M.base_30.red },
    ['@text.diff.add']                          = { link = 'DiffAdd' },
    ['@text.diff.delete']                       = { link = 'DiffDelete' },
    ['@text.emphasis']                          = { italic = true },
    ['@text.literal']                           = { link = 'String' },
    ['@text.literal.markdown']                  = { link = 'Normal' },
    ['@text.literal.markdown_inline']           = { bg = M.base_30.black2, fg = M.base_30.white },
    ['@text.note']                              = { link = 'Note' },
    ['@text.reference']                         = { link = 'Link' },
    ['@text.strong']                            = { bold = true },
    ['@text.strike']                            = { strikethrough = true },
    ['@text.todo']                              = { link = 'Todo' },
    ['@text.todo.checked']                      = { fg = M.base_30.vibrant_green },
    ['@text.todo.unchecked']                    = { fg = M.base_30.blue },
    ['@text.title']                             = { link = 'Title' },
    ['@text.underline']                         = { underline = true },
    ['@text.uri']                               = { underline = true },
    ['@text.warning']                           = { fg = M.base_30.yellow },

    -- Markup
    ['@markup']                                 = { link = '@none' },
    ['@markup.emphasis']                        = { italic = true },
    ['@markup.environment']                     = { link = 'Macro' },
    ['@markup.environment.name']                = { link = 'Type' },
    ['@markup.heading']                         = { link = 'Title' },
    ['@markup.heading.1']                       = { fg = M.base_30.yellow, bold = true },
    ['@markup.heading.2']                       = { fg = M.base_30.orange, bold = true },
    ['@markup.heading.3']                       = { fg = M.base_30.baby_pink, bold = true },
    ['@markup.heading.4']                       = { fg = M.base_30.green },
    ['@markup.heading.5']                       = { fg = M.base_30.nord_blue, italic = true },
    ['@markup.heading.6']                       = { fg = M.base_30.cyan, italic = true },
    ['@markup.italic']                          = { italic = true },
    ['@markup.list']                            = { link = '@operator' },
    ['@markup.list.checked']                    = { link = 'Field' },
    ['@markup.list.markdown']                   = { fg = M.base_30.yellow, bold = true },
    ['@markup.list.unchecked']                  = { fg = M.base_30.white },
    ['@markup.link']                            = { fg = M.base_30.cyan },
    ['@markup.link.label']                      = { link = 'SpecialChar' },
    ['@markup.link.label.symbol']               = { link = 'Identifier' },
    ['@markup.link.url']                        = { link = 'Underlined' },
    ['@markup.math']                            = { link = 'Special' },
    ['@markup.raw']                             = { link = 'String' },
    ['@markup.raw.markdown_inline']             = { bg = M.base_30.black2, fg = M.base_30.white },
    ['@markup.strong']                          = { bold = true },
    ['@markup.strikethrough']                   = { strikethrough = true },
    ['@markup.underline']                       = { underline = true },

    -- TSX
    ['@constructor.tsx']                        = { fg = M.base_30.blue },
    ['@tag.delimiter.tsx']                      = { fg = M.base_30.blue },
    ['@tag.tsx']                                = { fg = M.base_30.blue } ,
  },
  -- stylua: ignore end

  -- stylua: ignore start
  semantic_tokens = {
    -- LSP Semantic Token Highlights
    ['@lsp.type.boolean']                       = { link = 'Boolean' },
    ['@lsp.type.builtinType']                   = { link = 'Type' },
    ['@lsp.type.comment']                       = { link = 'Comment' },
    ['@lsp.type.enum']                          = { link = 'Type' },
    ['@lsp.type.enumMember']                    = { link = 'Field' },
    ['@lsp.type.escapeSequence']                = { link = '@string.escape' },
    ['@lsp.type.formatSpecifier']               = { link = '@punctuation.special' },
    ['@lsp.type.interface']                     = { link = 'Keyword' },
    ['@lsp.type.keyword']                       = { link = 'Keyword' },
    ['@lsp.type.namespace']                     = { link = '@namespace' },
    ['@lsp.type.number']                        = { link = 'Number' },
    ['@lsp.type.operator']                      = { link = '@operator' },
    ['@lsp.type.parameter']                     = { link = '@parameter' },
    ['@lsp.type.property']                      = { link = '@property' },
    ['@lsp.type.selfKeyword']                   = { link = 'Builtin' },
    ['@lsp.type.string.rust']                   = { link = 'String' },
    ['@lsp.type.typeAlias']                     = { link = 'Type' },
    ['@lsp.type.unresolvedReference']           = { undercurl = true, sp = M.base_30.red },
    ['@lsp.type.variable']                      = { link = "@variable" },
  },
  -- stylua: ignore end
}

-- set the theme type whether is dark or light
M.type = "dark" -- "or light"

-- this will be later used for users to override your theme table from chadrc
M = require("base46").override_theme(M, "nordic")

return M
