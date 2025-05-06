local uri_to_fname = vim.uri_to_fname
local codelens = vim.lsp.codelens
local request = vim.lsp.buf_request
local request_sync = vim.lsp.buf_request_sync
local ts = vim.treesitter
local util = vim.lsp.util
local Codelens = {}

--- Given `references` (an array of `lsp.Location`) return only those that are
--- call-expressions
---@param bufnr integer
---@param references lsp.LocationLink[]|lsp.Location[]
---@return table[] filtered refs
local function filter_call_sites(bufnr, references)
  local parser = assert(ts.get_parser(0, "lua"))
  local tree = parser:parse()[1]:root()

  local query = ts.query.parse(
    "lua",
    [[
    (function_call) @call
  ]]
  )

  local calls = {}
  for id, node, metadata in query:iter_captures(tree, 0, 0, -1) do
    local name = query.captures[id]
    if name == "call" then
      local srow, scol, erow, ecol = node:range()
      for l = srow, erow do
        calls[l] = calls[l] or {}
        table.insert(calls[l], { start_col = scol, end_col = ecol })
      end
    end
  end

  local out = {}
  for _, loc in ipairs(references) do
    local line = loc.range.start.line
    local col = loc.range.start.character
    local row_calls = calls[line]
    if row_calls then
      for _, cr in ipairs(row_calls) do
        if col >= cr.start_col and col < cr.end_col then
          table.insert(out, loc)
          break
        end
      end
    end
  end

  return out
end
---@param bufnr? integer
Codelens.refresh = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  codelens.clear(nil, bufnr)
  request(
    bufnr,
    "textDocument/codeLens",
    { textDocument = util.make_text_document_params(bufnr) },
    function(err, results, ctx)
      if err or results == nil or #results == 0 then
        return
      end

      local client_id = ctx.client_id
      filter_call_sites(bufnr, {})

      local pending = #results
      for i, result in ipairs(results) do
        request(bufnr, "codeLens/resolve", result, function(_, resolved)
          results[i] = resolved or result
          pending = pending - 1
          if pending == 0 then
            for _, lens in ipairs(results) do
              lens.command = lens.command or {}
              if not lens.command.title or lens.command.title == "..." or lens.command.title == "" then
                lens.command.title = "󰍉 Loading..."
              end
            end
            codelens.save(results, bufnr, client_id)
            codelens.display(results, bufnr, client_id)
          end
        end)
      end
    end
  )
end

---@param bufnr integer
Codelens.full_refresh = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  codelens.clear(nil, bufnr)

  request(
    bufnr,
    "textDocument/codeLens",
    { textDocument = util.make_text_document_params(bufnr) },
    function(err, results, ctx)
      if err then
        return
      end
      if not results or vim.tbl_isempty(results) then
        return
      end

      local client_id = ctx.client_id
      local uri = ctx.params.textDocument.uri
      local pending = #results
      local client = assert(vim.lsp.get_client_by_id(client_id))

      for i, lens in ipairs(results) do
        request(bufnr, "codeLens/resolve", lens, function(_, resolved)
          results[i] = resolved or lens
          pending = pending - 1

          -- Once resolved, fetch counts & redrawn
          if pending == 0 then
            for _, l in pairs(results) do
              local pos_params = {
                textDocument = { uri = uri },
                position = l.range.start,
                context = { includeDeclaration = false },
              }

              request(bufnr, "textDocument/references", pos_params, function(err, all_refs, ctx)
                if err then
                  return
                end

                if not all_refs or vim.tbl_isempty(all_refs) then
                  return
                end

                -- 1. Keep only refs in the buffer
                --    Translate uri into a filename and normalize it
                --    to filter our list of references in the current
                --    buffer instead of across the entire workspace...
                local in_file_refs = vim.tbl_filter(function(loc)
                  local loc_fname = vim.fs.normalize(uri_to_fname(loc.uri))
                  local fname = vim.fs.normalize(uri_to_fname(uri))
                  return loc_fname == fname
                end, all_refs)

                -- 2. Filter method/function calls for 'n Usages'
                local calls = filter_call_sites(bufnr, in_file_refs)

                -- 3. Inject Title & Command
                l.command = l.command or {}
                l.command.title = string.format(
                  "%d Reference%s | %d Usage%s",
                  #in_file_refs,
                  (#in_file_refs == 1 and "" or "s"),
                  #calls,
                  (#calls == 1 and "" or "s")
                )

                -- 4. Make it clickable like in VSCode/Visual Studio
                l.command.command = "editor.action.showReferences" -- May need to leave this blank or check if the LSP supports this?
                l.command.arguments = {
                  uri,
                  l.range.start,
                  util.locations_to_items(in_file_refs, client.offset_encoding),
                }

                -- 5. Save and Display our codelens
                codelens.save(results, bufnr, client_id)
                codelens.display(results, bufnr, client_id)
              end)
            end
          end
        end)
      end
    end
  )
end

return Codelens
