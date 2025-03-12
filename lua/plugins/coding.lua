return {
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "*",
		build = "cargo build --release",
		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			fuzzy = {
				implementation = "prefer_rust",
			},
			keymap = {
				preset = "default",
			},
			completion = {
				ghost_text = { enabled = false },
				list = {
					selection = {
						auto_insert = function(ctx)
							return ctx.mode ~= "cmdline"
						end,
						preselect = function(ctx)
							return ctx.mode ~= "cmdline"
						end
					},
				},
			},
			cmdline = {
				enabled = true,
				keymap = {
					["<CR>"] = { "accept_and_enter", "fallback" }
				},
				---@diagnostic disable-next-line: assign-type-mismatch
				sources = function()
					local type = vim.fn.getcmdtype()
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					if type == ":" or type == "@" then
						return { "cmdline", "path" }
					end
					return {}
				end,
				completion = {
					menu = { auto_show = true },
					ghost_text = { enabled = false },
				}
			},
			sources = {
				-- add lazydev to your completion providers
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					path = {
						score_offset = 2,
						opts = {
							get_cwd = function(_)
								return vim.uv.cwd()
							end
						}
					}
				},
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } }
			},
			integrations = {
				lspconfig = false,
			}
		},
	}
}
