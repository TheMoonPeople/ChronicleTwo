--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_cac435d9()
	local flag: s32 = 0
	local debug_flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(306) or flag
	if flag ~= 1 then
		debug_flag = event.GetDebugFlag() or debug_flag
		if debug_flag == 0 then
			event.CharaActive(0, 120)
			event.CharaActive(0, 121)
		end
	end
	event.GeoramaFunc(2)
end

return helper_cac435d9
