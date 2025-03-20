return {
  "GustavEikaas/easy-dotnet.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local function get_secret_path(secret_guid)
      local path = ""
      local home_dir = vim.fn.expand("~")

      if Helpers.is_win() then
        -- stylua: ignore
        local secret_path = home_dir .. "\\AppData\\Roaming\\Microsoft\\UserSecrets\\" .. secret_guid .. "\\secrets.json"
        path = secret_path
      else
        local secret_path = home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
        path = secret_path
      end
      return path
    end

    opts.secrets = {
      path = get_secret_path,
    }

    require("easy-dotnet").setup(opts)
  end,
}
