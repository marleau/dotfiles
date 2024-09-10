-- auto-install vim-plug

local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
    vim.cmd('silent !curl -fLo ' ..
        data_dir ..
        '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    -- workaround to reset runtimepath so `PlugInstall` will run
    -- https://github.com/junegunn/vim-plug/issues/1270#issuecomment-2148655528
    vim.opt.runtimepath = vim.opt.runtimepath
    vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

-- install plugins

local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug('Rigellute/rigel')
Plug('epwalsh/obsidian.nvim') -- XXX: On trial
Plug('junegunn/fzf', { ['do'] = function() vim.fn['fzf#install']() end })
Plug('junegunn/fzf.vim')
Plug('mbbill/undotree')
Plug('neovim/nvim-lspconfig')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = function() vim.fn[':TSUpdate']() end })
Plug('stevearc/conform.nvim')
Plug('tpope/vim-commentary')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-surround')

vim.call('plug#end')

-- settings

vim.opt.syntax = 'enable'
vim.opt.termguicolors = true
vim.cmd("colorscheme rigel")
vim.opt.nu = true       -- Show current line number
vim.opt.rnu = true      -- Show relative line numbers
vim.opt.tabstop = 4     -- Number of spaces that represents tab
vim.opt.softtabstop = 4 -- Number of spaces that represents tab during editing
vim.opt.shiftwidth = 4  -- Number of spaces inserted for indenting
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.directory = data_dir .. "/tmp" -- Put swap files in temp dir
vim.opt.backupdir = data_dir .. "/tmp" -- Put backup files in temp dir

-- keymaps

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>vv', function() vim.cmd('edit $MYVIMRC') end)
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<c-p>', ":GFiles --exclude-standard --cached --others<cr>")
vim.keymap.set('n', '<leader>pf', vim.cmd.Files)
vim.keymap.set('n', '<leader>vh', vim.cmd.Helptags)
vim.keymap.set('n', '<leader>pws', function()
    local word = vim.fn.expand('<cword>')
    vim.cmd('Rg ' .. word)
end)
vim.keymap.set('n', '<leader>pWs', function()
    local word = vim.fn.expand('<cWORD>')
    vim.cmd('Rg ' .. word)
end)
vim.keymap.set('n', '<leader>ps', vim.cmd.Rg)
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- auto commands

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = 'Highlight when yanking',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end
})
vim.cmd("autocmd FileType make setlocal noexpandtab softtabstop=0")


-- treesitter

require('nvim-treesitter.configs').setup({
    ensure_installed = { "javascript", "typescript", "bash", "json", "c", "lua", "luadoc", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = { enable = true }
})

-- conform.vim

require('conform').setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        svelte = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
    },
    format_on_save = {
        lsp_fallback = true
    }
})

-- lsp

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(args)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Mappings
        local bufopts = { noremap = true, silent = true, buffer = args.buf }
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
        -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, bufopts)
        vim.keymap.set('n', '<space>f', function() require('conform').format({ async = true, lsp_fallback = true }) end,
            bufopts)
    end
})

require('lspconfig').lua_ls.setup({
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        })
    end,
    settings = {
        Lua = {}
    }
})

require('lspconfig').angularls.setup({
    root_dir = require('lspconfig').util.root_pattern('angular.json', 'project.json')
})

require('lspconfig').tsserver.setup({})

require('lspconfig').cssls.setup({
    settings = {
        scss = {
            lint = {
                unknownAtRules = "ignore"
            }
        }
    }
})

require('lspconfig').svelte.setup({})

require('lspconfig').eslint.setup({
    settings = { format = false }
})
