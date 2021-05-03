vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
  vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      underline = true,
      signs = true,
      update_in_insert = true
    }
  )(...)
  pcall(vim.lsp.diagnostic.set_loclist, {open_loclist = false})
end

vim.cmd [[autocmd BufWritePre *.ts,*.js,*.html,*.scss,*.css,*.json lua vim.lsp.buf.formatting()]]

-- vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
--     if err ~= nil or result == nil then
--         return
--     end
--     if not vim.api.nvim_buf_get_option(bufnr, "modified") then
--         local view = vim.fn.winsaveview()
--         vim.lsp.util.apply_text_edits(result, bufnr)
--         vim.fn.winrestview(view)
--         if bufnr == vim.api.nvim_get_current_buf() then
--             vim.cmd [[noautocmd :update]]
--         end
--     end
-- end

-- =============================================================================
--    Treesitter
-- =============================================================================

require"nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
  highlight = {enable = true},
  indent = {enable = true},
  incremental_selection = {enable = true}
}

-- =============================================================================
--    LSP
-- =============================================================================

local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
  local function keymap(mode, key, result)
    vim.api.nvim_buf_set_keymap(bufnr, mode, key, "<cmd>lua "..result.."<cr>", {noremap = true, silent = true})
  end

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Keymaps
  keymap("n" , "gD"         , "vim.lsp.buf.declaration()")
  keymap("n" , "gd"         , "vim.lsp.buf.definition()")
  keymap("n" , "K"          , "vim.lsp.buf.hover()")
  keymap("n" , "gi"         , "vim.lsp.buf.implementation()")
  keymap("n" , "<C-k>"      , "vim.lsp.buf.signature_help()")
  keymap("n" , "<space>wa"  , "vim.lsp.buf.add_workspace_folder()")
  keymap("n" , "<space>wr"  , "vim.lsp.buf.remove_workspace_folder()")
  keymap("n" , "<space>wl"  , "print(vim.inspect(vim.lsp.buf.list_workspace_folders()))")
  keymap("n" , "<space>D"   , "vim.lsp.buf.type_definition()")
  keymap("n" , "<space>rn"  , "vim.lsp.buf.rename()")
  keymap("n" , "gr"         , "vim.lsp.buf.references()")
  keymap("n" , "<space>e"   , "vim.lsp.diagnostic.show_line_diagnostics()")
  keymap("n" , "[d"         , "vim.lsp.diagnostic.goto_prev()")
  keymap("n" , "]d"         , "vim.lsp.diagnostic.goto_next()")
  keymap("n" , "<space>q"   , "vim.lsp.diagnostic.set_loclist()")
  keymap("n" , "<leader>ca" , "vim.lsp.buf.code_action()")
  if client.resolved_capabilities.document_formatting then
  keymap("n" , "<space>f"   , "vim.lsp.buf.formatting()")
  end
end

-- Typescript
nvim_lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    -- Prevent tsserver from formatting; Use prettier instead
    client.resolved_capabilities.document_formatting = false

    require'completion'.on_attach(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- =============================================================================
-- EFM
-- =============================================================================

local prettier = {
  formatCommand = ([[
  npx prettier
  --stdin-filepath
  ${INPUT}
  ]]):gsub("\n", ""),
  formatStdin = true
}
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true,
}

local languages = {
  typescript = {prettier, eslint},
  javascript = {prettier, eslint},
  json = {prettier},
  html = {prettier},
  scss = {prettier},
  css = {prettier}
}
local rootMarkers = { ".eslintrc.json", "package.json", ".git" }

nvim_lsp.efm.setup {
  init_options = {
    documentFormatting = true,
    codeAction = true,
    documentSymbol = true,
    lint = true
  },
  root_dir = nvim_lsp.util.root_pattern(unpack(rootMarkers)),
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = rootMarkers,
    languages = languages
  },
  on_attach = on_attach,
  cmd = {"efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "10"}
}

nvim_lsp.angularls.setup{}
