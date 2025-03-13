---@module "tokyonight"

return {
  "tokyonight.nvim",
  ---@class tokyonight.Config
  opts = {
    style = "storm",
    styles = {
      sidebars = "transparent",
      floats = "dark"
    },
    lualine_bold = true,
    on_highlights = function(hl, c)
      -- darker bg_float variants
      local bg_float1 = "#222436"
      local bg_float2 = "#1a1b26"
      local bg_float3 = "#16161e"

      -- blink.cmp
      hl.BlinkCmpSource = { fg = c.comment }
      hl.BlinkCmpDoc.bg = bg_float2
      hl.BlinkCmpDocBorder = { fg = c.comment, bg = hl.BlinkCmpDoc.bg }
      hl.BlinkCmpDocSeparator = hl.BlinkCmpDocBorder

      -- Snacks.picker
      hl.SnacksPicker = { fg = c.fg, bg = bg_float2 }
      hl.SnacksPickerTitle = { fg = bg_float2, bg = c.blue }
      hl.SnacksPickerBorder = { fg = bg_float2, bg = bg_float2 }
      hl.SnacksPickerPreviewVisual = { fg = c.fg, bg = c.red }

      hl.SnacksPickerInput = { fg = c.fg, bg = bg_float1 }
      hl.SnacksPickerInputTitle = { fg = bg_float1, bg = c.orange }
      hl.SnacksPickerInputBorder = { fg = bg_float1, bg = bg_float1 }

      hl.SnacksPickerPreview = { fg = c.fg, bg = bg_float3 }
      hl.SnacksPickerPreviewTitle = { fg = bg_float3, bg = c.magenta }
      hl.SnacksPickerPreviewBorder = { fg = bg_float3, bg = bg_float3 }

      hl.SnacksPickerBoxTitle = { fg = bg_float1, bg = c.orange }
      hl.SnacksPickerBoxBorder = { fg = bg_float1, bg = bg_float1 }
    end,
  },
}
