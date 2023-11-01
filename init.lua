-- disable netrw in favor of nvim-tree at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
    -- Some defaults
    "folke/which-key.nvim",
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",

    -- Fancy look incoming alert 
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true},
    { "vim-airline/vim-airline-themes"},

    { 
        "nvim-tree/nvim-tree.lua",
        cmd = "NvimTreeToggle",
        config = true
    },

    {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        'NvChad/nvim-colorizer.lua',
        config = true
    },
    { "max397574/colortils.nvim",
        cmd = "Colortils",
        config = true
    },
    'vim-airline/vim-airline',
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        --cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        opts = {
            highlight = { enable = true },
            indent = { enable = false },
            ensure_installed = {
                "terraform",
                "hcl",
                --"bash",
                --"c",
                --"diff",
                --"html",
                --"javascript",
                --"jsdoc",
                --"json",
                --"jsonc",
                --"lua",
                --"luadoc",
                --"luap",
                --"markdown",
                --"markdown_inline",
                --"python",
                --"query",
                --"regex",
                --"toml",
                --"tsx",
                --"typescript",
                --"vim",
                --"vimdoc",
                --"yaml",
            },
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
        end,
    },

    'neovim/nvim-lspconfig',

    -- nvim-cmp itself
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip', -- Snippet engine

            -- Completion sources for nvim-cmp
            'hrsh7th/cmp-nvim-lsp',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-path',
        }
    },

    {
        'vimwiki/vimwiki',
        init = function()
            vim.g.vimwiki_list = {
                {
                    path = '~/vimwiki/',
                    syntax = 'markdown',
                    ext = '.md'
                }
            }  
        end
    }
})

--require'lspconfig'.pyright.setup{}
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require('lspconfig')
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
--local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
local servers = { 'pyright', 'clangd', 'terraformls' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        -- on_attach = my_custom_on_attach,
        capabilities = capabilities,
    }
end
local luasnip = require 'luasnip'

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.wo.number = true

vim.cmd.colorscheme "gruvbox"
vim.cmd.AirlineTheme "base16_gruvbox_dark_medium"
--vim.g.airline_theme= "catppuccin"
--vim.cmd.colorscheme "catppuccin"
--require'nvim-tree'.setup {}
--require 'colorizer'.setup {}

-- TELESCOPE
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- end

-- COPY/PASTE TO CLIPBOARD REGISTER
vim.keymap.set('v', '<C-c>', [["+yi<ESC>]], {})
vim.keymap.set('v', '<C-x>', [["+c<ESC>]], {})
vim.keymap.set('v', '<C-v>', [[c<ESC>"+p]], {})
vim.keymap.set('i', '<C-v>', [[<ESC>"+pa]], {})
-- end

-- NvimTree
vim.keymap.set('n', '<C-n>', vim.cmd.NvimTreeToggle, {})
vim.keymap.set('n', '<leader>r', function() vim.cmd.ToggleTerm("direction=float") end, {})
-- end 

local function run_curr_python_file()
    -- Get file name in the current buffer
    local file_name = vim.api.nvim_buf_get_name(0)

    -- Get terminal codes for running python file
    -- ("i" to enter insert before typing rest of the command)
    local py_cmd = vim.api.nvim_replace_termcodes("ipython \"" .. file_name .. "\"<cr>", true, false, true)

    -- Determine terminal window split and launch terminal
    local percent_of_win = 0.4
    local curr_win_height = vim.api.nvim_win_get_height(0) -- Current window height
    local term_height = math.floor(curr_win_height * percent_of_win) -- Terminal height
    --vim.cmd(":below " .. term_height .. "split | term") -- Launch terminal (horizontal split)
    vim.cmd.ToggleTerm "direction=float"

    -- Press keys to run python command on current file
    vim.api.nvim_feedkeys(py_cmd, "t", false)
end

vim.keymap.set({'n'}, '<A-r>', '', { 
    desc = "Run .py file via Neovim built-in terminal", 
    callback = run_curr_python_file
})

function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- nvim-cmp setup
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
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
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
    },
}

-- Trash shelf for the disobedient ones
--vim.api.nvim_set_option("clipboard","unnamed")
