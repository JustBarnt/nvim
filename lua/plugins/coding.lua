return {
  {
    "lewis6991/hover.nvim",
    opts = {
      providers = {
        'hover.providers.diagnostic',
        'hover.providers.lsp',
        'hover.providers.dictionary',
        'tailwind-hover.providers.hover'
      },
      preview_opts = {
        border = "rounded"
      },
    },
  },
  {
    "ruicsh/tailwind-hover.nvim",
    opts = {},
    config = function(_, opts)
      require('tailwind-hover').setup(opts)
    end
  }
}
