--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_6be25ed2 = require("@lib/event/helper_6be25ed2")

--- Helper function.
local function helper_91c6c650()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_6be25ed2() == 0 then
		return 0
	end
	flag = event.get_save_flag(448) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.get_character_change_state(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

return helper_91c6c650
