return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  init = function()
    Config.plugins.treesitter.initialize()
  end,
  config = function() 
    require('nvim-treesitter').setup() 
  end,
}
