local start_cmd = {
  "clangd",
  "--background-index",
  "--clang-tidy",
  "--header-insertion=never",
  "--completion-style=detailed",
  "--function-arg-placeholders=1",
}

local vcvars_cache = {}

local function project_uses_msvc(root_dir)
  local presets = root_dir .. "/CMakePresets.json"

  if not Utils.is_win() then
    return false
  end

  if vim.fn.filereadable(presets) == 0 then
    return true
  end

  local ok, lines = pcall(vim.fn.readfile, presets)
  if not ok then
    return true
  end

  local decode_ok, json = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decode_ok then
    vim.notify("ERROR: Unable to decode CMakePresets.json\nLoading `vcvarsall.bat`", vim.log.levels.WARN)
    return true
  end

  for _, preset in ipairs(json.configurePresets) do
    local cache_vars = preset.cacheVariables
    local C_COMPILER = cache_vars and cache_vars.CMAKE_C_COMPILER or ""
    local CXX_COMPILER = cache_vars and cache_vars.CMAKE_CXX_COMPILER or ""
    if C_COMPILER == "cl.exe" or CXX_COMPILER == "cl.exe" then
      return true
    end
  end
  return false
end

local function get_vcvars_env(root_dir, arch)
  arch = arch or "x64"
  if vcvars_cache[root_dir] then
    return vcvars_cache[root_dir]
  end

  local vswhere_exe = "C:\\Program Files (x86)\\Microsoft Visual Studio\\Installer\\vswhere.exe"
  local vswhere = vim.system(
    { vswhere_exe, "-latest", "-products", "*", "-requires", "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-property", "installationPath" },
    { text = true }
  ):wait()


  if vswhere.code ~= 0 then
    vim.notify("Could not find vswhere.exe: " .. (vswhere.stderr or ""), vim.log.levels.WARN)
    return nil
  end

  local vcvars = string.format("%s\\VC\\Auxiliary\\Build\\vcvarsall.bat", vim.trim(vswhere.stdout))
  if vim.fn.filereadable(vcvars) == 0 then return nil end

  local cmd = string.format('"%s" %s && set', vcvars, arch)

  local result = vim.system(
    { 'cmd.exe', '/c', vcvars, arch, '&&', 'set' },
    { text = true }
  ):wait()

  if result.code ~= 0 then
    vim.notify("vcvarsall.bat failed: " .. (result.stderr or ""), vim.log.levels.WARN)
    return nil
  end

  local env = {}
  for line in result.stdout:gmatch("[^\r\n]+") do
    local key, val = line:match("^(%w+)=(.*)$")
    if key and val then
      env[key] = val
    end
  end
  vcvars_cache[root_dir] = env
  return env
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local extra_env = nil
    if project_uses_msvc(config.root_dir) then
      extra_env = get_vcvars_env(config.root_dir)
    end

    return vim.lsp.rpc.start(start_cmd, dispatchers, { cwd = config.root_dir, env = extra_env })
  end,
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", ".clangd", ".git" },
}
