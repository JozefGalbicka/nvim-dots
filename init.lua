-- https://stackoverflow.com/questions/75987806/why-is-my-neovim-plugin-not-loaded-despite-lazy-telling-me-it-is
-- https://github.com/wimstefan/dotfiles/blob/master/config/nvim/init.lua#L1313-L1454
--

-- Bootstrap lazy.nvim
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


-- Plugin Spec Reference - https://lazy.folke.io/spec
-- Folder Structure - https://lazy.folke.io/usage/structuring
-- Config options - https://lazy.folke.io/configuration
-- https://github.com/Integralist/nvim/tree/main/lua/plugins
require("lazy").setup({
    spec = {
        import = "plugins"
    },
})

vim.filetype.add({
    pattern = {
        [".*/templates/.*%.yaml"] = "helm",
    },
})

-----------------------------------------------------
----------- GENERAL
-----------------------------------------------------
vim.opt.termguicolors = true -- set termguicolors to enable highlight groups

vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting

vim.wo.number = true

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


--vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
--vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
--vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
--vim.keymap.set("n", "<C-l>", "<C-w>l", opts)




-- Trash shelf for the disobedient ones
--vim.api.nvim_set_option("clipboard","unnamed")

-----------------------------------------------------
----------- SHORTCUTS
-----------------------------------------------------
vim.keymap.set('n', '<leader>s', '<c-w>', { noremap = true })


-- COPY/PASTE TO CLIPBOARD REGISTER
vim.keymap.set('v', '<C-c>', [["+yi<ESC>]], {})
vim.keymap.set('v', '<C-x>', [["+c<ESC>]], {})
vim.keymap.set('v', '<C-v>', [[c<ESC>"+p]], {})
vim.keymap.set('i', '<C-v>', [[<ESC>"+pa]], {})
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




--

vim.cmd.filetype "plugin indent on"
--au filetype python setlocal mp=python3\ %
-- Override tab size for terraform
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tf", "terraform" },
    command = "setlocal shiftwidth=2 tabstop=2"
})
--vim.api.nvim_create_autocmd("DirChanged", {
--    pattern = "*",
--    command = "echo 'sad'"
--})





-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
local function change_root_to_global_cwd()
    local api = require("nvim-tree.api")
    local global_cwd = vim.fn.getcwd(-1, -1)
    api.tree.change_root(global_cwd)
end
--vim.keymap.set('n', '<leader>w', change_root_to_global_cwd, opts('Change Root To Global CWD'))





--vim.api.nvim_create_user_command('VimwikiIndex', 'echo "HELLO"',{})
--call vimwiki#base#goto_index(<count>)
