--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_c07d0e45 = require("@lib/event/helper_c07d0e45")

--- Helper function.
local function helper_981c86d9()
	local flag: s32 = 0
	if helper_c07d0e45() == 0 then
		return 0
	end
	flag = event.get_save_flag(556) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_981c86d9
