return {
    -- Fancy look incoming alert
    {
        -- https://github.com/catppuccin/nvim
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require('catppuccin').setup()
            --vim.cmd.colorscheme "catppuccin"
        end,
    },


    {
        -- https://github.com/ellisonleao/gruvbox.nvim
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require('gruvbox').setup()
            vim.cmd.colorscheme "gruvbox"
        end,
    },


    {
        -- https://github.com/nvim-lualine/lualine.nvim
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            extensions = {
                'toggleterm'
            },
            sections = {
                lualine_x = { 'encoding', 'fileformat', 'filetype', get_schema },
            },
        },
        -- https://www.arthurkoziel.com/json-schemas-in-neovim/
        config = function(_, opts)
            function _G.get_schema()
                local schema = require("yaml-companion").get_buf_schema(0)
                if schema.result[1].name == "none" then
                    return ""
                end
                return schema.result[1].name
            end

            require("lualine").setup(opts)
        end,
    },


    {
        -- https://github.com/catgoose/nvim-colorizer.lua
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {
            user_default_options = {
                names = false,
            }
        }
    },
    {
        -- Command "Gitsign *"
        -- https://github.com/lewis6991/gitsigns.nvim
        'lewis6991/gitsigns.nvim',
        config = function(_, opts)
            require("gitsigns").setup(opts)
            vim.keymap.set('n', '<leader>gp', ":Gitsigns preview_hunk_inline<CR>", {})
        end,
    },
}
