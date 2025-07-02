---@module 'blink-cmp'
---@class blink.cmp.SourceConfig
return {
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
    lsp = { fallbacks = {} },
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
