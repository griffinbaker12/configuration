local M = {}

local function trim_lines(lines, start_col, end_col, cols)
	if lines == nil or #lines == 0 then
		return
	elseif #lines == 1 then
		lines[1] = lines[1]:sub(start_col, end_col)
	end
end

local s = ":hey"
for n in s:gmatch(":%s*([%w_]+)") do
	print("m" .. n)
end

local function extract_destructured_var_names(selection)
	local vars = {}
	for name in selection:gmatch(":%s*([%w_]+)") do
		table.insert(vars, name)
	end
	return vars
end

local function extract_simple_var_names(selection)
	local vars = {}
	for name in selection:gmatch("([%w_]+)%s*,?") do
		table.insert(vars, name)
	end
	return vars
end

local function build_console_log(vars)
	local pieces = {}
	for _, name in ipairs(vars) do
		table.insert(pieces, string.format('"%s:", %s', name, name))
	end
	return "console.log(" .. table.concat(pieces, ", ") .. ");"
end

local function get_line_indent(lnum)
	local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
	return line:match("^%s*") or ""
end

local function find_next_paragraph_line(start_line)
	local total_lines = vim.api.nvim_buf_line_count(0)
	for lnum = start_line + 1, total_lines do
		local line = vim.fn.getline(lnum)
		if line == "" or line:match("^%s*$") then
			return lnum
		end
	end
	return total_lines
end

local function find_statement_end_line(start_line, max_scan)
	local lines = vim.api.nvim_buf_get_lines(0, start_line, start_line + max_scan, false)
	for i, line in ipairs(lines) do
		if line:match("};%s*$") or line:match("%]%s*;%s*$") then
			return start_line + i
		end
	end
	return start_line
end

-- Helper to detect the pattern type (array, promise, object)
local function detect_pattern_type(line)
	if line:match("Promise%.all%s*%(%s*%[") then
		return "promise"
	elseif line:match("const%s+%[") or line:match("let%s+%[") or line:match("var%s+%[") then
		return "array"
	elseif line:match("const%s+{") or line:match("let%s+{") or line:match("var%s+{") then
		return "object"
	else
		return nil
	end
end

-- Helper to find the complete statement for array destructuring or Promise.all
local function find_complete_statement_end(start_line, pattern_type)
	local buf_line_count = vim.api.nvim_buf_line_count(0)

	-- Define end patterns based on pattern type
	local end_pattern
	if pattern_type == "promise" then
		end_pattern = "%]%)%s*;" -- Promise.all ending: ]);
	elseif pattern_type == "array" then
		end_pattern = "%]%s*;" -- Array destructuring ending: ];
	elseif pattern_type == "object" then
		end_pattern = "}%s*;" -- Object destructuring ending: };
	else
		return start_line -- Default fallback
	end

	-- Count opening and closing brackets to handle nested structures
	local open_count = 0
	local close_count = 0
	local bracket_open, bracket_close

	if pattern_type == "promise" or pattern_type == "array" then
		bracket_open = "%["
		bracket_close = "%]"
	elseif pattern_type == "object" then
		bracket_open = "{"
		bracket_close = "}"
	else
		return start_line
	end

	-- Check the start line for the opening bracket
	local start_line_text = vim.fn.getline(start_line)
	open_count = open_count + select(2, start_line_text:gsub(bracket_open, ""))

	-- Loop through lines to find the complete statement end
	for i = start_line, math.min(start_line + 30, buf_line_count) do
		local line = vim.fn.getline(i)

		-- Only count brackets after the start line
		if i > start_line then
			open_count = open_count + select(2, line:gsub(bracket_open, ""))
		end
		close_count = close_count + select(2, line:gsub(bracket_close, ""))

		-- Check if this line contains the end pattern and brackets are balanced
		if close_count >= open_count and line:match(end_pattern) then
			return i
		end
	end

	-- If we couldn't find a definitive end, return a reasonable fallback
	-- Look for any line with a semicolon
	for i = start_line, math.min(start_line + 30, buf_line_count) do
		local line = vim.fn.getline(i)
		if line:match(";%s*$") then
			return i
		end
	end

	-- Last resort fallback
	return start_line
end

-- Keep is_slop_lang in M's table
function M.is_slop_lang(ft)
	return ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact"
end

function M.log_simple_selection() end

