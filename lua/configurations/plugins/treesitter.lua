local ensure_installed = {
  "bash", "c", "c_sharp", "cmake",
  "cpp", "diff", "git_config", "gitcommit",
  "git_rebase", "gitignore", "gitattributes", "go",
  "gomod", "gosum", "gowork", "html",
  "ini", "javascript", "jsdoc", "json",
  "json5", "jsonc", "just", "lua",
  "luadoc", "luap", "lua_patterns", "markdown",
  "markdown_inline", "nu", "prisma", "php",
  "printf", "query", "regex", "scheme",
  "svelte", "toml", "tsx", "typescript",
  "vim", "vimdoc", "xml", "yaml",
} 

---@class config.plugins.treesitter
local M = {}

---@param value string|number|nil Either the direct filetype, bufnr if known, or nil to automatically figure it out
---@return string
function M.get_lang(value)
  value = value or vim.api.nvim_get_current_buf()
  local ft = type(value) == 'number' and vim.bo[value].filetype or value --[[@as string]]
  local lang = vim.treesitter.language.get_lang(ft) or ""
  return lang
end

--- Returns if the given lang has the specified query
---@param lang string  The language to check
---@param query string Query to check for
---@return boolean
function M.have_query(lang, query)
  return vim.treesitter.query.get(lang, query) ~= nil
end

--- Uses treesitters `foldexpr` if available
function M.foldexpr()
  local has_folds = M.have_query(M.get_lang(), "folds")
  if has_folds then
    vim.wo.foldexpr = vim.treesitter.foldexpr()
    vim.wo.foldmethod = 'expr'
  end
end

--- Uses Treesitter `indentexpr` if available
---@param buf integer Buffer number
function M.indentexpr(buf)
  local has_indents =  M.have_query(M.get_lang(), "indents")

  if has_indents then
   vim.b[buf].indentexpr = require("nvim-treesitter").indentexpr()
  end
end

function M.initialize()
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, ensure_installed)

  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  local filetypes = {}
  for _, lang in ipairs(ensure_installed) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start Treesitter',
    group = vim.api.nvim_create_augroup('barnt/start_treesitter', { clear = true }),
    pattern = filetypes,
    callback = function(ev)
      vim.treesitter.start(ev.buf)
      M.foldexpr()
      M.indentexpr(ev.buf)
    end
  })
end

return M
