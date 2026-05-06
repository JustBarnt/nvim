return {
  {
    -- "justbarnt/buffer-sticks.nvim",
    dir = "D:/Personal/Github/buffer-sticks.nvim/",
    event = "VeryLazy",
    opts = {
      show_by_default = true,
      show_indicators = true,
      border = "rounded",
      active_char = "",
      active_modified_char = "",
      inactive_char = "",
      inactive_modified_char = "",
      alternate_char = "",
      alternate_modified_char = "",
      label = { show = "always" },
      list = {
        show = { "filename", "space", "label" },
        active_indicator = "",
        keys = {
          close_buffer = "<C-q>",
          move_up = "<C-p>",
          move_down = "<C-n>",
        },
        filter = {
          active_indicator = "",
          keys = {
            move_up = "<C-p>",
            move_down = "<C-n>",
          },
        }
      },
      preview = {
        float = {
          title = false,
          border = "rounded",
          footer = "filename"
        }
      },
      highlights = {
        active = { link = "Keyword" },
        alternate = { link = "StorageClass" },
        inactive = { link = "Whitespace" },
        active_modified = { link = "Constant" },
        alternate_modified = { link = "Constant" },
        inactive_modified = { link = "Constant" },
        label = { link = "Comment" },
        filter_selected = { link = "Keyword" },
        filter_title = { link = "Comment" },
        list_selected = { link = "Keyword" },
      }
    },
    keys = {
      {
        "<leader>b",
        function()
          BufferSticks.list()
        end,
        desc = "Show Buffers"
      },
    },
  }
}
