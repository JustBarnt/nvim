---@type UserKeymaps[]
local keys = {
  { {"n"}, "<S-h>", "<CMD>BufferLineCyclePrev<CR>",  { desc = "Previous Buffer" } },
  { {"n"}, "<S-l>", "<CMD>BufferLineCycleNext<CR>",  { desc = "Next Buffer"     } },
}

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = Config.ui.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        filetype = "snacks_layout_box",
      },
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        return Config.ui.icons.ft[opts.filetype]
      end
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    Utils.keymaps.enable(keys)

    -- Fix Bufferline when restoring session
    -- https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/ui.lua#L53
    vim.api.nvim_create_autocmd({"BufAdd", "BufDelete"}, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end
    })
  end
}
