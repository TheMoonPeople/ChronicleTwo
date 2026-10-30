--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8ccd8f42()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_030.sound.json") or var0
	var1 = event.get_triggered_event_data_2(9) or var1
	event.attach_object_handle_to_map_part_3(0, var1, "d01w10_4-m0")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
	var1 = event.get_triggered_event_data_2(9) or var1
	event.attach_object_handle_to_map_part_3(1, var1, "d01w10_5-m0")
	event.set_object_handle_visible(1, 1)
	event.play_sound_effect(var0, 2)
	var2 = vm.bits_float(event.get_triggered_event_data_2(11)) or var2
	var3 = 0
	while var3 < 20 do
		event.swing_camera_control_to_angle(var2)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var3 = var3 + 1
		vm.wait(1)
	end
	event.move_object_sequence(0, 0.0, 80.0, 0.0, 60)
	event.play_sound_effect(var0, 0)
	var3 = 0
	while var3 < 60 do
		event.swing_camera_control_to_angle(var2)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var3 = var3 + 1
		vm.wait(2)
	end
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.reset_follow_camera(0)
	event.finish_event()
end

return helper_8ccd8f42
