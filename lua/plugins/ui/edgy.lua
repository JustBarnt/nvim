local function edgy_toggle()
  return require("edgy").toggle()
end

local function edgy_select()
  return require("edgy").select()
end

return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>ue", edgy_toggle, desc = "Edgy Toggle" },
      { "<leader>uE", edgy_select, desc = "Edgy Select Window" }
    },
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = function()
      local opts = {
        bottom = {
          "Trouble",
          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end
          }
        },
        left = {
          {
            title = "File Explorer",
            ft = "snacks_picker_list",
            size = { width = 0.4 },
            filter = function(buf, win)
              return vim.bo[buf].buftype == "nofile"
                  and vim.bo[buf].filetype == "snacks_picker_list"
                  and vim.api.nvim_win_get_config(win).relative == ""
            end
          }
        },
        right = {
          { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } }
        },
        keys = {
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
          ["<c-Down>"] = function(win)
            win:resize("height", -2)
          end,
        }
      }

      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}

        -- Trouble
        table.insert(opts[pos], {
          ft = "trouble",
          filter = function(_buf, win)
            return vim.w[win].trouble
                and vim.w[win].trouble.position == pos
                and vim.w[win].trouble.type == "split"
                and vim.w[win].trouble.relative == "editor"
                and not vim.w[win].trouble_preview
          end
        })
        --
        -- Snacks terminal
        table.insert(opts[pos], {
          ft = "snacks_terminal",
          size = { height = 0.4 },
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_buf, win)
            return vim.w[win].snacks_win
                and vim.w[win].snacks_win.position == pos
                and vim.w[win].snacks_win.relative == "editor"
                and not vim.w[win].trouble_preview
          end,
        })
      end

      return opts
    end,
  }
}
