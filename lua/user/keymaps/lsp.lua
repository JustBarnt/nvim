local lsp = vim.lsp

---@param count integer
---@param severity? vim.diagnostic.Severity
local function diagnostic_goto(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, count = count }
  end
end

local M

-- stylua: ignore start
M.keys = {
  { { "n" },      "K",          lsp.buf.hover,                                     { desc = "Hover"                      } },
  { { "n" },      "gd",         lsp.buf.definition,                                { desc = "Goto Definition"            } },
  { { "n" },      "gD",         lsp.buf.declaration,                               { desc = "Goto Declaration"           } },
  { { "n" },      "grr",        lsp.buf.references,                                { desc = "Goto References"            } },
  { { "n" },      "grt",        lsp.buf.type_definition,                           { desc = "Goto Type Definition"       } },
  { { "n" },      "gro",        lsp.buf.document_symbol,                           { desc = "Document Symbols"           } },
  { { "n" },      "grO",        lsp.buf.workspace_symbol,                          { desc = "Workspace Symbols"          } },
  { { "n" },      "<leader>uc", lsp.codelens.run,                                  { desc = "Run Codelens"               } },
  { { "n" },      "<leader>uC", lsp.codelens.refresh,                              { desc = "Refresh & Display Codelens" } },
  { { "i" },      "<C-s>",      lsp.buf.signature_help,                            { desc = "Signature Helper"           } },
  { { "n" },      "gri",        lsp.buf.implementation,                            { desc = "Goto Implementation"        } },
  { { "n" },      "grn",        lsp.buf.rename,                                    { desc = "Symbol Rename"              } },
  { { "n" },      "grf",        lsp.buf.format,                                    { desc = "Code Format"                } },
  { { "n" },      "grh",        lsp.buf.typehierarchy,                             { desc = "Show Type Hierarchy"        } },
  { { "n", "v" }, "gra",        lsp.buf.code_action,                               { desc = "Code Actions"               } },

  -- Diagnostic Keymaps
  { { "n" },      "gl",         vim.diagnostic.open_float,                         { desc = "Get Diagnostics"            } },
  { { "n" },      "]d",         vim.diagnostic.jump({ count = 1}),                 { desc = "Next Diagnostic"            } },
  { { "n" },      "[d",         vim.diagnostic.jump({ count = -1}),                { desc = "Previous Diagnostic"        } },
  { { "n" },      "]e",         vim.diagnostic.jump({ count = 1,  severity = 1}), { desc = "Next Error"                 } },
  { { "n" },      "[e",         vim.diagnostic.jump({ count = -1, severity = 1}),  { desc = "Previous Error"             } },
  { { "n" },      "]w",         vim.diagnostic.jump({ count = 1,  severity = 2}),  { desc = "Next Warning"               } },
  { { "n" },      "[w",         vim.diagnostic.jump({ count = -1, severity = 2}),  { desc = "Previous Warning"           } },
}
-- stylua: ignore end

return M
