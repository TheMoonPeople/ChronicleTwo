--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_deb4f28c()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetPos(5, 2265.95, 0.0, 2154.92)
	event.ObjsSetRot(5, 0.0, -0.24, 0.0)
	event.ObjsSetPos(6, 2153.43, -0.63, 2262.11)
	event.ObjsSetRot(6, 0.0, -1.08, 0.0)
	event.ObjsSetPos(7, 2156.97, 0.0, 2112.93)
	event.ObjsSetRot(7, 0.0, -0.6, 0.0)
	event.ObjsSetPos(8, 2126.92, 0.0, 2216.07)
	event.ObjsSetRot(8, 0.0, 1.48, 0.0)
	event.ObjsSetPos(9, 2138.89, 5.59, 2279.54)
	event.ObjsSetRot(9, 0.0, 3.04, 0.0)
	event.ObjsSetPos(10, 2243.43, 0.0, 2156.37)
	event.ObjsSetRot(10, 0.0, -2.76, 0.0)
end

return helper_deb4f28c
