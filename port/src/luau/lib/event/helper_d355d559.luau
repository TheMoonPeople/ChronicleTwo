--!strict
-- Shared event helper used by 46 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d355d559(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	var4 = event.get_triggered_event_data_2(9) or var4
	event.attach_object_handle_to_map_part_2(0, var4)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	arg3 = vm.bits_float(event.get_triggered_event_data_2(11)) or arg3
	return arg0, arg1, arg2, arg3
end

return helper_d355d559
