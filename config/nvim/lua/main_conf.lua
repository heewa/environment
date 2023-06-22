function HeewaConf_OnLspAttach(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

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
    local lsp_servers = {'tsserver', 'zls'}
    local ret, lspconfig = pcall(require, 'lspconfig')
    if ret then
        for _, lsp_server in ipairs(lsp_servers) do
            lspconfig[lsp_server].setup{
                on_attach = HeewaConf_OnLspAttach,
            }
        end
    end

    local ret, lsp_progress = pcall(require, 'lsp-progress')
    if ret then
        lsp_progress.setup()
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

    local ret, rt = pcall(require, 'rust-tools')
    if ret then
        rt.setup({
            server = {
                on_attach = function(_, bufnr)
                    -- Hover actions
                    vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                    -- Code action groups
                    vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                end,
            },
        })
    end

end
