local M = {}

function M.dump(tbl)
	local result = "{ "
	local tbl_len = #tbl
	for k, v in pairs(tbl) do
		result = result .. k .. " = "
		if type(v) == "table" then
			result = result .. M.dump(v)
		else
			result = result .. tostring(v)
		end
		local str = k == tbl_len and " " or ", "
		result = result .. str
	end
	result = result .. "}"
	return result
end

if ... == nil then
	local tbl = {}
	table.insert(tbl, "hey")
	table.insert(tbl, "sup")
	print(M.dump(tbl))
end

return M
