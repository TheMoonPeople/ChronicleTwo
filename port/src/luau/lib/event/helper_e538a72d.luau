--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_e538a72d()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	var1 = event.get_georama_analysis_flag(103) or var1
	if var1 == 0 then
		return 0
	end
	flag = event.get_save_flag(270) or flag
	if flag ~= 0 then
		return 0
	end
	var2 = event.get_character_change_state(1) or var2
	if var2 == 0 then
		return 0
	end
	return 1
end

return helper_e538a72d
