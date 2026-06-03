return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts_extended = { "lsps" },
    opts = {
      lsps = {
        ["clangd"] = "clangd",
        ["css-lsp"] = "cssls",
        ["cssmodules-language-server"] = "cssmodules_ls",
        ["emmet-language-server"] = "emmet_language_server",
        ["eslint-lsp"] = "eslint",
        ["gopls"] = "gopls",
        ["html-lsp"] = "html",
        ["intelephense"] = "intelephense",
        ["json-lsp"] = "jsonls",
        ["just-lsp"] = "just",
        ["kotlin-lsp"] = "kotlin-lsp",
        ["laravel_ls"] = "laravel_ls",
        ["lemminx"] = "lemminx",
        ["lua-language-server"] = "lua_ls",
        ["nushell"] = "nushell",
        ["neocmakelsp"] = "neocmakelsp",
        ["powershell-editor-services"] = "powershell_es",
        ["pyrefly"] = "pyrefly",
        ["roslyn"] = "roslyn_ls",
        ["ruff"] = "ruff",
        ["rust-analyzer"] = "rust_analyzer",
        ["svelte-language-server"] = "svelte",
        ["tailwindcss-language-server"] = "tailwindcss",
        ["taplo"] = "taplo",
        -- ["tsgo"] = "tsgo",
        ["vtsls"] = "vtsls",
        ["vim-language-server"] = "vimls",
        ["yaml-language-server"] = "yamlls",
      }
    },
    config = function(_, opts)
      Utils.lsp.init()
      -- Blanket apply capabilities to all LSP's
      vim.lsp.config("*", {
        capabilities = Utils.lsp.create_capabilities(),
      })

      for _, lsp in ipairs(vim.tbl_values(opts.lsps)) do
        ---@type vim.lsp.Config
        vim.lsp.enable(lsp)
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

          -- Disable LSP SemanticTokens from Powershell_es
          if client.name == "powershell_es" then
            client.server_capabilities.semanticTokensProvider = nil
            client.capabilities.textDocument.semanticTokens = nil
          end
        end,
      })
    end,
  },
}
