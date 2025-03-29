local M = {}

local function get_line_indent(lnum)
	local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
	return line:match("^%s*") or ""
end

function is_slop_lang(ft)
	return ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact"
end

function M.wrap_visual_selection()
	vim.cmd("normal! gv")

	local vstart = vim.fn.getpos("'<")
	local vend = vim.fn.getpos("'>")

	local start_line = vstart[2]
	local start_col = vstart[3]
	local end_line = vend[2]
	local end_col = vend[3]

	local leading_indent = get_line_indent(start_line)

	local raw_lines = vim.fn.getline(start_line, end_line)
	local lines = type(raw_lines) == "string" and { raw_lines } or raw_lines

	if lines == nil or #lines == 0 then
		return
	elseif #lines == 1 then
		lines[1] = lines[1]:sub(start_col, end_col)
	else
		lines[1] = lines[1]:sub(start_col)
		lines[#lines] = lines[#lines]:sub(1, end_col)
	end

	---@diagnostic disable-next-line: param-type-mismatch
	local selection = table.concat(lines, " ")

	local ft = vim.bo.filetype
	local prefix, suffix = "print(", ")"
	if is_slop_lang(ft) then
		prefix, suffix = "console.log(", ")"
	end

	local wrapped = leading_indent .. prefix .. '"' .. selection .. ':", ' .. selection .. suffix
	vim.fn.append(end_line, wrapped)

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
end

vim.keymap.set("v", "<leader>lg", function()
	M.wrap_visual_selection()
end)

return M
