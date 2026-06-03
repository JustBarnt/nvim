---@class utils.overseer
local M = {}

---@module 'overseer'
M.templates = {
  {
    name = "Git Checkout",
    params = function()
      local stdout = vim.system({ "git", "branch", "--format=%(refname:short)" }):wait().stdout
      local branches = vim.split(stdout, "\n", { trimempty = true })
      return {
        branch = {
          desc = "Branches to checkout",
          type = "enum",
          choices = branches,
        },
      }
    end,
    builder = function(params)
      return {
        cmd = { "git", "checkout", params.branch },
      }
    end,
  },
  {
    name = "CMake Build",
    desc = "Run a CMake Build",
    params = function()
      local stdout = vim.system({ "cmake", "--list-presets" }):wait().stdout or ""
      -- Get our presets with the "Available configured presets:\n\n"
      -- also remove the extra double quotes
      local presets_list = stdout:sub(33):gsub('"', "")
      local presets = vim.split(presets_list, "\n", { trimempty = true })
      return {
        presets = {
          desc = "Build Presets",
          type = "enum",
          choices = presets,
        },
      }
    end,
    builder = function(params)
      return {
        cmd = { "cmake", "--build", "--preset", params.presets },
      }
    end,
    -- condition = {
    --   dir = {}
    -- },
  },
  {
    name = "CMake Presets",
    desc = "Run a CMake Preset",
    tags = {  },
    params = function()
      local stdout = vim.system({ "cmake", "--list-presets" }):wait().stdout or ""
      -- Get our presets with the "Available configured presets:\n\n"
      -- also remove the extra double quotes
      local presets_list = stdout:sub(33):gsub('"', "")
      local presets = vim.split(presets_list, "\n", { trimempty = true })
      return {
        presets = {
          desc = "Presets",
          type = "enum",
          choices = presets,
        },
      }
    end,
    builder = function(params)
      return {
        cmd = { "cmake", "--preset", params.presets },
      }
    end,
    -- condition = {
    --   filetype = { "cpp" },
    -- },
  },
}

function M.setup_template()
  for _, template in ipairs(M.templates) do
    require("overseer").register_template(template)
    vim.notify(string.format("Registered Template: %s", template.name), vim.log.levels.INFO)
  end
end

return M
