---@module "roslyn"
return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  ---@class RoslynNvimConfig
  opts = {
    filewatching = "roslyn",
    broad_search = true,
  },
}
