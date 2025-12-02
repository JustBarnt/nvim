---@type vim.lsp.Config
return {
  settings = {
    json = {
      format = {
        enable = true,
      },
      schemas = require("schemastore").json.schemas {
        extra = {
          {
            description = "CMakePresets",
            fileMatch = "CMakePresets.json",
            name = "CMakePresets.json",
            url = "https://raw.githubusercontent.com/Kitware/CMake/master/Help/manual/presets/schema.json",
          },
          {
            description = "Microsoft Desired State Configuration",
            fileMatch = "*.dsc.json",
            name = "*.dsc.json",
            url = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json'
          }
        },
      },
      validate = { enable = true },
    },
  },
}
