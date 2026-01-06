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

-----------------------------------------------------
----------- REQUIRES
-----------------------------------------------------
require('settings')
