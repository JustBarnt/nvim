-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", lazyrepo, "--branch=stable", lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- adds all of our plugins into vims runtimepath
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ "folke/tokyonight.nvim", priority = 10000 },
		{
			"folke/snacks.nvim",
			version = "v2.22.0",
			priority = 10000,
			lazy = false,
			opts = {},
			config = function(_, opts)
				require("snacks").setup(opts)
			end
		},
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	},
	-- NOTE: Part of lazy.nvim. Include a .lazy.lua file in a project root directory, and those plugins will be merged
	--       into the plugin spec for that project only
	local_spec = true,
	install = { colorscheme = { "tokyonight", "slate" } },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})


-- vim.diagnostic.config = require("core.ui.icons").icons.diagnostics
vim.cmd[[colorscheme tokyonight-storm]]
