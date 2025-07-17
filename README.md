# Config Re-write


## Tree-sitter
Use `nvim-treesitter` `main` branch
    - use `ftplugin` to setup the highlighting and downloading for the parse if it is not installed

Installing:
`require'nvim-treesitter'.install { ... }`

Highlighting, folds, indentation:
```lua
vim.api.nvim_create_autocmd('filetype', {
    pattern = { '<filetype>' },
    callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr"
    end
})
```
