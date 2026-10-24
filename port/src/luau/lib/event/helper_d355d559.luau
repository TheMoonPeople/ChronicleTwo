--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d355d559(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	var4 = event.GetEventData_2(9) or var4
	event.EohSyncObj_2(0, var4)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	arg3 = vm.bits_float(event.GetEventData_2(11)) or arg3
	return arg0, arg1, arg2, arg3
end

return helper_d355d559
