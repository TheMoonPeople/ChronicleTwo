--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c247398f()
	local var0: s32 = 0
	var0 = event.get_georama_analysis_percent(4) or var0
	if var0 < 100 then
		return 0
	end
	return 1
end

return helper_c247398f
