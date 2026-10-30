--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_dc9f8b59()
	local var0: s32 = 0
	var0 = event.get_georama_analysis_percent(1) or var0
	if var0 < 100 then
		return 0
	end
	return 1
end

return helper_dc9f8b59
