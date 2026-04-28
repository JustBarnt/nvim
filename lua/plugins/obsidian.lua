return {
  "obsidian.nvim",
  ---@module "obsidian"
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "Work",
        path = "D:/Obsidian/Work",
        ---@diagnostic disable-next-line: missing-fields
        overrides = {
          daily_notes = {
            folder = ("01-Tasks/%s/%s/"):format(os.date('%Y'), os.date('%b'))
          }
        }
      },
      {
        name = "Personal",
        path = "D:/Obsidian/Personal",
        ---@diagnostic disable-next-line: missing-fields
        overrides = {
          daily_notes = {
            folder = ("Journal/%s/%s/"):format(os.date('%Y'), os.date('%b'))
          }
        }
      },
    },
    sync = { enabled = true },
  },
}
