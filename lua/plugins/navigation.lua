return {
    {
        -- Commands "ToggleTerm*" and "Term*"
        -- https://github.com/akinsho/toggleterm.nvim
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            autochdir = true,
            persist_mode = false,
            open_mapping = [[<leader>r]],
            insert_mappings = false,
            terminal_mappings = false,
            direction = 'float',
            on_open = function(term)
                print(term.id)
                vim.cmd(term.id .. "ToggleTermSetName Term " .. term.id)
            end,

            --hide_numbers = false
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            function _G.set_terminal_keymaps()
                local opt = { buffer = 0 }
                vim.keymap.set('t', '<C-q>', vim.cmd.ToggleTerm, opt)
                --vim.api.nvim_set_keymap("t", "<C-e>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
                --vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opt)
                --vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opt)
                vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opt)
                vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opt)
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opt)
                vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opt)
                vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opt)
            end

            -- if you only want these mappings for toggle term use term://*toggleterm#* instead
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
            -- https://vi.stackexchange.com/questions/3670/how-to-enter-insert-mode-when-entering-neovim-terminal-pane
            --vim.cmd('autocmd! * term://* startinsert!')
            --vim.cmd('autocmd BufWinEnter,WinEnter term://* startinsert')
            --vim.cmd('autocmd TermOpen * if &buftype ==# "terminal" | resize 20 | vert resize 50 | endif')



            -- https://github.com/akinsho/toggleterm.nvim/issues/34
            local Terminal  = require('toggleterm.terminal').Terminal
            local buildterm = Terminal:new({
                --cmd = "lazygit",
                id = 8,
                --hidden = true,
                hidden = false,
                direction = "horizontal",
                on_open = function(term)
                    vim.cmd("startinsert!")
                end,
            })
            function _buildterm_toggle()
                buildterm:toggle()
            end

            vim.keymap.set("n", "<leader>q", "<cmd>lua _buildterm_toggle()<CR>",
                { noremap = true, silent = true, desc = "open lower term" })
            -- end

            --vim.keymap.set('n', '<leader>r', function() vim.cmd.ToggleTerm("direction='float'") end,
            --    { desc = "Open float term" })
        end
    },


    {
        -- Commands "Tabby *"
        -- https://github.com/nanozuki/tabby.nvim
        'nanozuki/tabby.nvim',
        event = 'VimEnter',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {},
        config = function(_, opts)
            require("tabby").setup(opts)
            -- TABBY MAPPINGS
            vim.keymap.set('n', '<leader>ta', ':tabnew<CR>', { noremap = true, desc = "tab add" })
            vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { noremap = true, desc = "tab close" })
            vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { noremap = true, desc = "tab only" })
            vim.keymap.set("n", "<leader>l", ":tabn<CR>", { noremap = true, desc = "tab next" })
            vim.keymap.set("n", "<leader>h", ":tabp<CR>", { noremap = true, desc = "tab previous" })
            vim.keymap.set("n", "<leader>tr", ":TabRename ", { noremap = true, desc = "tab rename" })
            -- move current tab to previous position
            vim.keymap.set("n", "<leader>tmh", ":-tabmove<CR>", { noremap = true, desc = "tab move left" })
            -- move current tab to next position
            vim.keymap.set("n", "<leader>tml", ":+tabmove<CR>", { noremap = true, desc = "tab move right" })
            -- end
        end,


    },


    {
        -- Command "WhichKey"
        -- https://github.com/folke/which-key.nvim
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = true
    },


    {
        -- Commands "Telescope *"
        -- https://github.com/nvim-telescope/telescope.nvim
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        config = function(_, opts)
            require("telescope").setup(opts)

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "FFile" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "FGrep" })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "FBuffers" })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "FTags" })
        end,
        dependencies = { 'nvim-lua/plenary.nvim' }
    },


    {
        -- Commands "NvimTree*"
        -- https://github.com/nvim-tree/nvim-tree.lua
        "nvim-tree/nvim-tree.lua",
        --cmd = "NvimTreeToggle",
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true
        end,
        opts = {
            sync_root_with_cwd = true,
            renderer = { -- https://github.com/nvim-tree/nvim-tree.lua/discussions/1921?sort=old
                root_folder_label = function(path)
                    path = path:gsub(os.getenv("HOME"), "~", 1)
                    return path:gsub("([a-zA-Z])[a-z]+", "%1") .. path:gsub(".*[^a-zA-Z].?", "")
                end,
            },
            tab = {
                sync = {
                    open = true,
                    close = true
                }
            }
        },
        --config = function(_, opts)
        --    require("nvim-tree").setup(opts)
        --end,
        keys = {
            { '<C-n>', "<cmd>NvimTreeToggle<cr>", desc = "NvimTreeToggleee" },
            -- OLD -- vim.keymap.set('n', '<C-n>', vim.cmd.NvimTreeToggle, {})
        }
    },
}
