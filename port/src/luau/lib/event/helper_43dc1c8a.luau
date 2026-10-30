--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_43dc1c8a()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	event.initialize_event()
	event.start_background_file_loads_1("snd2/sp/sp_033.sound.json")
	vm.wait(1)
	helper_479dc9e9()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or var0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	var1 = event.get_triggered_event_data_2(9) or var1
	var2 = vm.bits_float(event.get_triggered_event_data_2(11)) or var2
	event.attach_object_handle_to_map_part_3(0, var1, "d04w10_3-m")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if helper_f7fba8ce(var2, 0.0, 1.0) == 0 or helper_f7fba8ce(var2, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, var1, "d04w10_2-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, var1, "d04w10_4-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	else
		event.attach_object_handle_to_map_part_3(1, var1, "d04w10_5-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, var1, "d04w10_6-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	end
	event.play_sound_effect(var0, 2)
	var3 = vm.bits_float(event.get_triggered_event_data_2(11)) or var3
	var4 = 0
	while var4 < 30 do
		event.swing_camera_control_to_angle(var3)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var4 = var4 + 1
		vm.wait(3)
	end
	event.play_sound_effect(var0, 0)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	if helper_f7fba8ce(var2, 0.0, 1.0) == 0 then
		var7 = vm.f32(var7 + vm.f32(3.1415927))
		var7 = event.wrap_angle(var7) or var7
	end
	if helper_f7fba8ce(var2, vm.f32(3.14), 1.0) == 0 then
		var7 = vm.f32(var7 - vm.f32(3.1415927))
		var7 = event.wrap_angle(var7) or var7
	end
	if helper_f7fba8ce(var2, vm.f32(1.57), 1.0) == 0 then
		var5 = vm.f32(var5 + vm.f32(3.1415927))
		var5 = event.wrap_angle(var5) or var5
	end
	if helper_f7fba8ce(var2, vm.f32(-1.57), 1.0) == 0 then
		var5 = vm.f32(var5 - vm.f32(3.1415927))
		var5 = event.wrap_angle(var5) or var5
	end
	event.rotate_object_sequence_eased(1, var5, var6, var7, 40, 0, 0.5)
	event.rotate_object_sequence_eased(2, var5, var6, var7, 40, 0, 0.5)
	wait_objects(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.move_object_sequence_eased(0, var5, var6 + 80.0, var7, 32, 1, 0.5)
	wait_objects(0)
	event.finish_event()
end

return helper_43dc1c8a
