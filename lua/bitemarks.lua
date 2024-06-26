local M = {}

local function get_highlight(group, attr) 
  local hl = vim.api.nvim_get_hl_by_name(group, true)
  if hl[attr] then
    return string.format("#%06x", hl[attr])
  end
end

local function set_highlight(group, ref_group, attr)
  local color = get_highlight(ref_group, attr)
  if color then
    vim.cmd(string.format("highlight %s guifg=%s", group, color))
  end
end

function M.init_highlight_group()
  set_highlight("BiteMarks", "Keyword", "foreground")
	-- vim.api.nvim_command("highlight default BiteMarks guifg=#cba6f7")
	namespace_id = vim.api.nvim_create_namespace("BiteMarks")
end

function M.run_autocommands()
	vim.api.nvim_command("augroup BiteMarks")
	vim.api.nvim_command("autocmd!")
	vim.api.nvim_command("autocmd ColorScheme * lua require'bitemarks'.init_highlight_group()")
	vim.api.nvim_command("augroup end")
end

function gen_id(str)
	local id = ""
	for char in str:gmatch(".") do
		id = id .. tostring(string.byte(char))
	end

	return tonumber(id)
end

function M.mark(mark)
	local id1 = gen_id(mark .. "*")
	local id2 = gen_id(mark .. "'")

	local buffer_id = vim.api.nvim_get_current_buf()
	local win_id = vim.api.nvim_get_current_win()
	local line_number = vim.api.nvim_win_get_cursor(win_id)[1] - 1
	local col = 0

	vim.api.nvim_buf_del_extmark(buffer_id, namespace_id, id1)
	vim.api.nvim_buf_del_extmark(buffer_id, namespace_id, id2)

	vim.api.nvim_buf_set_extmark(buffer_id, namespace_id, line_number, col, {
		id = id1,
		virt_text = { { tostring(line_number+1), "BiteMarks" } },
		virt_text_win_col = -(string.len(tostring(line_number+1)) + 1),
		priority = 100,
	})

	vim.api.nvim_buf_set_extmark(buffer_id, namespace_id, line_number, col, {
		id = id2,
		virt_text = { { "'" .. mark .. "     ", "BiteMarks" } },
		virt_text_pos = "right_align",
		priority = 100,
	})

	vim.api.nvim_feedkeys("m" .. mark, "n", true)
end

function M.setup()
	require("bitemarks").init_highlight_group()
	require("bitemarks").run_autocommands()
	vim.keymap.set("n", "m", "<cmd>lua require'bitemarks'.mark(vim.fn.getcharstr())<CR>")
end

return M
