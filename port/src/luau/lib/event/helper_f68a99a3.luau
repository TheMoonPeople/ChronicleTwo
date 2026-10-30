--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_6d4c475a = require("@lib/event/helper_6d4c475a")

--- Helper function.
local function helper_f68a99a3()
	local flag: s32 = 0
	if helper_6d4c475a() == 0 then
		return 0
	end
	flag = event.get_save_flag(364) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

return helper_f68a99a3
