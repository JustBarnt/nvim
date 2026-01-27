vim.opt.sh = "nu"

-- WARN: disable usage of temp files for shell commands
-- Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
-- When set to `false` the stdin pipe will be used instead
-- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
--       according to: https://github.com/neovim/neovim/issues/33012 `shelltemp` is now set to be false by default on nightly
vim.opt.shelltemp = false

-- string to be used to put the output of shell commands in a temp file
-- 1. when 'shelltemp' is `true`
-- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set
--    to use an external diff command: `set diffopt-=internal`
vim.opt.shellredir = "out+err> %s"

-- flags for nu:
-- * `--stdin`       redirect all input to -c
-- * `--no-newline`  do not append '\n' to stdout
-- * `--commands -c` execute a command
vim.opt.shellcmdflag = "--stdin --no-newline -c"

-- disable all escaping and quoting
vim.opt.shellxescape = ""
vim.opt.shellxquote = ""
vim.opt.shellquote = ""

-- string to be used with `:make` command to:
-- 1. save teh stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
-- 2. show the stdout, stderr and the return_code on the screen
-- NOTE: `ansi strip` removes all ansi coloring from nushell errors
vim.opt.shellpipe =
  "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"

-- NOTE: Add custom nu config and env to `vim.opt.sh`

-- My windows setup makes use of XDG Environment variables. Unless you do the same do not copy this line for line.
if jit.os == "Windows" then
  local command = ("nu --env-config %s\\nushell\\env.nu --config %s\\nushell\\config.nu"):format(vim.env.XDG_CONFIG_HOME, vim.env.XDG_CONFIG_HOME)
  vim.opt.sh = command
else
  vim.opt.sh = "nu --env-config ~/.config/nushell/env.nu --config ~/.config/nushell/config.nu"
end
