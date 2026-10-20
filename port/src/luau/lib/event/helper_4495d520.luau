--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6ea63a75 = require("@lib/event/helper_6ea63a75")

--- Helper function.
local function helper_4495d520(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any, arg5: any)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_6ea63a75(arg0, arg4, arg5, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.MesMake_2(arg0, arg1)
	event.SetMesAutoset(arg0, arg2, arg3)
	return helper_6ea63a75(arg0, arg4, arg5, 0)
end

return helper_4495d520
