return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v1.*",
  --build = "cargo build --release",
  ---@module "blink.cmp"
  ---@type blink.cmp.config
  opts = {
    fuzzy = { implementation = "prefer_rust" },
    keymap = { preset = "default" },
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
    completion = {
      accept = {
        auto_brackets = { enabled = false },
      },
      documentation = {
        auto_show = false,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
        treesitter_highlighting = true,
      },
      menu = {
        scrollbar = false,
        border = "rounded",
        draw = {
          treesitter = { "lsp" },
          padding = { 1, 1 },
          columns = { { "label" }, { "kind_icon" }, { "kind" } },
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get('lsp', ctx.kind)
                return hl
              end
            },
            kind = {
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            }
          }
        },
      },
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
      }
    },
    signature = {
      enabled = true,
      window = {
        show_documentation = false 
      },
    },
    sources = {
      -- add lazydev to your completion providers
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        buffer = {
          opts = {
            -- Retrieve buffer completion from only NORMAL buffer types
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ""
              end, vim.api.nvim_list_bufs())
            end
          }
        },
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end
          }
        }
      },
    }
  }
}
