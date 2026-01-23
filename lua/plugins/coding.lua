return {
  {
    "folke/ts-comments.nvim",
    opts = {
      svelte = { "<!-- %s -->", "/* %s */", "// %s" }
    },
    event = "VeryLazy"
  },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").config({
        providers = {
          'hover.providers.diagnostic',
          'hover.providers.lsp',
          'hover.providers.dictionary'
        },
        preview_opts = {
          border = "rounded"
        },
        title = true,
        preview_window = false,
      })
      vim.api.nvim_set_hl(0, "HoverActiveSource", { link = "TabLineSel" })
    end
  },
  {
    "MonsieurTib/neonuget",
    opts = {}
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "snacks_picker_input", "grug-far", "dashboard" },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false
  },
  { 
    "nmac427/guess-indent.nvim",
    opts = {}
  }
}
