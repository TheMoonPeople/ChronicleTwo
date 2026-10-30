--!strict
-- Shared event helper used by 48 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3300e99f(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	do
		local _, out2, _ = event.get_character_rotation(0)
		var2 = out2 or var2
	end
	var4 = vm.f32(arg0 + vm.f32(6.2831855))
	var5 = vm.f32(var2 + vm.f32(6.2831855))
	var6 = vm.f32(var4 - var5)
	if var6 < 0 then
		var6 = vm.f32(var6 * -1.0)
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.rotate_object_sequence(0, 0.0, arg0, 0.0, vm.ftoi(vm.f32(var6 * 10.0)))
	wait_objects(0)
	event.set_object_sequence_motion(0, "立ち")
	event.finish_event()
end

return helper_3300e99f
