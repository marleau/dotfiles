require'colorizer'.setup()

-- =============================================================================
-- Treesitter
-- =============================================================================

require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
  indent = {enable = true},
  incremental_selection = {enable = true}
}

-- =============================================================================
-- LSP
-- =============================================================================

-- require'lspconfig'.display_diagnostic_qf = true

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Mappings
    local bufopts = { noremap=true, silent=true, buffer=ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.keymap.set('n', '<space>f', function() require('conform').format({async = true, lsp_fallback = true}) end, bufopts)

    -- if client.supports_method("textDocument/formatting") then
    --   vim.api.nvim_clear_autocmds({ group = augroup, buffer = ev.buf })
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     group = augroup,
    --     buffer = ev.buf,
    --     callback = function()
    --       vim.lsp.buf.format({ 
    --         async = false,
    --         bufnr = ev.buf,
    --       })
    --     end,
    --   })
    -- end
  end
})

-- Angular
require'lspconfig'.angularls.setup({
  root_dir = require'lspconfig'.util.root_pattern('angular.json', 'project.json')
})

-- Typescript
require'lspconfig'.tsserver.setup({
  -- on_attach = function(client, bufnr)
  --   -- Prevent tsserver from formatting; Use prettier instead
  --   client.server_capabilities.documentFormattingProvider = false

  --   on_attach(client, bufnr)
  -- end
})

-- CSS
require'lspconfig'.cssls.setup {
  settings = {
    scss = {
      lint = {
        unknownAtRules = "ignore"
      }
    }
  }
}
require'lspconfig'.tailwindcss.setup {}

-- Svelte
require'lspconfig'.svelte.setup {}

require'lspconfig'.eslint.setup({
  settings = {format = false}
})

-- =============================================================================
-- conform
-- =============================================================================

require('conform').setup({
  formatters_by_ft = {
    javascript = {{ "prettier" }},
    typescript = {{ "prettier" }},
    svelte = {{ "prettier" }},
    json = {{ "prettier" }},
    jsonc = {{ "prettier" }},
    css = {{ "prettier" }},
    markdown = {{ "prettier" }},
  },
  format_on_save = {
    lsp_fallback = true
  }
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- -- =============================================================================
-- -- null-ls
-- -- =============================================================================

-- local null_ls = require('null-ls')
-- local sources = {
--   null_ls.builtins.code_actions.eslint_d,
--   null_ls.builtins.diagnostics.eslint_d,
--   null_ls.builtins.formatting.lua_format,
--   null_ls.builtins.formatting.prettier.with({file_types = {"svelte"}}),
-- }
-- null_ls.setup({
--   sources = sources,
--   on_attach = on_attach
-- })
