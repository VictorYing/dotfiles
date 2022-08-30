-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
  use {
      'nvim-treesitter/nvim-treesitter',
      run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  use 'neovim/nvim-lspconfig'

  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
      requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- since telescope.nvim requires rg, might as well get used to using rg
  use 'jremmen/vim-ripgrep'

  use 'nvim-lualine/lualine.nvim'

  use {
      'lewis6991/gitsigns.nvim',
      tag = 'release',
  }
end)

require'nvim-treesitter.configs'.setup {
  ensure_installed = { 'c', 'cpp', 'python' },
  highlight = {
    enable = true,
  },
}

-- Note, this requires you have `clangd` on your $PATH, and note you want a
-- recent version of `clangd`, not an old version from your OS's package
-- manager.  You can download prebuilt binaries from
-- https://github.com/clangd/clangd/releases/latest
require'lspconfig'.clangd.setup{}

require('telescope').setup()

require('lualine').setup {
  options = {
    icons_enabled = false,
    component_separators = '|',
    section_separators = '',
  },
}

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
