if vim.fn.has "nvim-0.11" ~= 1 then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Must be using at least Neovim V0.11 or nightly to use:\n", "ErrorMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
  --
  -- vim.api.nvim_exec2([[
  -- function! SetMark()
  --   let keycode = getchar()
  --   let keystr = nr2char(keycode)
  --   " Ideavim only supports upper case marks so
  --   " ensure our pressed key is uppercase
  --   " let upper = toupper(keystr)
  --   execute 'mark ' . keystr
  -- endfunction
  --
  -- function! DelMark()
  --   let keycode = getchar()
  --   let keystr = nr2char(keycode)
  --   " Ideavim only supports upper case marks so
  --   " ensure our pressed key is uppercase
  --   " let upper = toupper(keystr)
  --   execute 'delmark ' . keystr
  -- endfunction
  --
  -- function! DelAllMarks()
  --   execute 'delmarks!'
  -- endfunction
  --
  -- function! JumpToMark()
  --   let keycode = getchar()
  --   let keystr = nr2char(keycode)
  --   " Ideavim only supports upper case marks so
  --   " ensure our pressed key is uppercase
  --   " let upper = toupper(keystr)
  --   execute 'norm! `' . keystr
  -- endfunction
  -- ]], { output = false } )
  --

vim.filetype.add {
  extension = {
    nu = "nu",
    nush = "nu",
    nuon = "nu",
    nushell = "nu",
    log = "log",
    xaml = "xaml",
    axaml = "axaml",
    ctx = "ctx"
  },
  pattern = {
    [".*/git/%a+(%-?%a+)"] = { "gitconfig", { priority = 10 } },
  },
}

---@diagnostic disable-next-line: undefined-global
if init_debug then
  local osvpath = vim.fn.stdpath "data" .. "/lazy/one-small-step-for-vimkind"
  vim.opt.rtp:append(osvpath)
  require("osv").launch { port = 8086, blocking = true }
end

require "lsp_overrides"
require "core.options"
require "core.lazy"
