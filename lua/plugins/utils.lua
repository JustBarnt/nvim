---@module "snacks"

-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
	{
		"snacks.nvim",
		opts = {
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			terminal = {
				win = {
					keys = {
						nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
					},
				},
			},
		},
		keys = {
			{"<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer"},
			{"<leader>S.", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer"},
		}
	},
	{ "nvim-lua/plenary.nvim", lazy = true }
}
