local M = {}

function M.init_highlight_group()
  vim.api.nvim_command("highlight default ByteMarks guifg=#cba6f7")
  namespace_id = vim.api.nvim_create_namespace("ByteMarks")
end

function M.run_autocommands()
  vim.api.nvim_command("augroup ByteMarks")
  vim.api.nvim_command("autocmd!")
  vim.api.nvim_command("autocmd ColorScheme * lua require'bitemarks'.init_highlight_group()")
  vim.api.nvim_command("augroup end")
end

function M.mark(mark)
  local id = string.byte(mark)

  local buffer_id = vim.api.nvim_get_current_buf()
  local win_id = vim.api.nvim_get_current_win()
  local line_number = vim.api.nvim_win_get_cursor(win_id)[1] - 1
  local col = 0
  vim.api.nvim_buf_del_extmark(buffer_id, namespace_id, id)
  vim.api.nvim_buf_set_extmark(buffer_id, namespace_id, line_number, col, {
    id = id,
    virt_text = { { "'" .. mark, "ByteMarks" } },
  })

  vim.api.nvim_feedkeys("m" .. mark, "n", true)
end

function M.setup()
  require("bitemarks").init_highlight_group()
  require("bitemarks").run_autocommands()
  vim.keymap.set("n", "m", "<cmd>lua require'bitemarks'.mark(vim.fn.getcharstr())<CR>")
end

return M
