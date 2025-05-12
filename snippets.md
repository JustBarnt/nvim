Make harpoon window show in a different position
```lua
vim.keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
  local winids = vim.api.nvim_list_wins()
  local harpoon_win = vim.iter(winids):find(function(winid)
    local buf = vim.api.nvim_win_get_buf(winid)
    return vim.bo[buf].filetype == "harpoon"
  end)
  if not harpoon_win then
    return
  end
  vim.api.nvim_win_set_config(harpoon_win, {
    anchor = "NW",
    col = 0,
    row = 0,
    relative = "editor",
  })

end)
```
