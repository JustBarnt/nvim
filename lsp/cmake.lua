return {
  cmd = { "cmake-language-server" },
  root_markers = { "CMakePresets.json", "CTestConfig.cmake", "cmake", "build" },
  filetypes = { "cmake" },
  capabilities = Helpers.lsp.create_capabilities(),
  init_options = {
    buildDirectory = "build",
  },
}
