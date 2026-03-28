return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "folke/snacks.nvim" },
  opts = {
    managed_terminal = {
      auto_hide = true, -- auto hides terminal if exit code is 0
      auto_hide_delay = 10, -- delay before auto hiding, 0 = instant
    },
    -- Optional configuration for external terminals (matches nvim-dap structure)
    external_terminal = nil,
    lsp = {
      enabled = true, -- Enable builtin roslyn lsp
      preload_roslyn = true, -- Start loading roslyn before any buffer is opened
      roslynator_enabled = true, -- Automatically enable roslynator analyzer
      easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
      auto_refresh_codelens = true,
      analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
      config = {},
    },
    debugger = {
      -- Path to custom coreclr DAP adapter
      -- easy-dotnet-server falls back to its own netcoredbg binary if bin_path is nil
      bin_path = nil,
      console = "integratedTerminal", -- Controls where the target app runs: "integratedTerminal" (Neovim buffer) or "externalTerminal" (OS window)
      apply_value_converters = true,
      auto_register_dap = true,
      mappings = {
        open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
      },
    },
    ---@type TestRunnerOptions
    test_runner = {
      auto_start_testrunner = true,
      hide_legend = false,
      ---@type "split" | "vsplit" | "float" | "buf"
      viewmode = "float",
      ---@type number|nil
      vsplit_width = nil,
      ---@type string|nil "topleft" | "topright"
      vsplit_pos = nil,
      icons = {
        passed = "",
        skipped = "",
        failed = "",
        success = "",
        reload = "",
        test = "",
        sln = "󰘐",
        project = "󰘐",
        dir = "",
        package = "",
        class = "",
        build_failed = "󰒡",
      },
      mappings = {
        run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
        get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
        peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
        debug_test_from_buffer = { lhs = "<leader>d", desc = "run test from buffer" },
        debug_test = { lhs = "<leader>d", desc = "debug test" },
        go_to_file = { lhs = "g", desc = "go to file" },
        run_all = { lhs = "<leader>R", desc = "run all tests" },
        run = { lhs = "<leader>r", desc = "run test" },
        peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
        expand = { lhs = "o", desc = "expand" },
        expand_node = { lhs = "E", desc = "expand node" },
        collapse_all = { lhs = "W", desc = "collapse all" },
        close = { lhs = "q", desc = "close testrunner" },
        refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
        cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
      },
    },
    new = {
      project = {
        prefix = "sln", -- "sln" | "none"
      },
    },
    ---@param action "test" | "restore" | "build" | "run"
    terminal = function(path, action, args)
      args = args or ""
      local commands = {
        run = function()
          return string.format("dotnet run --project %s %s", path, args)
        end,
        test = function()
          return string.format("dotnet test %s %s", path, args)
        end,
        restore = function()
          return string.format("dotnet restore %s %s", path, args)
        end,
        build = function()
          return string.format("dotnet build %s %s", path, args)
        end,
        watch = function()
          return string.format("dotnet watch --project %s %s", path, args)
        end,
      }
      local command = commands[action]()
      if require("easy-dotnet.extensions").isWindows() == true then
        command = command .. "\r"
      end
      vim.cmd("vsplit")
      vim.cmd("term " .. command)
    end,
    csproj_mappings = true,
    fsproj_mappings = true,
    auto_bootstrap_namespace = {
      --block_scoped, file_scoped
      type = "block_scoped",
      enabled = true,
      use_clipboard_json = {
        behavior = "prompt", --'auto' | 'prompt' | 'never',
        register = "+", -- which register to check
      },
    },
    server = {
      ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
      log_level = nil,
      use_visual_studio = true
    },
    -- choose which picker to use with the plugin
    -- possible values are "telescope" | "fzf" | "snacks" | "basic"
    -- if no picker is specified, the plugin will determine
    -- the available one automatically with this priority:
    -- telescope -> fzf -> snacks ->  basic
    picker = "snacks",
    background_scanning = true,
    notifications = {
      --Set this to false if you have configured lualine to avoid double logging
      handler = function(start_event)
        local spinner = require("easy-dotnet.ui-modules.spinner").new()
        spinner:start_spinner(start_event.job.name)
        ---@param finished_event JobEvent
        return function(finished_event)
          spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
        end
      end,
    },
    diagnostics = {
      default_severity = "error",
      setqflist = false,
    },
  },
}
