--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_9d522960(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(45)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	event.CmrsSetPos(-127.04, 86.04, -2182.12)
	event.CmrsSetRef(-120.48, 84.44, -1718.57)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.CmrsMove2(-126.85, 86.09, -2262.29, -120.48, 84.44, -1718.57, 20, 2, 0.4)
	event.ObjsMove(10, -120.0, 0.0, -2100.0, 45)
	helper_aafd6a80(45)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_9d522960
