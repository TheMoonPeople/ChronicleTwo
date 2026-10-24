--!strict
-- Shared event helper used by 50 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_431304f5 = require("@lib/event/helper_431304f5")

--- Helper function.
local function helper_103da1d8(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_431304f5(arg0, arg4, arg5, 0)
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
	return helper_431304f5(arg0, arg4, arg5, 0)
end

return helper_103da1d8
