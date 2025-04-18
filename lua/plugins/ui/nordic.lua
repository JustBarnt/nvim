return {
  "nordic.nvim",
  opts = {
    on_highlight = function(G, C)
      G.DiagnosticVirtualTextError = { bg = Helpers.ui.blend_bg(C.gray1, 0.1), fg = C.error, bold = true } -- Used for "Error" diagnostic virtual text
      G.DiagnosticVirtualTextWarn = { bg = Helpers.ui.blend_bg(C.gray1, 0.1), fg = C.warn } -- Used for "Warning" diagnostic virtual text
      G.DiagnosticVirtualTextWarning = { bg = Helpers.ui.blend_bg(C.gray1, 0.1), fg = C.warning } -- Used for "Warning" diagnostic virtual text
      G.DiagnosticVirtualTextInfo = { bg = Helpers.ui.blend_bg(C.gray1, 0.1), fg = C.info } -- Used for "Information" diagnostic virtual text
      G.DiagnosticVirtualTextHint = { bg = Helpers.ui.blend_bg(C.gray1, 0.1), fg = C.hint } -- Used for "Hint" diagnostic virtual text    end,
      G.LspInlayHint = { bg = Helpers.ui.blend_bg(C.blue0, 0.1), fg = C.bg_dark }
      G.DiagnosticText = {}
    end,
  },
  config = function(_, opts)
    require("nordic").setup(opts)
  end,
}
