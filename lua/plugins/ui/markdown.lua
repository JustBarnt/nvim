return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    -- stylua: ignore
    keys = {
      { "<leader>cp", ft = "markdown", "<CMD>MarkdownPreviewToggle<CR>", desc = "Markdown Preview" },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      header = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enabled()
          else
            m.disabled()
          end
        end,
      }):map("<leader>um")
    end,
  },
}
