local uri_to_fname = vim.uri_to_fname
local codelens = vim.lsp.codelens
local request = vim.lsp.buf_request
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

---@param bufnr integer
Codelens.full_refresh = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  codelens.clear(nil, bufnr)

  request(
    bufnr,
    "textDocument/codeLens",
    { textDocument = util.make_text_document_params(bufnr) },
    function(err, results, ctx)
      if err or not results or vim.tbl_isempty(results) then
        return
      end

      local client_id = ctx.client_id
      local uri = ctx.params.textDocument.uri
      local client = assert(vim.lsp.get_client_by_id(client_id))

      local uniq = {}
      local filtered_results = {}
      for _, lens in ipairs(results) do
        local range = lens.range.start
        local key = range.line .. ":" .. range.character
        if uniq[key] then
          local existing = uniq[key]
          if not existing.command and lens.command then
            for i, stored in ipairs(filtered_results) do
              if stored == existing then
                filtered_results[i] = lens
                break
              end
            end
          end
          uniq[key] = lens
        else
          uniq[key] = lens
          table.insert(filtered_results, lens)
        end
      end
      results = filtered_results
      if vim.tbl_isempty(results) then
        return
      end

      local pending = #results
      local refs_to_query = {}

      for i, lens in ipairs(results) do
        if lens.command then
          pending = pending - 1
        else
          lens._need_ref = true
          request(bufnr, "codeLens/resolve", lens, function(_, resolved)
            results[i] = resolved or lens
            pending = pending - 1
            if pending == 0 then
              local ref_count = 0
              for j, l in pairs(results) do
                if l._need_ref then
                  table.insert(refs_to_query, { index = j, lens = l })
                  ref_count = ref_count + 1
                end
              end

              if ref_count == 0 then
                codelens.save(results, bufnr, client_id)
                codelens.display(results, bufnr, client_id)
                return
              end
              local remaining = ref_count
              for _, task in ipairs(refs_to_query) do
                local j = task.index
                local l = task.lens
                local pos_params = {
                  textDocument = { uri = uri },
                  position = l.range.start,
                  context = { includeDeclaration = false },
                }
                request(bufnr, "textDocument/references", pos_params, function(err_ref, all_refs)
                  remaining = remaining - 1
                  if err_ref then
                    if remaining == 0 then
                      local final_results = {}
                      for _, lens_final in ipairs(results) do
                        if not lens_final then
                          table.insert(final_results, lens_final)
                        end
                      end
                      codelens.save(final_results, bufnr, client_id)
                      codelens.display(final_results, bufnr, client_id)
                    end
                    return
                  end

                  if not all_refs or vim.tbl_isempty(all_refs) then
                    results[j]._drop = true
                    if remaining == 0 then
                      local final_results = {}
                      for _, lens_final in ipairs(results) do
                        if not lens_final._drop then
                          table.insert(final_results, lens_final)
                        end
                      end
                      codelens.save(final_results, bufnr, client_id)
                      codelens.display(final_results, bufnr, client_id)
                    end
                    return
                  end
                  -- 1. Keep only refs in the buffer
                  --    Translate uri into a filename and normalize it
                  --    to filter our list of references in the current
                  --    buffer instead of across the entire workspace...
                  local in_file_refs = vim.tbl_filter(function(loc)
                    return vim.fs.normalize(uri_to_fname(loc.uri)) == vim.fs.normalize(uri_to_fname(uri))
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
        if pending == 0 then
          codelens.save(results, bufnr, client_id)
          codelens.display(results, bufnr, client_id)
        end
      end
    end
  )
end

return Codelens
