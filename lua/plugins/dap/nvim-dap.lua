return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down Stack Frames" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up Stack Frames" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },

      { "<Down>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<Right>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<Left>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<Up>", function() require("dap").restart_frame() end, desc = "Restart Frame" }, 
    },
    config = function()
      if Utils.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(Utils.opts("mason-nvim-dap"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Utils.ui.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    lazy = false,
    version = "1.*",
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      winbar = {
        controls = { enabled = true }
      },
      auto_toggle = true,
      follow_tab = true,
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    },
    config = function() end,
  },
}
