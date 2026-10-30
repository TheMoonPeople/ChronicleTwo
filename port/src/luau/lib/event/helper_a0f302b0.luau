--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_44540785 = require("@lib/event/helper_44540785")

--- Helper function.
local function helper_a0f302b0()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_44540785() == 0 then
		return 0
	end
	flag = event.get_save_flag(372) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.get_character_change_state(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

return helper_a0f302b0
