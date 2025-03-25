return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v1.0.*",
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
    signature = {
      enabled = false,
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
          end,
        },
      },
    },
    cmdline = {
      enabled = true,
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
      },
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
            end,
          },
        },
      },
    },
  },
}
