return {
    {
        -- https://github.com/neovim/nvim-lspconfig
        -- https://wiki.archlinux.org/title/Language_Server_Protocol
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require('lspconfig')

            -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
            local servers = { 'pyright', 'clangd', 'terraformls', 'ts_ls', 'bashls', 'helm_ls' }
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup {
                    -- on_attach = my_custom_on_attach,
                    capabilities = capabilities,

                }
            end

            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
                            return
                        end
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
                                vim.env.VIMRUNTIME,
                                -- Depending on the usage, you might want to add additional paths here.
                                "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                            --library = vim.api.nvim_get_runtime_file("", true)
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            }



            -- debug
            -- :lua print(vim.inspect(vim.lsp.get_active_clients()))
            lspconfig.yamlls.setup({
                --capabilities = capabilities
                capabilities = {
                    textDocument = {
                        foldingRange = {
                            dynamicRegistration = false,
                            lineFoldingOnly = true,
                        },
                    },
                },
                -- stolen from here
                -- https://github.com/Allaman/nvim/blob/main/lua/vnext/plugins/completion.lua
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = true,
                            url = "https://www.schemastore.org/api/json/catalog.json",
                        },
                        format = { enabled = false },
                        -- enabling this conflicts between Kubernetes resources, kustomization.yaml, and Helmreleases
                        validate = false,
                        schemas = {
                            kubernetes = "*.yaml",
                            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] = "roles/tasks/*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*play*.{yml,yaml}",
                            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                            ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                        },

                        customTags = {
                            "!fn",
                            "!And",
                            "!If",
                            "!If sequence",
                            "!Not",
                            "!Not sequence",
                            "!Equals",
                            "!Equals sequence",
                            "!Or",
                            "!Or sequence",
                            "!FindInMap sequence",
                            "!Base64",
                            "!Cidr",
                            "!Ref Scalar",
                            "!Sub",
                            "!Sub sequence",
                            "!GetAtt",
                            "!GetAZs",
                            "!ImportValue",
                            "!Select",
                            "!Split",
                            "!Join sequence"
                        },
                    }
                },
            })
                    --yaml = {
                    --    validate = true,
                    --    ---- disable the schema store
                    --    schemaStore = {
                    --      enable = false,
                    --      url = "",
                    --    },
                    --    ---- manually select schemas
                    --    --schemas = {
                    --    --  ['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
                    --    --  ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
                    --    --  ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "argocd-application.yaml",
                    --    --}
                    --    schemas = {
                    --        kubernetes = "*.yaml",
                    --        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                    --        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                    --        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                    --        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                    --        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                    --        ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                    --        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                    --        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                    --        ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                    --        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                    --        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                    --        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                    --    },

                    --    --schemaStore = {
                    --    --    --url = "https://www.schemastore.org/api/json/catalog.json",
                    --    --    enable = true
                    --    --},
                    --    --format = {
                    --    --    enable = false,
                    --    --},
                    --    --hover = true,
                    --    --completion = true,


            -- Diagnostics.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {desc="Open diagnostics"}) vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc="goto prev diagnostic"})
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc="goto next diagnostic"})
            vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist, {desc = "diagnostic set locallist"}) -- CHECK WHAT THIS ONE EVEN DOES, originally mapped to <leader>q
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
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {desc="goto Declaration"}))
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend("force", opts, {desc="goto Definition"}))
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, {desc="goto Type Definition"}))
                    -- List
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend("force", opts, {desc="list Implementations"}))
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend("force", opts, {desc="list References"}))
                    -- Show
                    vim.keymap.set('n', '<C-S-j>', vim.lsp.buf.hover, vim.tbl_extend("force", opts, {desc="show Hover info"}))
                    vim.keymap.set('n', '<C-S-k>', vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, {desc="show Signature help"})) -- originally <C-k>
                    -- Workspaces
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, {desc="workspace - Add folder"}))
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, {desc="workspace - Remove folder"}))
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, vim.tbl_extend("force", opts, {desc="workspace - List folders"}))
                    -- Rename
                    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend("force", opts, {desc="Rename - LSP"})) -- originally <leader>rn
                    -- Code interaction
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {desc="Code Action"}))
                    vim.keymap.set('n', '<leader>cf', function()
                        vim.lsp.buf.format { async = true }
                    end, vim.tbl_extend("force", opts, {desc="Code Format"}))
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

    {
        -- Snippet engine
        'L3MON4D3/LuaSnip', -- https://github.com/L3MON4D3/LuaSnip
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
        'hrsh7th/nvim-cmp',                            -- https://github.com/hrsh7th/nvim-cmp
        dependencies = { { 'hrsh7th/cmp-nvim-lsp' },                -- Completion sources for LSP
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
