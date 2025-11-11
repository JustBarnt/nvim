local api = vim.api
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local fn = vim.fn
local vloc = vim.opt_local

autocmd("CmdlineEnter", {
  pattern = { "cd", "tcd", "lcd" },
  desc = "Disable out when using `cd` command inside neovim",
  command = "!silent",
})

autocmd("User", {
  group = augroup("barnt/lsprename", { clear = true }),
  desc = "Use Snacks to enable LSP file renaming for imports when a file is moved or renamed",
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("barnt/checktime", { clear = true }),
  desc = "Reload the file if the content changed",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

autocmd("TextYankPost", {
  group = augroup("barnt/yank", { clear = true }),
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd("VimResized", {
  group = augroup("barnt/resize_splits", { clear = true }),
  desc = "Resize splits if the terminal window changes",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext" .. current_tab)
  end,
})


-- from https://www.reddit.com/r/neovim/comments/1abd2cq/what_are_your_favorite_tricks_using_neovim/
autocmd("BufReadPost", {
  group =  augroup("barnt/last_buf_pos", { clear = true }),
  desc = "Open file at the last position it was in buffer",
  command = 'silent! normal! g`"zv',
})

autocmd("FileType", {
  group = augroup("barnt/quickquit", { clear = true }),
  desc = "Quick close out of certain filetypes",
  --stylua: ignore
  pattern = {
    "PlenaryTestPopup", "oil", "checkhealth",
    "dbout", "gitsigns-blame", "grug-far",
    "qf", "startuptime", "tsplayground",
    "help", "lspinfo", "notify",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit Buffer",
      })
    end)
  end,
})

autocmd("FileType", {
  desc = "Wrap, spelling, spell check",
  group = augroup("barnt/wrapspell", { clear = true }),
  pattern = { "text", "plaintex", "gitcommit", "markdown" },
  callback = function()
    vloc.wrap = true
    vloc.spell = true
    vloc.breakindent = true
    vloc.linebreak = true
  end,
})

autocmd("FileType", {
  group = augroup("barnt/json_conceal", { clear = true }),
  desc = "Disable `concealleavel` for json files",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vloc.conceallevel = 0
  end,
})

autocmd({ "BufWritePre" }, {
  group = augroup("barnt/auto_create_dir", { clear = true }),
  desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup("barnt/cursorline_active", { clear = true }),
  desc = "Show cursor line only in active window",
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup("barnt/cursorline_inactive", { clear = true }),
  desc = "",
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

autocmd({ "FileType" }, {
  group = augroup("barnt/help_splt", { clear = true }),
  desc = "Open help in split",
  pattern = "help",
  command = "wincmd L",
})

-- autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
--   desc = "Fix scrolloff when you are at the EOF",
--   group = augroup("barnt/scroll_eof", { clear = true }),
--   callback = function(event)
--     if api.nvim_win_get_config(0).relative ~= "" then
--       return -- Ignore floating windows
--     end
--
--     local win_height = fn.winheight(0)
--   end
-- })
