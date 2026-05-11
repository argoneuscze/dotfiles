vim.pack.add { U.gh 'ibhagwan/fzf-lua' }

local fzf = require 'fzf-lua'
fzf.register_ui_select()

U.nmap('<leader>fn', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, 'Neovim config files')

U.nmap('<leader>fB', fzf.builtin, 'Builtin commands')
U.nmap('<leader>fc', fzf.commands, 'Commands')
U.nmap('<leader>fh', fzf.help_tags, 'Help tags')
U.nmap('<leader>fk', fzf.keymaps, 'Keymaps')
U.nmap('<leader>fz', fzf.spell_suggest, 'Spelling suggestions')
U.nmap('<leader>fq', fzf.quickfix, 'Quickfix list')
U.nmap('<leader>f/', fzf.search_history, 'Search history')

U.nmap('<leader>ff', fzf.files, 'Find files')
U.nmap('<leader>fg', fzf.live_grep, 'Live grep')
U.nmap('<leader>fw', fzf.grep_cword, 'Grep word under cursor')
U.nmap('<leader>fb', fzf.buffers, 'Buffers')
U.nmap('<leader>fr', fzf.oldfiles, 'Recent files')
U.nmap('<leader>f.', fzf.resume, 'Resume last search')

U.nmap('<leader>gs', fzf.git_status, 'Git status')
U.nmap('<leader>gc', fzf.git_commits, 'Project commits')
U.nmap('<leader>gB', fzf.git_bcommits, 'Buffer commits')
U.nmap('<leader>gb', fzf.git_branches, 'Branches')

vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grx')
U.nmap('gd', fzf.lsp_definitions, 'LSP Definition')
U.nmap('gD', fzf.lsp_declarations, 'LSP Declaration')
U.nmap('gi', fzf.lsp_implementations, 'LSP Implementation')
U.nmap('gt', fzf.lsp_typedefs, 'LSP Type definition')
U.nmap('gr', fzf.lsp_references, 'LSP References')
U.nmap('<leader>fs', fzf.lsp_document_symbols, 'Document symbols')
U.nmap('<leader>fS', fzf.lsp_live_workspace_symbols, 'Workspace symbols')
U.nmap('<leader>fd', fzf.lsp_document_diagnostics, 'Document diagnostics')
U.nmap('<leader>fD', fzf.lsp_workspace_diagnostics, 'Workspace diagnostics')
