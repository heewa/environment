function HeewaConf_OnLspAttach(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })
end

function HeewaConf_PostPlugins()
    local ret, lspconfig = pcall(require, 'lspconfig')
    if ret then
        lspconfig['tsserver'].setup{
            on_attach = HeewaConf_OnLspAttach,
        }
    end

    local ret, gitsigns = pcall(require, 'gitsigns')
    if ret then
        gitsigns.setup({
        })
    end

    local ret, neogit = pcall(require, 'neogit')
    if ret then
        neogit.setup({
            kind='split',
            sections = {
                stashes = { folded = false },
                recent = { folded = false }
            }
        })
    end
end
