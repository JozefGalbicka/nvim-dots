--should look into this some time
--https://stackoverflow.com/questions/26962999/wrong-indentation-when-editing-yaml-in-vim

--vim.cmd("setlocal indentkeys-=0#")
--
--vim.bo.tabstop = 2
--vim.bo.softtabstop = 2
--vim.bo.shiftwidth = 2
--vim.bo.expandtab = true

-- Fix list dash indentation
--vim.bo.indentkeys = vim.bo.indentkeys:gsub("0#,-", "")
