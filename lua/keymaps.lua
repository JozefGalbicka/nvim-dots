local M = {}

local function map(keymaps, keymap_opts, extra_opts)
  extra_opts = extra_opts or {}
  local lazy_keymaps = extra_opts.lazy and {}
  keymap_opts = keymap_opts or {}
  for modes, maps in pairs(keymaps) do
    for _, m in pairs(maps) do
      local opts = vim.tbl_extend('force', keymap_opts, m[3] or {})
      if extra_opts.lazy then
        table.insert(lazy_keymaps, vim.tbl_extend('force', { m[1], m[2], mode = modes }, opts))
      else
        vim.keymap.set(modes, m[1], m[2], opts)
      end
    end
  end
  return lazy_keymaps
end

M.setup = {
    mini = function()
        return map({
            [{ 'n' }] = {
                { 'yss', 'ys_', { remap = true } },
            },
            [{ 'x' }] = {
                { 'S', ":<C-u>lua MiniSurround.add('visual')<CR>", { silent = true } },
            },
        })
    end,
}

return M
