--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_ee09935e()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	var1 = event.GetAnalyze(104) or var1
	if var1 == 0 then
		return 0
	end
	flag = event.GetFlag(275) or flag
	if flag ~= 0 then
		return 0
	end
	var2 = event.CheckEnableCharaChange(1) or var2
	if var2 == 0 then
		return 0
	end
	return 1
end

return helper_ee09935e
