-- Server configuration
local tools = { 'shellcheck' }
local servers = { 'stylua', 'lua_ls' }
local autoenable_exclude = {}

local server_config = {
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },
  ruff = {
    -- Let pyright handle hover
    on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
  },
  basedpyright = {
    ---@type lspconfig.settings.basedpyright
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { '*' },
        },
      },
    },
  },
  gopls = {
    ---@type lspconfig.settings.gopls
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          ignoredError = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
}

if vim.fn.executable 'node' == 1 then
  vim.list_extend(servers, { 'bashls' })
  vim.list_extend(tools, { 'prettierd' })
end

if vim.fn.executable 'go' == 1 then
  vim.list_extend(servers, { 'gopls' })
  vim.list_extend(tools, { 'goimports', 'gofumpt' })
end

if vim.fn.executable 'python' == 1 or vim.fn.executable 'python3' == 1 then vim.list_extend(servers, { 'basedpyright', 'ruff' }) end

if vim.fn.executable 'cargo' == 1 then
  vim.list_extend(servers, { 'rust-analyzer' })
  vim.list_extend(autoenable_exclude, { 'rust_analyzer' })
  vim.pack.add {
    {
      src = 'https://github.com/mrcjkb/rustaceanvim',
      version = vim.version.range '^9',
    },
  }
end

-- LSP hook
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    -- LSP bindings
    map('<leader>cr', vim.lsp.buf.rename, 'LSP Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'LSP Code actions', { 'n', 'x' })
    map('<C-s>', vim.lsp.buf.hover, 'LSP Hover', { 'n' })

    -- Highlight references under cursor
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Toggle inlay hints
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map(
        '<leader>th',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf }) end,
        'LSP Inlay hints'
      )
    end
  end,
})

-- Install and run servers
vim.pack.add {
  U.gh 'neovim/nvim-lspconfig',
  U.gh 'mason-org/mason.nvim',
  U.gh 'mason-org/mason-lspconfig.nvim',
  U.gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('mason').setup {}

local ensure_installed = {}
vim.list_extend(ensure_installed, servers)
vim.list_extend(ensure_installed, tools)

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- Configure specific servers
for name, server in pairs(server_config) do
  vim.lsp.config(name, server)
end

-- Automatically start all installed servers
require('mason-lspconfig').setup {
  automatic_enable = {
    exclude = autoenable_exclude,
  },
}

-- Snippets
vim.pack.add { U.gh 'rafamadriz/friendly-snippets' }

-- Autocompletion
vim.pack.add { { src = U.gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'accept', 'fallback' },
    ['<C-s>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-q>'] = { 'show_signature', 'hide_signature', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
    ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 0 },
    trigger = { show_in_snippet = true },
    list = { selection = { preselect = false, auto_insert = false } },
    menu = {
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'kind' },
          { 'source_name' },
        },
        components = {
          source_name = {
            text = function(ctx) return '[' .. ctx.source_name .. ']' end,
          },
        },
      },
    },
  },
  signature = {
    enabled = true,
    trigger = { show_on_insert = true },
    window = { show_documentation = true },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

-- Formatting
vim.pack.add { U.gh 'stevearc/conform.nvim' }
local conform = require 'conform'
conform.setup {
  notify_on_error = false,
  default_format_opts = {
    async = true,
    lsp_format = 'fallback',
    timeout_ms = 3000,
  },
  formatters_by_ft = {
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    python = { 'ruff_organize_imports', 'ruff_format' },
    go = { 'goimports', 'gofumpt' },
  },
}
vim.keymap.set({ 'n', 'v' }, '<leader>cf', function() conform.format() end, { desc = 'Format code' })
