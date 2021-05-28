local utils = require('lv-utils')

local auto_formatters = {            }

local python_autoformat = {'BufWritePre', '*.py', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.python.autoformat then table.insert(auto_formatters, python_autoformat) end

local javascript_autoformat = {'BufWritePre', '*.js', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
local javascriptreact_autoformat = {'BufWritePre', '*.jsx', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
local typescript_autoformat = {'BufWritePre', '*.ts', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
local typescriptreact_autoformat = {'BufWritePre', '*.tsx', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.tsserver.autoformat then
    table.insert(auto_formatters, javascript_autoformat)
    table.insert(auto_formatters, javascriptreact_autoformat)
	table.insert(auto_formatters, typescript_autoformat)
	table.insert(auto_formatters, typescriptreact_autoformat)
end

local lua_format = {'BufWritePre', '*.lua', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.lua.autoformat then table.insert(auto_formatters, lua_format) end

local json_format = {'BufWritePre', '*.json', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.json.autoformat then table.insert(auto_formatters, json_format) end

local ruby_format = {'BufWritePre', '*.rb', 'lua vim.lsp.buf.formatting_sync(nil,1000)'}
if O.ruby.autoformat then table.insert(auto_formatters, ruby_format) end

local vue_format = {'BufWritePre', '*.vue', 'lua vim.lsp.buf.formatting_sync(nil,1000)'}
if O.vue.autoformat then table.insert(auto_formatters, vue_format) end

function goimports(timeoutms)
    local context = {source = {organizeImports = true}}
    vim.validate {context = {context, "t", true}}

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    if result[1] == nil then return end 
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
        if action.edit then vim.lsp.util.apply_workspace_edit(action.edit) end
        if type(action.command) == "table" then vim.lsp.buf.execute_command(action.command) end
    else
        vim.lsp.buf.execute_command(action)
    end
end

local go_imports = {'BufWritePre', '*.go', 'lua goimports(1000)'}
if O.go.autoformat then table.insert(auto_formatters, go_imports) end

local go_format = {'BufWritePre', '*.go', 'lua vim.lsp.buf.formatting_sync(nil,1000)'}
if O.go.autoformat then table.insert(auto_formatters, go_format) end

utils.define_augroups({
    _general_settings = {
        {'TextYankPost', '*', 'lua require(\'vim.highlight\').on_yank({higroup = \'Search\', timeout = 200})'},
        {'BufWinEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufRead', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufNewFile', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'VimLeavePre', '*', 'set title set titleold='}

        -- {'User', 'GoyoLeave', 'lua require(\'galaxyline\').disable_galaxyline()'},
        -- {'User', 'GoyoEnter', 'lua require(\'galaxyline\').galaxyline_augroup()'},
    },
    _java = {
        {'FileType', 'java', 'luafile '..CONFIG_PATH..'/lua/lsp/java-ls.lua'},
        {'FileType', 'java', 'nnoremap ca <Cmd>lua require(\'jdtls\').code_action()<CR>'}
    },
    _go = {
        -- Go generally requires Tabs instead of spaces.
        {'FileType', 'go', 'setlocal tabstop=4'},
        {'FileType', 'go', 'setlocal shiftwidth=4'},
        {'FileType', 'go', 'setlocal softtabstop=4'},
        {'FileType', 'go', 'setlocal noexpandtab'},
    },
    _dashboard = {
        -- seems to be nobuflisted that makes my stuff disapear will do more testing
        {
            'FileType', 'dashboard',
            'setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= '
        }, {'FileType', 'dashboard', 'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=2'}
    },
    _markdown = {{'FileType', 'markdown', 'setlocal wrap'}, {'FileType', 'markdown', 'setlocal spell'}},
    _solidity = {
        {'BufWinEnter', '.sol', 'setlocal filetype=solidity'}, {'BufRead', '*.sol', 'setlocal filetype=solidity'},
        {'BufNewFile', '*.sol', 'setlocal filetype=solidity'}
    },
    _gemini = {
        {'BufWinEnter', '.gmi', 'setlocal filetype=markdown'}, {'BufRead', '*.gmi', 'setlocal filetype=markdown'},
        {'BufNewFile', '*.gmi', 'setlocal filetype=markdown'}
    },
    _buffer_bindings = {
        {'FileType', 'dashboard', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'lspinfo', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'floaterm', 'nnoremap <silent> <buffer> q :q<CR>'},
    },
    _auto_formatters = auto_formatters
})
