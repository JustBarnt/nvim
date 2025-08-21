---@module 'blink.cmp'
---@class blink.cmp.CompletionConfigPartial
return {
  accept = {
    auto_brackets = { enabled = false },
  },
  documentation = {
    auto_show = false,
    auto_show_delay_ms = 200,
    window = { border = "rounded" },
  },
  menu = {
    scrollbar = false,
    border = "rounded",
    draw = {
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
  },
}
