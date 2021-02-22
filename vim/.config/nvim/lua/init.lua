vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            underline = true,
            update_in_insert = false
        }
    )(...)
    pcall(vim.lsp.diagnostic.set_loclist, {open_loclist = false})
end


vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.cmd [[noautocmd :update]]
        end
    end
end

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

  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
        {
          underline = true,
          update_in_insert = false
        }
    )(...)
    pcall(vim.lsp.diagnostic.set_loclist, {open_loclist = false})
  end

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
  keymap("n" , "<space>f"   , "vim.lsp.buf.formatting()")
  keymap("n" , "<leader>ca" , "vim.lsp.buf.code_action()")
end

-- Typescript
nvim_lsp.tsserver.setup {
  on_attach = on_attach
}

-- =============================================================================
-- EFM
-- =============================================================================

local prettier = {
  formatCommand = ([[
    npx prettier
  ]]):gsub("\n", "")
}
local tslint = {
  -- formatCommand = ([[
  --   npx tslint --fix
  -- ]]):gsub("\n", ""),
  lintCommand = ([[
    npx tslint
  ]]):gsub("\n", ""),
  lintIgnoreExitCode = true,
  lintStdin = true
}

local languages = {
  typescript = {prettier, tslint},
  javascript = {prettier},
}

nvim_lsp.efm.setup {
  init_options = { documentFormatting = true, lint = true },
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git", "package.json" },
    languages = languages
  }
}
