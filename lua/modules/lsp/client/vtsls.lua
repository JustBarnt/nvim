local Vtsls = {}

---@param client vim.lsp.Client
local function goto_source_definition(client)
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  Helpers.lsp.execute({
    command = "typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  })
end

local function find_all_file_references()
  Helpers.lsp.execute({
    command = "typescript.findAllFileReferences",
    arguments = { vim.uri_from_bufnr(0) },
  })
end

local function select_ts_version()
  Helpers.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
end

---@param client vim.lsp.Client
---@param keys LazyKeysSpec[]
function Vtsls.setup(client, keys)
  assert(client.name == "vtsls", ("Unknown Client: **%s**"):format(client.name))

  client.commands["_typescript.moveToFileRefactoring"] = function(command, _)
    ---@diagnostic disable: assign-type-mismatch
    ---@type string, string, lsp.Range
    local action, uri, range = unpack(command.arguments)

    local function move(newf)
      client:request("workspace/executeCommand", {
        command = command.command,
        arguments = { action, uri, range, newf },
      })
    end

    local fname = vim.uri_to_fname(uri)
    client:request("workspace/executeCommand", {
      command = "typescript.tsserverRequest",
      arguments = {
        "getMoveToRefactoringFileSuggestions",
        {
          file = fname,
          startLine = range.start.line + 1,
          startOffset = range.start.character + 1,
          endLine = range["end"].line + 1,
          endOffset = range["end"].character + 1,
        },
      },
    }, function(_, result)
      ---@type string[]
      local files = result.body.files
      table.insert(files, 1, "Enter new path...")
      vim.ui.select(files, {
        prompt = "Select move destination:",
        format_item = function(f)
          return vim.fn.fnamemodify(f, ":~:.")
        end,
      }, function(f)
        if f and f:find("^Enter new path") then
          vim.ui.input({
            prompt = "Enter move destination:",
            default = vim.fn.fnamemodify(fname, ":h") .. "/",
            completion = "file",
          }, function(newf)
            return newf and move(newf)
          end)
        elseif f then
          move(f)
        end
      end)
    end)
  end

  -- stylua: ignore
  vim.list_extend(keys, {
    {"gD", function() goto_source_definition(client) end, "Goto Source Definition"},
    {"gR", find_all_file_references, "Find All References"},
    { "<leader>co", Helpers.lsp.action["source.organizeImports"], desc = "Organize Imports", },
    { "<leader>cM", Helpers.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports" },
    { "<leader>cu", Helpers.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
    { "<leader>cD", Helpers.lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
    {"<leader>cV", select_ts_version , "Select TS Workspace Version"},
  })
end

return Vtsls
