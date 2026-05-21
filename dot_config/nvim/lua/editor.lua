-- icons
if vim.g.have_nerd_font then vim.pack.add { U.gh 'nvim-tree/nvim-web-devicons' } end

-- theme
vim.pack.add { U.gh 'Mofiqul/dracula.nvim' }
vim.cmd.colorscheme 'dracula'

-- status line
vim.pack.add {
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

-- indent guides
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {}

-- git signs
vim.pack.add { U.gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {}

-- todo comments
vim.pack.add { U.gh 'folke/todo-comments.nvim' }
require('todo-comments').setup {}
vim.keymap.set('n', '<leader>ft', '<cmd>TodoFzfLua<CR>', { desc = 'TODOs and notes' })

-- surround
vim.pack.add { U.gh 'kylechui/nvim-surround' }

-- show keybinds
vim.pack.add { U.gh 'folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- name existing groups
  spec = {
    { '<leader>f', group = 'Find', mode = { 'n', 'v' } },
    { '<leader>t', group = 'Toggle' },
    { '<leader>c', group = 'LSP Actions' },
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

-- markdown viewer
vim.pack.add { U.gh 'MeanderingProgrammer/render-markdown.nvim' }
require('render-markdown').setup {
  heading = {
    backgrounds = { '', '', '', '', '', '' },
  },
}

-- diffview
vim.pack.add { U.gh 'sindrets/diffview.nvim' }
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Open Diffview' })
vim.keymap.set('n', '<leader>gx', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' })

-- neogit
vim.pack.add { U.gh 'NeogitOrg/neogit' }
vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<CR>', { desc = 'Open Neogit' })

-- oil
function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  else
    return vim.api.nvim_buf_get_name(0)
  end
end
vim.pack.add { U.gh 'stevearc/oil.nvim' }
require('oil').setup {
  win_options = {
    winbar = '%!v:lua.get_oil_winbar()',
  },
}
vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
