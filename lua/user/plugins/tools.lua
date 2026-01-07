return {
    {
        -- Commands "Colortils*"
        -- https://github.com/max397574/colortils.nvim
        "max397574/colortils.nvim",
        cmd = "Colortils",
        opts = {
        },
        config = function(_, opts)
            require("colortils").setup(opts)
        end,
        keys = {
            { "<leader>oc", "<cmd>Colortils<cr>", desc = "Colortils" },
        },
    },


    {
        -- Commands "Diff*"
        -- https://github.com/sindrets/diffview.nvim
        'sindrets/diffview.nvim'
    },


    {
        -- Command "Gitsigns *"
        -- https://github.com/lewis6991/gitsigns.nvim
        'lewis6991/gitsigns.nvim',
        event = "BufReadPre",
        config = function(_, opts)
            require("gitsigns").setup(opts)
            vim.keymap.set('n', '<leader>gp', ":Gitsigns preview_hunk_inline<CR>", {})
        end,
        keys = {
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",      desc = "Stage Hunk" },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",      desc = "Reset Hunk" },
            { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>",    desc = "Preview Hunk" },
            { "<leader>gb", "<cmd>Gitsigns blame_line<cr>",      desc = "Blame Line" },
            { "<leader>gd", "<cmd>Gitsigns diffthis<cr>",        desc = "Diff This File" },
        },
    },


    {
        -- Commands "YAML*"
        -- https://github.com/cuducos/yaml.nvim
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        keys = {
            { "<leader>fy", "<cmd>YAMLTelescope<cr>", desc = "Search YAML keys" }
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
        },
    },


    {
        -- Commands "PasteImage" or "Img*"
        -- https://github.com/HakonHarnes/img-clip.nvim
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            -- add options here
            -- or leave it empty to use the default settings
        },
        keys = {
            -- suggested keymap
            { "<leader>op", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
    },


    {
        -- https://github.com/vimwiki/vimwiki
        'vimwiki/vimwiki',
        init = function()
            --vim.g.vimwiki_auto_chdir = 1 -- # it's doing :lcd - tho I need :tcd - MAKE THAT PR HAPPEN
            vim.g.vimwiki_global_ext = 0
            vim.g.vimwiki_ext2syntax = {
                [".md"] = "markdown",
                [".markdown"] = "markdown",
                [".mdown"] = "markdown",
            }
            vim.g.vimwiki_list = {
                {
                    path = '~/data/notes/',
                    syntax = 'markdown',
                    ext = '.md'
                }
            }
        end,
        config = function(_, opts)
            --vim.keymap.set('n', '<leader>ww', [[:tcd ~/vimwiki/<CR>]], opts)
            vim.keymap.set('n', '<leader>ww', ':VimwikiIndex<CR>:tcd ~/data/notes<CR>', opts)
            --vim.keymap.set('n', '<leader>ww', '<Plug>VimwikiIndex :tcd ~/data/notes<CR>', opts)
        end,

    },


    {
        -- Press ENTER to open links in .md or .tex
        -- https://github.com/jghauser/follow-md-links.nvim
        'jghauser/follow-md-links.nvim'
    },


    {
        -- Commands "Markdown*"
        -- https://github.com/iamcco/markdown-preview.nvim
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        --config = true -- idk it just sopped working if it was uncommented
    },


    {
        -- Command "Org"
        -- https://github.com/nvim-orgmode/orgmode
        'nvim-orgmode/orgmode',
        enabled = false,
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/orgmode/*.org',
                org_default_notes_file = '~/orgmode/refile.org',
                org_capture_templates = {
                    t = {
                        description = 'Todo',
                        template = '* TODO %?\n%u',
                        target = '~/orgmode/todo.org'
                    },
                    j = {
                        description = 'Journal',
                        template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
                        target = '~/orgmode/journal.org'
                    },
                    J = {
                        description = 'Journal foldered months',
                        template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
                        target = '~/orgmode/journal/%<%Y-%m>.org'
                    },
                }
            })

            -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
            -- add ~org~ to ignore_install
            -- require('nvim-treesitter.configs').setup({
            --   ensure_installed = 'all',
            --   ignore_install = { 'org' },
            -- })
        end,
    },


    {
        -- Commands "Session*"
        -- https://github.com/rmagatti/auto-session
        'rmagatti/auto-session',
        dependencies = {
            'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
        },
        keys = {
            { "<leader>fs", "<cmd>AutoSession search<cr>", desc = "Search sessions (Telescope)" },
        },
        config = function()
            require('auto-session').setup({
                auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            })
        end,
    },


    {
        -- Commands "Sops*"
        -- https://github.com/lucidph3nx/nvim-sops
        'lucidph3nx/nvim-sops',
        event = { 'BufEnter' },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            { "<leader>ose", "<cmd>SopsEncrypt<cr>", desc = "Encrypt file with Sops" },
            { "<leader>osd", "<cmd>SopsDecrypt<cr>", desc = "Decrypt file with Sops" },
        },
    },

    {
        -- https://github.com/apayu/nvim-ansible-vault
        'apayu/nvim-ansible-vault',
        config = function()
            --require("ansible-vault").setup({
            --vault_identities = {
            --    "dev@.vault_pass_dev",
            --    "prod@./get_prod_password.sh"
            --}
            --})
            require("ansible-vault").setup({
                vault_password_files = { '.vault_pass', '.vault-pass' },
                --vault_id = 'default',
                patterns = {
                    "*/host_vars/*/vault.yml",  -- Default: host variables vault files
                    "*/group_vars/*/vault.yml", -- Default: group variables vault files
                    "*/host_vars/*/crypted",    -- Default: host variables vault files
                    "*/group_vars/*/crypted",   -- Default: group variables vault files
                    "*/vault.yml",              -- Any vault.yml file
                    "*/secrets/*.yml",          -- Any .yml file in secrets directories
                    "*/encrypted/*"             -- Any file in encrypted directories
                }
            })
        end,
        event = "BufReadPre */crypted",
    }
}
