return {
  "b0o/incline.nvim",
  config = function()
    local g_icons = Utils.ui.icons.git
    local d_icons = Utils.ui.icons.diagnostics
    require("incline").setup {
      render = function(props)
        local head = vim.b.gitsigns_head or ""
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        if head ~= "" then
          head = "on " .. head .. " " .. Utils.ui.icons.misc.branch
        end

        local ft_icon, ft_color, is_default = MiniIcons.get("file", filename)

        local function get_git_diff()
          local icons = { removed = g_icons.removed, changed = g_icons.modified, added = g_icons.added }
          local signs = vim.b[props.buf].gitsigns_status_dict
          local labels = {}
          if signs == nil then
            return labels
          end
          for name, icon in pairs(icons) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
            end
          end
          if #labels > 0 then
            table.insert(labels, { "| " })
          end
          return labels
        end

        local function get_diagnostic_label()
          local icons = { error = d_icons.Error, warn = d_icons.Warn }
          local label = {}

          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
            end
          end
          if #label > 0 then
            table.insert(label, { "| " })
          end
          return label
        end

        return {
          { get_diagnostic_label() },
          { get_git_diff() },
          { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
          { filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
          { head, guifg = ft_color, gui = "bold"}
        }
      end,
    }
  end,
}
