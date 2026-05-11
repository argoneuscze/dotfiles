-- import utils
_G.U = require 'utils'

-- cache Lua modules
vim.loader.enable()

-- load configuration
require 'core'
require 'updater'
require 'editor'
require 'treesitter'
require 'lsp'
require 'fzf'
