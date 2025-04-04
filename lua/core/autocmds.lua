local virt_line
local virt_text
vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
  group = vim.api.nvim_create_augroup("diag_only_virtlines", {}),
  callback = function()
    if virt_line == nil then
      virt_line = vim.diagnostic.config().virtual_lines
    end

    -- ignore if virtual_lines.currentJ_line is disabled
    if not (virt_line and virt_line.current_line) then
      if virt_text then
        vim.diagnostic.config({ virtual_text = virt_text })
        virt_text = nil
      end
    end

    if virt_text == nil then
      virt_text = vim.diagnostic.config().virtual_text
    end

    if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })) then
      vim.diagnostic.config({ virtual_text = virt_text })
    else
      vim.diagnostic.config({ virtual_text = false })
    end
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("diag_redraw", {}),
  callback = function()
    pcall(vim.diagnostic.show)
  end,
})

-- -- Update and hide any inline diagnostics when on the current line
-- vim.api.nvim_create_autocmd({ "CursorMoved" }, {
--   callback = function(args)
--     --- Don't bother trying to run the autocmd if the buffer has no diagnostics
--     if #vim.diagnostic.count(args.buf) == 0 then
--       return
--     end
--     ---@type uv.uv_timer_t|nil
--     local timer = nil
--     local debounce = 100
--     local function refresh_diagnostics()
--       vim.diagnostic.show(nil, 0)
--     end
--
--     local function debounce_diag_refresh()
--       if timer then
--         timer:stop()
--         timer:close()
--       end
--       timer = vim.uv.new_timer()
--       assert(timer)
--       timer:start(debounce, 0, vim.schedule_wrap(refresh_diagnostics))
--     end
--
--     debounce_diag_refresh()
--   end,
-- })

-- Autoformat on save
-- TODO: Eventually setup in a similar way to LazyVim
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local ignored = { "xml" }
    -- disable autoformatting based of filetype
    if vim.tbl_contains(ignored, ft) then
      return
    end
    require("conform").format({ bufnr = args.buf })
  end,
})

-- Enable LSP file renaming for imports, etc when a file is moved or renamed
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("Yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "oil",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit Buffer",
      })
    end)
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("json_conceal", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
