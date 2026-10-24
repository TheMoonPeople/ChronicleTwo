--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c5ea1698()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	var0 = event.GetDioramaPercent(0) or var0
	if var0 < 100 then
		return 0
	end
	flag = event.GetFlag(285) or flag
	if flag ~= 0 then
		return 0
	end
	var2 = event.CheckEnableCharaChange(1) or var2
	if var2 == 0 then
		return 0
	end
	return 1
end

return helper_c5ea1698
