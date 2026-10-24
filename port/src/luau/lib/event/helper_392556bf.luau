--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_392556bf(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(90)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-292.76, 173.19, -1582.23)
	event.CmrsSetRef(-228.24, 151.8, -1773.02)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.ObjsMove(10, -120.0, 0.0, -3050.0, 90)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_392556bf
