local M = {}

function M.init_highlight_group()
  vim.api.nvim_command("highlight default BiteMarks guifg=#cba6f7")
  namespace_id = vim.api.nvim_create_namespace("BiteMarks")
end

function M.run_autocommands()
  vim.api.nvim_command("augroup BiteMarks")
  vim.api.nvim_command("autocmd!")
  vim.api.nvim_command("autocmd ColorScheme * lua require'bitemarks'.init_highlight_group()")
  vim.api.nvim_command("augroup end")
end

function M.mark(mark)
  local id1 = string.byte(mark .. '*')
  local id2 = string.byte(mark .. '\'')

  local buffer_id = vim.api.nvim_get_current_buf()
  local win_id = vim.api.nvim_get_current_win()
  local line_number = vim.api.nvim_win_get_cursor(win_id)[1] - 1
  local col = 0

  vim.api.nvim_buf_del_extmark(buffer_id, namespace_id, id1)
  vim.api.nvim_buf_del_extmark(buffer_id, namespace_id, id2)

  vim.api.nvim_buf_set_extmark(buffer_id, namespace_id, line_number, col, {
    id = id1,
    virt_text = { { line_number, "BiteMarks" } },
    virt_text_win_col = -3,
    priority = 100,
  })

  vim.api.nvim_buf_set_extmark(buffer_id, namespace_id, line_number, col, {
    id = id2,
    virt_text = { { "'" .. mark .. "     ", "BiteMarks" } },
    virt_text_pos = "right_align",
    priority = 100
  })

  vim.api.nvim_feedkeys("m" .. mark, "n", true)
end

function M.setup()
  require("bitemarks").init_highlight_group()
  require("bitemarks").run_autocommands()
  vim.keymap.set("n", "m", "<cmd>lua require'bitemarks'.mark(vim.fn.getcharstr())<CR>")
end

return M
