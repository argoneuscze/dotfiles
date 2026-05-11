-- icons
if vim.g.have_nerd_font then vim.pack.add { U.gh 'nvim-tree/nvim-web-devicons' } end

-- theme
vim.pack.add { U.gh 'Mofiqul/dracula.nvim' }
vim.cmd.colorscheme 'dracula'

-- status line
vim.pack.add {
  U.gh 'nvim-tree/nvim-web-devicons',
  U.gh 'nvim-lualine/lualine.nvim',
}
require('lualine').setup {
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
  },
}

-- smart indenting
vim.pack.add { U.gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

-- git signs
vim.pack.add { U.gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {}

-- show keybinds
vim.pack.add { U.gh 'folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- name existing groups
  spec = {
    { '<leader>f', group = 'Find', mode = { 'n', 'v' } },
    { '<leader>t', group = 'Toggle' },
    { '<leader>g', group = 'Git', mode = { 'n' } },
  },
}

-- notifications
vim.pack.add { U.gh 'j-hui/fidget.nvim' }
require('fidget').setup {}

-- diagnostic plugin
vim.pack.add { U.gh 'rachartier/tiny-inline-diagnostic.nvim' }
require('tiny-inline-diagnostic').setup {
  options = {
    show_source = {
      enabled = true,
    },
    multilines = {
      enabled = true,
    },
    enable_on_insert = true,
  },
}
