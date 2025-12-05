local find_replace_current_word = function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") }})
end

local find_replace_astgrep = function()
  require("grug-far").open({ engine = 'astgrep' })
end

local find_replace = function()
  require("grug-far").open({ transient = true })
end

local find_replace_current_buffer = function()
  require("grug-far").open({ prefills = { path = vim.fn.expand("%") }})
end

---@type UserKeymaps[]
return {
  { {"n"}, "<leader>frw", find_replace_current_word  , { desc = "Find and Replace <CWORD>"      } },
  { {"n"}, "<leader>fra", find_replace_astgrep       , { desc = "Find and Replace with AstGrep" } },
  { {"n"}, "<leader>fr",  find_replace               , { desc = "Find and Replace"              } },
  { {"n"}, "<leader>frb", find_replace_current_buffer, { desc = "Find and Replace in Buffer"    } },
}
