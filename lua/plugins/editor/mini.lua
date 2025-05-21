return {
  "echasnovski/mini.nvim",
  opts = function()
    local ai = require "mini.ai"
    return {
      ai = {
        n_lines = 50,
        custom_textobjects = {
          o = ai.gen_spec.treesitter {
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = Helpers.mini.ai_buffer,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" },
        },
      },
      move = { mappings = { left = "H", down = "J", right = "L", up = "K" } },
      surround = { n_lines = 500 },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup { opts.ai }
    require("mini.surround").setup { opts.surround }
    require("mini.move").setup { opts.move }
    require("mini.operators").setup()
    require("mini.splitjoin").setup()

    Helpers.on_load("which-key.nvim", function()
      vim.schedule(function()
        Helpers.mini.ai_whichkey(opts)
      end)
    end)
  end,
}