function M.wrap_visual_selection()
	vim.cmd("normal! gv")
	local vstart = vim.fn.getpos("'<")
	local vend = vim.fn.getpos("'>")
	local start_line = vstart[2]
	local start_col = vstart[3]
	local end_line = vend[2]
	local end_col = vend[3]

	-- Get the raw content of the selected lines
	local buf_line_count = vim.api.nvim_buf_line_count(0)
	local raw_lines = vim.fn.getline(start_line, end_line)
	local lines = type(raw_lines) == "string" and { raw_lines } or raw_lines

	-- Process selected text
	if lines == nil or #lines == 0 then
		return
	elseif #lines == 1 then
		lines[1] = lines[1]:sub(start_col, end_col)
	else
		lines[1] = lines[1]:sub(start_col)
		lines[#lines] = lines[#lines]:sub(1, end_col)
	end

	print(vim.inspect(lines))

	print(vim.fn.indent(start_line))

	local j = extract_destructured_var_names(table.concat(lines, " "))
	print("THE TABLE IS: " .. vim.inspect(j))

	---@diagnostic disable-next-line: param-type-mismatch
	-- print("EXtracted: " .. extract_simple_var_names(table.concat(lines, " ")))
	return

	-- Join lines and build log statement
	---@diagnostic disable-next-line: param-type-mismatch
	-- local selection = table.concat(lines, " ")
	--
	-- local is_simple_selection = start_line == end_line
	-- if is_simple_selection then
	-- 	-- can just go the logging right here
	-- 	vars = extract_destructured_var_names(selection)
	-- 	if #vars == 0 then
	-- 		vars = extract_simple_var_names(selection)
	-- 	end
	-- end
	-- print(vim.inspect(vars), "the vars are")
	--
	-- -- NOTE: I think this logic is fine
	-- local statement_indent = get_line_indent(start_line)
	-- print(statement_indent .. "indent")
	-- log_line = statement_indent .. build_console_log(vars)
	-- insert_line = end_line
	-- vim.fn.append(insert_line, log_line)
	-- local target_line = math.min(insert_line + 1, vim.api.nvim_buf_line_count(0))
	--
	-- -- Position cursor at the start of the console.log statement
	-- local console_col = #statement_indent
	--
	-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	-- vim.api.nvim_win_set_cursor(0, { target_line, console_col })
	-- return

	-- return

	-- local pattern_type = nil
	-- local pattern_start_line = nil
	--
	-- local index_found = 0
	--
	-- -- First, determine if we're inside a special pattern and find its starting point
	-- for i = start_line, math.max(1, start_line - 15), -1 do
	-- 	local line = vim.fn.getline(i)
	-- 	if line == start_line - 1 then
	-- 		print(line)
	-- 		if line == "\n" then
	-- 			print("Empty")
	-- 		end
	-- 		break
	-- 	end
	-- 	-- local current_type = detect_pattern_type(line)
	-- 	--
	-- 	-- if current_type ~= nil then
	-- 	-- 	pattern_type = current_type
	-- 	-- 	pattern_start_line = i
	-- 	-- 	statement_indent = get_line_indent(i)
	-- 	-- 	index_found = i
	-- 	-- 	break
	-- 	-- end
	-- end
	--
	-- -- print("patterntype" .. pattern_type .. " found at " .. index_found)
	--
	-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	-- return
	--
	-- -- -- Find the actual variables to log
	-- -- local ft = vim.bo.filetype
	-- -- local log_line
	-- --
	-- -- if M.is_slop_lang(ft) then
	-- -- 	local vars = {}
	-- --
	-- -- 	-- If we're in a special pattern (array/object destructuring or Promise.all)
	-- -- 	if pattern_type ~= nil and pattern_start_line ~= nil then
	-- -- 		-- Get the actual variable names from the pattern
	-- -- 		local pattern_line = vim.fn.getline(pattern_start_line)
	-- --
	-- -- 		if pattern_type == "array" then
	-- -- 			-- Extract variable names from array destructuring
	-- -- 			-- Like: const [var1, var2, var3] = ...
	-- -- 			local brackets_content = pattern_line:match("%[(.-)%]")
	-- -- 			if brackets_content then
	-- -- 				vars = extract_simple_var_names(brackets_content)
	-- -- 			end
	-- -- 		elseif pattern_type == "object" then
	-- -- 			-- Extract variable names from object destructuring
	-- -- 			-- Find the entire object pattern across multiple lines if needed
	-- -- 			local object_pattern = pattern_line
	-- -- 			local open_braces = select(2, pattern_line:gsub("{", ""))
	-- -- 			local close_braces = select(2, pattern_line:gsub("}", ""))
	-- -- 			local line_num = pattern_start_line + 1
	-- --
	-- -- 			-- Collect the entire object pattern if it spans multiple lines
	-- -- 			while open_braces > close_braces and line_num <= buf_line_count do
	-- -- 				local next_line = vim.fn.getline(line_num)
	-- -- 				object_pattern = object_pattern .. " " .. next_line
	-- -- 				open_braces = open_braces + select(2, next_line:gsub("{", ""))
	-- -- 				close_braces = close_braces + select(2, next_line:gsub("}", ""))
	-- -- 				line_num = line_num + 1
	-- -- 			end
	-- --
	-- -- 			-- Try to extract from x: name pattern first
	-- -- 			vars = extract_destructured_var_names(object_pattern)
	-- --
	-- -- 			-- If no vars found, try simple extraction (for {a, b, c} syntax)
	-- -- 			if #vars == 0 then
	-- -- 				local braces_content = object_pattern:match("{(.-)}")
	-- -- 				if braces_content then
	-- -- 					vars = extract_simple_var_names(braces_content)
	-- -- 				end
	-- -- 			end
	-- -- 		elseif pattern_type == "promise" then
	-- -- 			-- For Promise.all, extract from the array part
	-- -- 			local brackets_content = pattern_line:match("%[(.-)%]")
	-- -- 			if brackets_content then
	-- -- 				-- First check if there are variables on the left side
	-- -- 				local left_side = pattern_line:match("const%s+%[(.-)%]")
	-- -- 				if left_side then
	-- -- 					vars = extract_simple_var_names(left_side)
	-- -- 				end
	-- -- 			end
	-- -- 		end
	-- -- 	else
	-- -- 		-- Default extraction for non-pattern selections
	-- -- 		vars = extract_destructured_var_names(selection)
	-- -- 		if #vars == 0 then
	-- -- 			vars = extract_simple_var_names(selection)
	-- -- 		end
	-- -- 	end
	-- --
	-- -- 	if #vars > 0 then
	-- -- 		log_line = statement_indent .. build_console_log(vars)
	-- -- 	else
	-- -- 		log_line = statement_indent .. 'console.log("' .. selection .. ':", ' .. selection .. ");"
	-- -- 	end
	-- -- else
	-- -- 	log_line = statement_indent .. "print(" .. selection .. ")"
	-- -- end
	-- --
	-- -- -- Determine where to insert the console.log statement
	-- -- local insert_line
	-- --
	-- -- if is_simple_selection then
	-- -- 	-- For simple selections, insert after the current line
	-- -- 	insert_line = end_line
	-- -- elseif pattern_type ~= nil and pattern_start_line ~= nil then
	-- -- 	-- For special patterns, find the complete statement end
	-- -- 	insert_line = find_complete_statement_end(pattern_start_line, pattern_type)
	-- -- else
	-- -- 	-- Default fallback for other cases
	-- -- 	-- Find our current block depth (counting { and })
	-- -- 	local current_depth = 0
	-- -- 	for i = 1, start_line - 1 do
	-- -- 		local line = vim.fn.getline(i)
	-- -- 		current_depth = current_depth + select(2, line:gsub("{", "")) - select(2, line:gsub("}", ""))
	-- -- 	end
	-- --
	-- -- 	-- Look ahead to find the same block level
	-- -- 	local block_end = nil
	-- -- 	local scanning_depth = current_depth
	-- -- 	for i = end_line, math.min(end_line + 30, buf_line_count) do
	-- -- 		local line = vim.fn.getline(i)
	-- -- 		scanning_depth = scanning_depth + select(2, line:gsub("{", "")) - select(2, line:gsub("}", ""))
	-- --
	-- -- 		-- We've found the end of our current block if we return to the same depth
	-- -- 		-- and it's a closing brace
	-- -- 		if scanning_depth < current_depth and line:match("^%s*}") then
	-- -- 			block_end = i - 1 -- Insert before the closing brace
	-- -- 			break
	-- -- 		end
	-- --
	-- -- 		-- For simple statements, insert after the line with semicolon
	-- -- 		if i == end_line and line:match(";%s*$") then
	-- -- 			block_end = i
	-- -- 			break
	-- -- 		end
	-- -- 	end
	-- --
	-- -- 	if block_end then
	-- -- 		insert_line = block_end
	-- -- 	else
	-- -- 		-- Fallback: insert at next paragraph or right after current line
	-- -- 		if #lines > 1 then
	-- -- 			insert_line = math.min(find_next_paragraph_line(end_line), buf_line_count)
	-- -- 		else
	-- -- 			insert_line = end_line
	-- -- 		end
	-- -- 	end
	-- -- end
	-- --
	-- -- -- Insert the log line
	-- -- vim.fn.append(insert_line, log_line)
	-- --
	-- -- -- Move cursor to inserted line
	-- -- local target_line = math.min(insert_line + 1, vim.api.nvim_buf_line_count(0))
	-- --
	-- -- -- Position cursor at the start of the console.log statement
	-- -- local console_col = #statement_indent
	-- --
	-- -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	-- -- vim.api.nvim_win_set_cursor(0, { target_line, console_col })
end

vim.keymap.set("v", "<leader>ls", M.wrap_visual_selection)

t = { "test", "test1" }
test = "...;"
print(table.concat(t, " "))
print(vim.fn.getline(327))
if string.match(test, ";") then
	print("match")
end

return M
