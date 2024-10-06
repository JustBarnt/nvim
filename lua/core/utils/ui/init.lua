local M = {}

M.icons = {
    misc = {
        dots = "󰇘",
    },
    ft = {
        octo = "",
    },
    dap = {
        Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint          = " ",
        BreakpointCondition = " ",
        BreakpointRejected  = { " ", "DiagnosticError" },
        LogPoint            = ".>",
    },
    diagnostics = {
        Error = " ",
        Warn  = " ",
        Hint  = " ",
        Info  = " ",
    },
    git = {
        added    = " ",
        modified = " ",
        removed  = " ",
    },
    kinds = {
        Text = '  ',
        Method = '  ',
        Function = '  ',
        Constructor = '  ',
        Field = '  ',
        Variable = '  ',
        Class = '  ',
        Interface = '  ',
        Module = '  ',
        Property = '  ',
        Unit = '  ',
        Value = '  ',
        Enum = '  ',
        Keyword = '  ',
        Snippet = '  ',
        Color = '  ',
        File = '  ',
        Reference = '  ',
        Folder = '  ',
        EnumMember = '  ',
        Constant = '  ',
        Struct = '  ',
        Event = '  ',
        Operator = '  ',
        TypeParameter = '  ',
        Array = ' ',
        Boolean = '󰨙 ',
        Codeium = '󰘦 ',
        Control = ' ',
        Collapsed = ' ',
        Copilot = ' ',
        Key = ' ',
        Namespace = '󰦮 ',
        Null = ' ',
        Number = '󰎠 ',
        Object = ' ',
        Package = ' ',
        String = ' ',
        TabNine = '󰏚 ',
    }
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

return M
