return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Blanket apply capabilities to all LSP's
      vim.lsp.config("*", {
        capabilities = Utils.lsp.create_capabilities(),
      })

      for _, v in ipairs(vim.api.nvim_get_runtime_file("after/lsp/*", true)) do
        local name = vim.fn.fnamemodify(v, ":t:r")
        vim.lsp.enable(name)
      end

      local completion_kinds = vim.lsp.protocol.CompletionItemKind
      local icons = Utils.ui.icons.kinds
      for i, kind in ipairs(completion_kinds) do
        completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("barnt/lsp_attach", { clear = true }),
        callback = function(ev)
          local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

          -- Remove default keybinds
          for _, bind in ipairs { "grn", "gra", "gri", "grr", "grt", "K" } do
            pcall(Snacks.keymap.del, "n", bind, { buffer = ev.buf })
          end

          -- Setup our server capabilities
          Utils.lsp.setup_server_capabilities(client, ev.buf)
          Utils.lsp.keymaps(ev)
        end,
      })

      -- TODO: Renable this- it has moved to Utils.lsp.progress()
      Utils.lsp.progress()
    end,
  },
}
