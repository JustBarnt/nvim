local is_transparent = vim.fn.getenv "TERM" == "xterm-ghostty" or vim.fn.getenv "TERM_PROGRAM" == "WezTerm"
local subtle_color = "#8c98b3"

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = is_transparent,
    on_colors = function(colors)
      colors.comment = subtle_color
    end,
    on_highlights = function(hl, colors)
      hl.LineNr = { fg = subtle_color }
      hl.LineNrAbove = { fg = subtle_color }
      hl.LineNrBelow = { fg = subtle_color }

      hl.Visual = { bg = "#445b9b" }
    end,
    styles = {
      sidebars = is_transparent and "transparent" or "dark",
      floats = is_transparent and "transparent" or "dark",
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)

    -- vim.cmd.colorscheme "tokyonight-night"
  end
}
