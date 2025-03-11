-- h: lsp-config

-- enable lsp completion

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(ev)
		-- Attach generic LSP keymaps here
		require("config.keymaps.lsp").LspKeys(ev)
  end
})

vim.lsp.enable("lua_ls")
