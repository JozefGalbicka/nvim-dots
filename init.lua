-- https://stackoverflow.com/questions/75987806/why-is-my-neovim-plugin-not-loaded-despite-lazy-telling-me-it-is
-- https://github.com/wimstefan/dotfiles/blob/master/config/nvim/init.lua#L1313-L1454
--
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
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = true
    },

    -- Fancy look incoming alert
    { "catppuccin/nvim",          name = "catppuccin", priority = 1000 },
    { "ellisonleao/gruvbox.nvim", priority = 1000,     config = true },
    {
        "nvim-tree/nvim-tree.lua",
        cmd = "NvimTreeToggle",
        config = true
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                names = false,
            }
        }
    },
    {
        "max397574/colortils.nvim",
        cmd = "Colortils",
        config = true
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {}
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            autochdir = true
        }
    },
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
                --"markdown",
                --"markdown_inline",
                "python",
                --"query",
                --"regex",
                --"toml",
                --"tsx",
                --"typescript",
                "vim",
                --"vimdoc",
                "yaml",
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

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip', -- Snippet engine
            -- Completion sources for nvim-cmp
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-buffer' },
            { "kdheepak/cmp-latex-symbols" },
            --
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
    },

    {
        'sindrets/diffview.nvim'
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true
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
        'nanozuki/tabby.nvim',
        event = 'VimEnter',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {}
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    {
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
})


-----------------------------------------------------
----------- GENERAL
-----------------------------------------------------
--vim
vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting

vim.wo.number = true

vim.cmd.colorscheme "gruvbox"
--vim.cmd.colorscheme "catppuccin"
--require'nvim-tree'.setup {}
--require 'colorizer'.setup {}

vim.cmd('autocmd FileType yaml setlocal indentkeys-=0#')


-----------------------------------------------------
----------- PYTHON
-----------------------------------------------------
local function run_curr_python_file()
    -- Get file name in the current buffer
    local file_name = vim.api.nvim_buf_get_name(0)

    -- Get terminal codes for running python file
    -- ("i" to enter insert before typing rest of the command)
    local py_cmd = vim.api.nvim_replace_termcodes("ipython \"" .. file_name .. "\"<cr>", true, false, true)

    -- Determine terminal window split and launch terminal
    local percent_of_win = 0.4
    local curr_win_height = vim.api.nvim_win_get_height(0)           -- Current window height
    local term_height = math.floor(curr_win_height * percent_of_win) -- Terminal height
    --vim.cmd(":below " .. term_height .. "split | term") -- Launch terminal (horizontal split)
    vim.cmd.ToggleTerm "direction=float"

    -- Press keys to run python command on current file
    vim.api.nvim_feedkeys(py_cmd, "t", false)
end

vim.keymap.set({ 'n' }, '<A-r>', '', {
    desc = "Run .py file via Neovim built-in terminal",
    callback = run_curr_python_file
})

-----------------------------------------------------
----------- TOGGLETERM
-----------------------------------------------------
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
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


-----------------------------------------------------
----------- AUTOCOMPLETION
-----------------------------------------------------
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
-- Lua in neovim won't recognize 'vim' or 'require' variable and report them as undefined (Warnings)
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
}

local luasnip = require 'luasnip'

------------ nvim-cmp setup ------------
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
    },
}

-- Trash shelf for the disobedient ones
--vim.api.nvim_set_option("clipboard","unnamed")

-----------------------------------------------------
----------- SHORTCUTS
-----------------------------------------------------
vim.keymap.set('n', '<leader>s', '<c-w>', { noremap = true })

-- TELESCOPE
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "FFile" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "FGrep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "FBuffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "FTags" })
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

-- Building
vim.keymap.set('n', '<F2>', [[:TermExec cmd="%"<CR>]], opts)
vim.keymap.set('n', '<F3>', [[:TermExec cmd="sudo %"<CR>]], opts)
vim.keymap.set('n', '<F4>', [[:w <bar> !gcc % -o %:r<CR>]], opts)
vim.keymap.set('n', '<F5>', [[:wa <bar> make <CR>]], opts)
--vim.keymap.set('n', '<F5>',
--    [[:wa <bar> :set makeprg=cd\ build\ &&\ cmake\ -DCMAKE_BUILD_TYPE=debug\ -DCMAKE_EXPORT_COMPILE_COMMANDS=1\ ..\ &&\ cmake\ --build\ . <bar> :compiler gcc <bar> :make <CR>]],
--    opts)
--nnoremap <F5> :wa <bar> :set makeprg=cd\ build\ &&\ cmake\ -DCMAKE_BUILD_TYPE=debug\ -DCMAKE_EXPORT_COMPILE_COMMANDS=1\ ../view\ &&\ cmake\ --build\ . <bar> :compiler gcc <bar> :make <CR>
-- end

-- Diagnostics.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- end

-- LSP
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>cf', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
-- end

-- TABBY MAPPINGS
vim.keymap.set('n', '<leader>ta', ':tabnew<CR>', {noremap = true})
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.keymap.set("n", "<leader>l", ":tabn<CR>", { noremap = true })
vim.keymap.set("n", "<leader>h", ":tabp<CR>", { noremap = true })
vim.keymap.set("n", "<leader>tr", ":TabRename ", { noremap = true })
-- move current tab to previous position
vim.keymap.set("n", "<leader>tmh", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.keymap.set("n", "<leader>tml", ":+tabmove<CR>", { noremap = true })
-- end
--
require("dapui").setup()
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

vim.cmd.filetype "plugin indent on"
--au filetype python setlocal mp=python3\ %
-- Override tab size for terraform
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tf", "terraform" },
    command = "setlocal shiftwidth=2 tabstop=2"
})

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
local function change_root_to_global_cwd()
  local api = require("nvim-tree.api")
  local global_cwd = vim.fn.getcwd(-1, -1)
  api.tree.change_root(global_cwd)
end
--vim.keymap.set('n', '<leader>w', change_root_to_global_cwd, opts('Change Root To Global CWD'))
