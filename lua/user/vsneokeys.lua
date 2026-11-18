local function vsc(lhs, command, desc)
  vim.keymap.set('n', lhs, function() vsneo.cmd(command) end,
    { silent = true, desc = desc })
end
-- find: the embedded Seeky picker (Telescope-style, over the native fff
-- engine — built into VSNeo, nothing else to install). Its keys are Visual
-- Studio chords, so they work in every mode and take nothing from nvim:
--   Ctrl+Shift+Alt+O  files          Ctrl+Shift+Alt+,  workspace symbols
--   Ctrl+Shift+Alt+I  live grep      Ctrl+Shift+Alt+B  document outline
--   Ctrl+Shift+Alt+G  grep word/sel  Ctrl+Shift+Alt+M  git modified
--   Ctrl+Shift+Alt+L  current file   Ctrl+Shift+Alt+R  resume last picker
-- (rebind under Tools > Options > Keyboard, Tools.Seeky*). From nvim, the
-- same pickers are :Seeky <mode> [query] and vsneo.seeky(mode, query), e.g.
--   vim.keymap.set('n', '<leader>ff', function() vsneo.seeky('files') end)

-- vim.keymap.del('n', '<leader>f')
-- vim.keymap.del('n', '<leader>sf')
vim.keymap.set('n', '<leader>ff', function() vsneo.seeky('files') end, { desc = "Find Files (Seeky)"})

-- I want gc and gcc to behave the same way in visual studio as it does in vim
local comment = function() return require('vim._comment').operator() end
vim.keymap.set({ 'n', 'x' }, 'gc', comment, { expr = true, desc = 'Toggle comment' })
vim.keymap.set('n', 'gcc', function() return comment() .. '_' end, { expr = true, desc = 'Toggle comment line' })

vsc('<C-r>', 'Edit.Redo', 'Redo Change')

-- buffers / tabs
vsc('<S-L>', 'Window.NextTab', 'Next tab')
vsc('<S-H>', 'Window.PreviousTab', 'Previous tab')

vsc('<leader>bn', 'Window.NextTab', 'Next tab')
vsc('<leader>bp', 'Window.PreviousTab', 'Previous tab')

-- code
vsc('grn', 'Refactor.Rename', 'Rename symbol')
vsc('grf', 'Edit.FormatDocument', 'Format document')
vsc('gre', 'View.ErrorList', 'Error list')
vsc('grR', 'Edit.FindAllReferences', 'Find All References')
vsc('gro', 'EditorContextMenus.CodeWindow.ToggleHeaderCodeFile', 'Toggle Header/Source Code')
vsc('grO', 'EditorContextMenus.CodeWindow.PeekHeaderCodeFile', 'Peek Header/Source Code')
vsc('<leader>k', 'Edit.PeekDefinition', 'Peek Definition')

-- multi-edit: arm the matches of the last search (/ or *), change one with
-- cgn/ciw, and Esc replays the change at every other match
vim.keymap.set('n', '<leader>mm', function() vsneo.multi_edit() end,
  { silent = true, desc = 'Multi-edit all search matches' })

-- build
vsc('<leader>bb', 'Build.BuildSolution', 'Build solution')
vsc('<leader>bs', 'Build.BuildSelection', 'Build project')
vsc('<leader>bc', 'Build.CancelBuild', 'Cancel build')
vsc('<leader>be', 'View.ErrorList', 'Error list')

-- debug: nvim-dap's keys (as LazyVim binds them), driving Visual Studio's
-- debugger. Breakpoints and the current line are drawn by Visual Studio.
vsc('<leader>db', 'Debug.ToggleBreakpoint', 'Toggle breakpoint')
vsc('<leader>dB', 'Debug.EnableBreakpoint', 'Enable/disable breakpoint')
vsc('<leader>dc', 'Debug.Start', 'Continue / start debugging')
vsc('<leader>dC', 'Debug.RunToCursor', 'Run to cursor')
vsc('<leader>dn', 'Debug.StartWithoutDebugging', 'Run without debugging')
vsc('<leader>di', 'Debug.StepInto', 'Step into')
vsc('<leader>do', 'Debug.StepOut', 'Step out')
vsc('<leader>dO', 'Debug.StepOver', 'Step over')
vsc('<leader>dr', 'Debug.Restart', 'Restart debugging')
vsc('<leader>dt', 'Debug.StopDebugging', 'Terminate')
vsc('<leader>dp', 'Debug.BreakAll', 'Pause')
vsc('<leader>dq', 'Debug.QuickWatch', 'Quick watch')
vsc('<leader>dw', 'Debug.Watch1', 'Watch window')
vsc('<leader>dl', 'Debug.Locals', 'Locals window')
vsc('<leader>dk', 'Debug.CallStack', 'Call stack')
vsc('<leader>dD', 'Debug.Windows.Breakpoints', 'Breakpoints window')

-- test: neotest-style keys over the Test Explorer. "In context" is the test,
-- class or file under the cursor.
vsc('<leader>tt', 'TestExplorer.RunAllTestsInContext', 'Run tests here')
vsc('<leader>td', 'TestExplorer.DebugAllTestsInContext', 'Debug tests here')
vsc('<leader>tT', 'TestExplorer.RunAllTests', 'Run all tests')
vsc('<leader>tl', 'TestExplorer.RepeatLastRun', 'Repeat last run')
vsc('<leader>tf', 'TestExplorer.RunFailedTests', 'Run failed tests')
vsc('<leader>te', 'TestExplorer.ShowTestExplorer', 'Test Explorer')

-- git: the Git menu, gitsigns-style keys. Hunk navigation has no command
-- in Visual Studio's editor (only the diff viewer's Diff.NextDifference).
vsc('<leader>gg', 'Team.Git.GoToGitChanges', 'Git changes')
vsc('<leader>gc', 'Team.Git.CommitOrStash', 'Commit')
vsc('<leader>gp', 'Team.Git.Push', 'Push')
vsc('<leader>gP', 'Team.Git.Pull', 'Pull')
vsc('<leader>gf', 'Team.Git.Fetch', 'Fetch')
vsc('<leader>gs', 'Team.Git.Sync', 'Sync')
vsc('<leader>gh', 'Team.Git.ViewHistory', 'File history')
vsc('<leader>gB', 'Team.Git.ManageBranches', 'Branches')
vsc('<leader>gd', 'Team.Git.CompareWithUnmodified', 'Diff with unmodified')
vsc('<leader>gr', 'Team.Git.OpenRepository', 'Repository window')

-- windows
vsc('<leader>e', 'View.SolutionExplorer', 'Solution Explorer')
