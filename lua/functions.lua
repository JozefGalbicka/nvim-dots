local M = {}

-- RUN CURRENT PYTHON FILE
function M.run_curr_python_file()
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

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
local function change_root_to_global_cwd()
    local api = require("nvim-tree.api")
    local global_cwd = vim.fn.getcwd(-1, -1)
    api.tree.change_root(global_cwd)
end


return M
