local function getNeotreeWidth()
  for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].ft == "neo-tree" then
      return vim.api.nvim_win_get_width(win)
    end
  end
  return 0
end

---@class ChadrcConfig
local ChadUI = {
  base46 = {
    theme = "nordic",
    transparency = false,
    hl_override = {
      NormalFloat = { link = "CodeBlock" },
    },
    hl_add = {
      -- Snacks Picker Global Highlights
      SnacksPicker = { bg = "black2" },
      SnacksPickerBorder = { bg = "black", fg = "black" },
      SnacksPickerTitle = { bg = "black", fg = "orange" },

      -- SnacksPicker Preview
      SnacksPickerPreview = { bg = "black" },

      -- Snacks Prompt Highlights
      SnacksPickerInput = { bg = "black" },
      SnacksPickerPrompt = { bg = "black", fg = "orange" },
      SnacksPickerInputBorder = { link = "SnacksPickerBorder" },
    },
  },

  ui = {
    cmp = {
      icons_left = false, -- only for non-atom styles!
      style = "default", -- default/flat_light/flat_dark/atom/atom_colored
      abbr_maxwidth = 60,
      -- for tailwind, css lsp etc
      format_colors = { lsp = true, icon = "󱓻" },
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
      enabled = true,
      theme = "default", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "default",
      order = { "mode", "path_and_filename", "git", "%=", "lsp_msg", "%=", "lsp", "diagnostics", "cursor" },
      modules = {
        path_and_filename = function()
          local path = vim.api.nvim_buf_get_name(0)
          local file = vim.fn.fnamemodify(path, ":t")
          local parent = vim.fn.fnamemodify(path, ":h:t")
          return parent .. "/" .. file
        end,
      },
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "neotreeOffset", "buffers", "tabs", "btns" },
      modules = {
        neotreeOffset = function()
          local w = getNeotreeWidth()
          return w == 0 and "" or "%#NeoTreeNormal#" .. string.rep(" ", w) .. "%#NeoTreeWinSeparator#" .. "|"
        end,
      },
      bufwidth = 21,
    },
  },

  nvdash = {
    -- load_on_startup = false,
    -- header = {
    --   "                            ",
    --   "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
    --   "   ▄▀███▄     ▄██ █████▀    ",
    --   "   ██▄▀███▄   ███           ",
    --   "   ███  ▀███▄ ███           ",
    --   "   ███    ▀██ ███           ",
    --   "   ███      ▀ ███           ",
    --   "   ▀██ █████▄▀█▀▄██████▄    ",
    --   "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
    --   "                            ",
    --   "     Powered By  eovim    ",
    --   "                            ",
    -- },
    --
    -- buttons = {
    --   { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    --   { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    --   { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    --   { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    --   { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
    --
    --   { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    --
    --   {
    --     txt = function()
    --       local stats = require("lazy").stats()
    --       local ms = math.floor(stats.startuptime) .. " ms"
    --       return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
    --     end,
    --     hl = "NvDashFooter",
    --     no_gap = true,
    --   },
    --
    --   { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    -- },
  },

  term = {
    base46_colors = true,
    winopts = { number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

  mason = { pkgs = {}, skip = {} },

  colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
  },
}

return ChadUI
