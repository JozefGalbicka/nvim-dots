-----------------------------------------------------
----------- GENERAL
-----------------------------------------------------
vim.opt.termguicolors = true -- set termguicolors to enable highlight groups

vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting

vim.wo.number = true

-----------------------------------------------------
----------- SHORTCUTS
-----------------------------------------------------
local funcs = require("functions")

-- This is now set in tmux integration plugin
--vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
--vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
--vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
--vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
-- end

-- Faster C-w
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
vim.keymap.set({ 'n' }, '<A-r>', '', {
    desc = "Run .py file via Neovim built-in terminal",
    callback = funcs.run_curr_python_file
})

-- nvim-tree fix
--vim.keymap.set('n', '<leader>w', change_root_to_global_cwd, opts('Change Root To Global CWD'))

-----------------------------------------------------
----------- FILETYPES
-----------------------------------------------------
-- Is enabled by default, remove
vim.cmd.filetype "plugin indent on"

vim.filetype.add({
    pattern = {
        [".*/templates/.*%.yaml"] = "helm",
    },
})

-----------------------------------------------------
----------- AUTOCMDS
-----------------------------------------------------
--vim.api.nvim_create_autocmd("DirChanged", {
--    pattern = "*",
--    command = "echo 'sad'"
--})

-----------------------------------------------------
----------- TESTING?
-----------------------------------------------------
--vim.api.nvim_create_user_command('VimwikiIndex', 'echo "HELLO"',{})
--call vimwiki#base#goto_index(<count>)
