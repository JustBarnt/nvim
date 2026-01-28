return {
  "lewis6991/hover.nvim",
  config = function()
    require("hover").config({
      providers = {
        'hover.providers.lsp',
        'hover.providers.diagnostic',
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
}
