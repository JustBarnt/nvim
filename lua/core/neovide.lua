---@param delta number
local change_neovide_scale = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

if Helpers.semantic_ver_has(vim.g.neovide_version, "0.15.0") then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Detected Neovide Version: " .. vim.g.neovide_version, "ErrorMsg" },
      { "Must be using Neovide ^0.15.0", "ErrorMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

local alpha = function()
  local transparency = vim.g.transparency or 0.8
  return string.format("%X", math.floor(255 * transparency))
end

-- GUI SETTINGS
vim.g.neovide_title_background_color =
  string.format("%x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg)

vim.g.neovide_title_text_color =
  string.format("%x", vim.api.nvim_get_hl(0, {name = "Normal"}).fg)

vim.g.neovide_window_blurred = true
vim.g.neovide_scale_factor = 1.0
vim.g.neovide_opacity = 0.8
vim.g.neovide_normal_opacity = 0.8
vim.g.experimental_layer_grouping = true
vim.g.neovide_cursor_vfx_mode = "railgun"

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
