return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        --cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        opts = {
            highlight = { enable = true },
            indent = { enable = false },
            ensure_installed = {
                "terraform",
                "hcl",
                "bash",
                "c",
                --"diff",
                "doxygen",
                --"html",
                --"javascript",
                --"jsdoc",
                "json",
                --"jsonc",
                "lua",
                --"luadoc",
                --"luap",
                "markdown",
                "markdown_inline",
                "python",
                --"query",
                --"regex",
                --"toml",
                --"tsx",
                "typescript",
                "vim",
                --"vimdoc",
                "yaml",
                "make",
                "helm",
            },
            ignore_install = { 'org' },
            --incremental_selection = {
            --  enable = true,
            --  keymaps = {
            --    init_selection = "<C-space>",
            --    node_incremental = "<C-space>",
            --    scope_incremental = false,
            --    node_decremental = "<bs>",
            --  },
            --},
            --textobjects = {
            --  move = {
            --    enable = true,
            --    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            --    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            --    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            --    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
            --  },
        },
        ---@param opts TSConfig
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)
            -- THIS ONE IS CUSTOM
            vim.treesitter.language.register('markdown', 'vimwiki')
            --\ THIS ONE IS CUSTOM
        end,
    },
    {
        -- https://github.com/MeanderingProgrammer/render-markdown.nvim
        'MeanderingProgrammer/markdown.nvim',
        main = "render-markdown",
        opts = {
            heading = {
                sign = false,
                --backgrounds = {
                --    'DiffAdd',
                --}
            }
        },
        name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        config = function(_, opts)
            require('render-markdown').setup(opts)
            vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { fg = '#cb7676', bg = '#402626', italic = false })
            vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { fg = '#c99076', bg = '#66493c', italic = false })
            vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { fg = '#80a665', bg = '#3d4f2f', italic = false })
            vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { fg = '#4c9a91', bg = '#224541', italic = false })
            vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { fg = '#6893bf', bg = '#2b3d4f', italic = false })
            vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { fg = '#d3869b', bg = '#6b454f', italic = false })
        end
    },
}
