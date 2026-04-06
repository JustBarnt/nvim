---@type vim.lsp.Config

local query_driver = "--query-driver=" .. table.concat(
  {
    "C:/Users/bwilliams/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT.LLVM_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin/clang++.exe",
    "C:/Users/bwilliams/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT.LLVM_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin/clang-cl.exe",
    "C:/Users/bwilliams/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT.LLVM_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin/gcc.exe",
    "C:/Users/bwilliams/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT.LLVM_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin/g++.exe",
  }, ",")

return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--function-arg-placeholders=1",
    query_driver
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", ".clangd", ".git" }
}
