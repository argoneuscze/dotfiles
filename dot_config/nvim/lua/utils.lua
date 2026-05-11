local M = {}

M.gh = function(repo) return 'https://github.com/' .. repo end

M.nmap = function(keys, func, desc) vim.keymap.set('n', keys, func, { desc = desc }) end

return M
