return {
    {
        "max397574/colortils.nvim",
        cmd = "Colortils",
        config = true
    },
    {
        'sindrets/diffview.nvim'
    },
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
        },
    },
    {
        -- https://github.com/HakonHarnes/img-clip.nvim
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            -- add options here
            -- or leave it empty to use the default settings
        },
        keys = {
            -- suggested keymap
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
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
        'jghauser/follow-md-links.nvim'
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        --config = true -- idk it just sopped working if it was uncommented
    },
    {
        'nvim-orgmode/orgmode',
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
        -- https://github.com/rmagatti/auto-session
        'rmagatti/auto-session',
        dependencies = {
            'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
        },
        config = function()
            require('auto-session').setup({
                auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            })
        end,
    },
    {
        'lucidph3nx/nvim-sops',
        event = { 'BufEnter' },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }
}
