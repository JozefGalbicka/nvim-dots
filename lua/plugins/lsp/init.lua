return {
    {
        -- https://github.com/neovim/nvim-lspconfig
        -- LIST OF ARCH LSP PACKAGES - https://wiki.archlinux.org/title/Language_Server_Protocol
        -- EXAMPLE CONFIGS - https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require('lspconfig')

            local configs = require('plugins.lsp.configs')
            for lsp, config in pairs(configs) do
                lspconfig[lsp].setup(config)
            end

            -- Diagnostics.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open diagnostics" })
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "goto prev diagnostic" })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "goto next diagnostic" })
            vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "diagnostic set locallist" }) -- CHECK WHAT THIS ONE EVEN DOES, originally mapped to <leader>q
            -- end

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    --
                    -- Goto
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "goto Declaration" }))
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "goto Definition" }))
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "goto Type Definition" }))
                    -- List
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "list Implementations" }))
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "list References" }))
                    -- Show
                    vim.keymap.set('n', '<C-S-j>', vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "show Hover info" }))
                    vim.keymap.set('n', '<C-S-k>', vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "show Signature help" })) -- originally <C-k>
                    -- Workspaces
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "workspace - Add folder" }))
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "workspace - Remove folder" }))
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, vim.tbl_extend("force", opts, { desc = "workspace - List folders" }))
                    -- Rename
                    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename - LSP" })) -- originally <leader>rn
                    -- Code interaction
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
                    vim.keymap.set('n', '<leader>cf', function()
                        vim.lsp.buf.format { async = true }
                    end, vim.tbl_extend("force", opts, { desc = "Code Format" }))
                end,
            })
        end,
    },


    -- doesn't fucking work
    --{
    --    "msvechla/yaml-companion.nvim",
    --    ft = { "yaml" },
    --    dependencies = {
    --        { "neovim/nvim-lspconfig" },
    --        { "nvim-lua/plenary.nvim" },
    --        { "nvim-telescope/telescope.nvim" },
    --    },
    --    config = function(_, opts)
    --        local cfg = require("yaml-companion").setup(opts)
    --        require("lspconfig")["yamlls"].setup(cfg)
    --        require("telescope").load_extension("yaml_schema")
    --    end,
    --},
    --


    {
        -- Better autocompletion for Lua NVIM configs
        -- https://github.com/folke/lazydev.nvim
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },


    {
        -- Snippet engine
        -- https://github.com/L3MON4D3/LuaSnip
        'L3MON4D3/LuaSnip',
        dependencies = {
            { "rafamadriz/friendly-snippets" }
        },
        opts = {},
        config = function(_, opts)
            local ls = require("luasnip")
            ls.setup(opts)
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },


    {
        -- Command "CmpStatus"
        -- https://github.com/hrsh7th/nvim-cmp
        'hrsh7th/nvim-cmp',
        dependencies = { { 'hrsh7th/cmp-nvim-lsp' },   -- Completion sources for LSP
            { 'saadparwaiz1/cmp_luasnip' },            -- Completion sources LuaSnip
            { 'hrsh7th/cmp-path' },                    -- Completion from file paths
            { 'hrsh7th/cmp-buffer' },                  -- Completion from buffer
            { "kdheepak/cmp-latex-symbols" },          -- Completion for special characters (start with '\')
            { 'hrsh7th/cmp-nvim-lsp-signature-help' }, -- Display function signatures
            {
                -- Autopair
                'windwp/nvim-autopairs', -- https://github.com/windwp/nvim-autopairs
                event = "InsertEnter",
                config = true
                -- use opts = {} for passing setup options
                -- this is equalent to setup({}) function
            }
        },
        opts = {},
        config = function(_, opts)
            --require('cmp').setup(opts)

            local luasnip = require 'luasnip'

            --- If you want insert `(` after select function or method item
            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
                    -- C-b (back) C-f (forward) for snippet placeholder navigation.
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'latex_symbols' },
                    { name = 'buffer' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'orgmode' },
                    { name = 'lazydev',                group_index = 0 }
                },
            }


            -- IS THIS NECESSARY? -- https://github.com/windwp/nvim-autopairs
            -- idk didn't work with typescript last time i checked
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    },

    {
        -- https://github.com/rcarriga/nvim-dap-ui
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function(_, opts)
            require("dapui").setup(opts)

            local dap = require("dap")
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-i", "dap" }
            }
            local dap = require("dap")
            dap.configurations.c = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }
        end,
    },
}
