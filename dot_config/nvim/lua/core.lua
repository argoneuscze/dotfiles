-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- share clipboard
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- general
vim.o.number = true
vim.g.have_nerd_font = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.confirm = true
vim.o.winborder = 'rounded'
vim.o.scrolloff = 10
vim.o.inccommand = 'split'
vim.o.undofile = true
vim.o.cursorline = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.opt.termguicolors = true

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- tab
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.breakindent = true

-- invisible characters
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- splits
vim.o.splitright = true
vim.o.splitbelow = true
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- disable arrows
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move left"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move right"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move up"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move down"<CR>')

-- black hole register
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = 'Delete without register' })

-- diagnostic
vim.diagnostic.config {
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN] = '●',
      [vim.diagnostic.severity.INFO] = '●',
      [vim.diagnostic.severity.HINT] = '●',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.INFO] = 'InfoMsg',
      [vim.diagnostic.severity.HINT] = 'HintMsg',
    },
  },
  severity_sort = true,
}
