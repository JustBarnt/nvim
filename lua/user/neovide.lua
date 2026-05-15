---@param delta number
local change_neovide_scale = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.g.neovide_window_blurred = true
vim.g.neovide_scale_factor = 1.0
vim.g.neovide_normal_opacity = 0.5
vim.g.experimental_layer_grouping = true
vim.g.neovide_cursor_vfx_mode = "railgun"

vim.g.neovide_title_background_color = string.format(
  "%x",
  vim.api.nvim_get_hl(0, { name = "Normal" }).fg
)

-- KEYS MAPS

vim.keymap.set("n", "<C-=>", function()
  vim.g.neovide_scale_factor = 1.0
end)

vim.keymap.set("n", "<C-+>", function()
  change_neovide_scale(1.25)
end)

vim.keymap.set("n", "<C-->", function()
  change_neovide_scale(1 / 1.25)
end)
