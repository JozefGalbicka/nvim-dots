local capabilities = require("cmp_nvim_lsp").default_capabilities()

local configs = {
    gopls = {},
    pyright = {},
    clangd = {},
    terraformls = {},
    ts_ls = {},
    bashls = {},
    helm_ls = {},
    lua_ls = {
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
    },



    -- debug
    -- :lua print(vim.inspect(vim.lsp.get_active_clients()))
    --lspconfig.yamlls.setup({
    yamlls = {
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
                format = {
                    enable = true
                },
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
    }
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

}

return configs
