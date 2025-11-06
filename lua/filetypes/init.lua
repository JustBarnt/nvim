local M = {}

function M.setup()
  vim.filetype.add {
  extension = {
    nu = "nu",
    nush = "nu",
    nuon = "nu",
    nushell = "nu",
    log = "log",
    xaml = "xaml",
    axaml = "axaml",
    cctrx = "cctrx",
    reg = "ini"
  },
  pattern = {
    [".*/git/%a+(%-?%a+)"] = { "gitconfig", { priority = 10 } },
  },
}
end

return M
