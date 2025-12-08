return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set empty statusline until lualine loads
      vim.o.statusline = " "
    else
      -- Hide statusbar on starter page
      vim.o.laststatus = 0
    end
  end,
  config = function(_, opts)
    vim.o.laststatus = vim.g.lualine_laststatus
    require("lualine").setup(Config.plugins.lualine.opts)
  end
}
