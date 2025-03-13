if vim.fn.has("nvim-0.11") ~= 1 then
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Must be using at least Neovim V0.11 or nightly to use:\n", "ErrorMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

---@diagnostic disable-next-line: undefined-global
if init_debug then
  local osvpath = vim.fn.stdpath("data") .. "/lazy/one-small-step-for-vimkind"
  vim.opt.rtp:append(osvpath)
  require("osv").launch({ port = 8086, blocking = true })
end

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")

require("module.lsp")
require("module.snippets")

require("module.extensions.string")
