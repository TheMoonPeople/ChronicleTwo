--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_64f3e42f()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.call_command(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
	var4 = vm.bits_float(event.get_triggered_event_data_2(11)) or var4
	var0 = event.get_triggered_event_data_2(9) or var0
	event.start_background_file_loads_2("event/dng_inout/kumonosu.gltf", "snd2/sp/sp_028.sound.json")
	var4 = vm.f32(var4 + vm.f32(3.1415927))
	var4 = event.wrap_angle(var4) or var4
	var5 = 0
	while var5 < 30 do
		event.set_follow_camera_target(var1, var2 + 40.0, var3)
		event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
		event.swing_camera_control_to_angle(var4)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var5 = var5 + 1
		vm.wait(1)
	end
	helper_479dc9e9()
	event.load_character(5, "event/dng_inout/kumonosu.gltf", "info", 12)
	event.set_character_position(12, var1, var2 + 20.0, var3)
	event.set_character_rotation(12, 0.0, var4, 0.0)
	var6 = event.load_sound_effect_file_3(8, "snd2/sp/sp_028.sound.json") or var6
	wait_frames(10)
	event.play_sound_effect(var6, 0)
	event.set_character_active(1, 12)
	event.set_character_motion(12, "巣消える", 6)
	wait_frames(75)
	event.delete_character(12)
	event.reset_follow_camera(0)
	event.attach_object_handle_to_map_part_2(2, var0)
	do
		local out1, out2, out3 = event.get_object_handle_position(2)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.attach_object_handle_to_map_part_3(3, var0, "d02d05_1-m0")
	event.set_object_handle_visible(3, 0)
	event.attach_object_handle_to_map_part_3(4, var0, "d02da05-a")
	event.set_object_handle_visible(4, 0)
	event.attach_object_handle_to_map_part_3(5, var0, "d02dv05-c")
	event.set_object_handle_visible(5, 0)
	event.set_function_point_enabled(var0, "key", 0)
	event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
	event.start_crossfade(30)
	wait_frames(30)
end

return helper_64f3e42f
