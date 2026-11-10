--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_dc9f8b59 = require("@lib/event/helper_dc9f8b59")

--- Helper function.
local function helper_2db4207e()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_dc9f8b59() == 0 then
		return 0
	end
	flag = event.get_save_flag(376) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.get_character_change_state(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

return helper_2db4207e
