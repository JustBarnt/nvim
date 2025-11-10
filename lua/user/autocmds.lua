local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local api = vim.api
local vloc = vim.opt_local

-- Disable out when using `cd` command inside neovim
autocmd("CmdlineEnter", {
  pattern = { "cd", "tcd", "lcd" },
  command = "!silent",
})

-- Use Snacks to enable LSP file renaming for imports when a file is moved or renamed
autocmd("User", {
  group = augroup("barnt/lsprename", { clear = true }),
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

-- Reload the file if the content changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("barnt/checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
  group = augroup("barnt/yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits if the terminal window changes
autocmd("VimResized", {
  group = augroup("barnt/resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext" .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
autocmd("BufReadPost", {
  group = augroup("barnt/last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = api.nvim_buf_get_mark(buf, "")
    local lcount = api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Quick close out of certain filetypes
autocmd("FileType", {
  group = augroup("barnt/quickquit", { clear = true }),
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

-- Wrap, spelling, spell check
autocmd("FileType", {
  group = augroup("barnt/wrapspell", { clear = true }),
  pattern = { "text", "plaintex", "gitcommit", "markdown" }, 
  callback = function()
    vloc.wrap = true
    vloc.spell = true
    vloc.breakindent = true
    vloc.linebreak = true
  end
})

-- Disable `concealleavel` for json files
autocmd("FileType", {
  group = augroup("barnt/json_conceal", { clear = true }),
  pattern = { "json", "jsonc", "json5"},
  callback = function()
    vloc.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup("barnt/auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match "^%w%w+://" then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Show cursor line only in active window
autocmd({"InsertLeave", "WinEnter" }, {
  group = augroup("barnt/cursorline_active", { clear = true }),
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})

autocmd({"InsertEnter", "WinLeave" }, {
  group = augroup("barnt/cursorline_inactive", { clear = true }),
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})
