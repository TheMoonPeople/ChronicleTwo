--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_da39f7c6(arg0: s32)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	event.initialize_event()
	var1 = event.get_triggered_event_data_2(9) or var1
	if arg0 == 0 then
		event.attach_object_handle_to_map_part_3(0, var1, "d05w10_1-m0")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.start_background_file_loads_1("snd2/sp/sp_035.sound.json")
		var2 = vm.bits_float(event.get_triggered_event_data_2(11)) or var2
		var3 = 0
		while var3 < 20 do
			event.swing_camera_control_to_angle(var2)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			var3 = var3 + 1
			vm.wait(1)
		end
		vm.wait(2)
		helper_479dc9e9()
		var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_035.sound.json") or var4
		event.play_sound_effect(var4, 1)
		event.move_object_sequence_eased(0, 0.0, 70.0, 0.0, 30, 2, 0.4)
		event.reset_follow_camera(0)
		wait_objects(0)
		event.stop_sound_effect(var4, 1)
	else
		event.start_background_file_loads_1("snd2/sp/sp_036.sound.json")
		vm.wait(5)
		helper_479dc9e9()
		var5 = event.load_sound_effect_file_3(8, "snd2/sp/sp_036.sound.json") or var5
		event.play_sound_effect(var5, 0)
		event.attach_object_handle_to_map_part_3(0, var1, "d05w10_1-m0")
		event.set_object_handle_visible(0, 1)
		event.start_crossfade(10)
	end
	vm.wait(7)
	event.finish_event()
end

return helper_da39f7c6
