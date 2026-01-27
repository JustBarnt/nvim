---@type vim.lsp.Config
return {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      completion = true,
      hover = true,
      format = {
        enable = true,
      },
      validate = true,
      schemaStore = {
        enable = false,
        url = ""
      },
    }
  },
  before_init = function(_, new_config)
    local ok, schemas = pcall(require, "schemastore")
    if ok then
      ---@diagnostic disable-next-line: inject-field
      new_config.settings.yaml.schemas = vim.tbl_deep_extend(
        "force",
        new_config.settings.yaml.schemas or {},
        schemas.yaml.schemas({
          extra = {
            {
              description = "Microsoft Desired State Configuration",
              fileMatch = '*.dsc.yaml',
              name = '*.dsc.yaml',
              url = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json '
            }
          }
        })
      )
    end
  end
}
