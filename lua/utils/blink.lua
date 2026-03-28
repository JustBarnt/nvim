---@module "blink.cmp"

---@class utils.blink
local M = {}

---@type blink.cmp.AppearanceConfigPartial
M.appearance = {
  kind_icons = Utils.ui.icons.kinds.lsp
}

---@type blink.cmp.Fuzzy
M.fuzzy = { implementation = "prefer_rust" }

---@type blink.cmp.KeymapConfig
M.keymap_type = { preset = "default" }

---@type blink.cmp.CmdlineConfigPartial
M.cmdline = {
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
}

local run_once = false

---@type blink.cmp.CompletionConfigPartial
M.completion = {
  accept = {
    auto_brackets = { enabled = false },
  },
  documentation = {
    auto_show = false,
    auto_show_delay_ms = 200,
    treesitter_highlighting = true,
  },
  menu = {
    scrollbar = false,
    draw = {
      treesitter = { "lsp" },
      padding = { 1, 1 },
      columns = { { "kind_icon", gap = 1 }, { "label", "kind", gap = 1 }, { "source_name" } },
      components = {
        source_name = {
          width = { max = 30 },
          text = function(ctx)
            local s_name = ctx.source_name
            if ctx.item.client_name ~= nil then
              s_name = ctx.item.client_name
            end
            return s_name
          end,
          highlight = "BlinkCmpSource"
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
}

---@type blink.cmp.SignatureWindowConfigPartial
M.signature = {
  enabled = true,
  window = {
    show_documentation = false
  },
}

---@type blink.cmp.Sources
---@diagnostic disable: missing-fields
M.sources = {
  -- add lazydev to your completion providers
  default = { "lsp", "easy-dotnet", "path", "snippets", "buffer" },
  per_filetype = {
    lua = { inherit_defaults = true, "lazydev" },
  },
  providers = {
    ["easy-dotnet"] = {
      name = "easy-dotnet",
      enabled = true,
      module = "easy-dotnet.completion.blink",
      score_offset = 10000,
      async = true
    },
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

return M
