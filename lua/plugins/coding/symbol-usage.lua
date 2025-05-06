local SymbolKind = vim.lsp.protocol.SymbolKind

local function text_format(symbol)
  local fragments = {}

  -- Indicator that shows if there are any other symbols in the same line
  local stacked_functions = symbol.stacked_count > 0 and (" | +%s"):format(symbol.stacked_count) or ""

  if symbol.references then
    local usage = symbol.references <= 1 and "usage" or "usages"
    local num = symbol.references == 0 and "no" or symbol.references
    table.insert(fragments, ("%s %s"):format(num, usage))
  end

  if symbol.definition then
    table.insert(fragments, symbol.definition .. " defs")
  end

  if symbol.implementation then
    table.insert(fragments, symbol.implementation .. " impls")
  end

  return table.concat(fragments, ", ") .. stacked_functions
end

return {
  {
    "Wansmer/symbol-usage.nvim",
    enabled = false,
    event = "BufReadPre",
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      hl = { link = "DiagnosticVirtualLinesInfo" },
      --TODO: Define this per language I use
      kinds = {
        SymbolKind.Class,
        SymbolKind.Enum,
        SymbolKind.Function,
        SymbolKind.Interface,
        SymbolKind.Method,
        SymbolKind.Property,
        SymbolKind.Struct,
        SymbolKind.TypeParameter,
      },
      disable = { lsp = {}, filetypes = { "snacks_picker_input" }, cond = {} },
      vt_position = "end_of_line",
      text_format = text_format,
    },
  },
}
