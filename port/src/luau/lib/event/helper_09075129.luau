--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_09075129()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local rot_y: f32 = 0
	local var8: s32 = 0
	local active_chr_no: s32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.call_command(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
	var4 = vm.bits_float(event.get_triggered_event_data_2(11)) or var4
	var0 = event.get_triggered_event_data_2(9) or var0
	event.attach_object_handle_to_character(0, 0)
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		rot_y = out2 or rot_y
	end
	event.set_object_sequence_object(0, 0)
	var8 = event.compare_angles(rot_y, var4, 0.1) or var8
	if var8 ~= 0 then
		event.rotate_object_sequence(0, 0.0, var4, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.start_background_file_loads_4(
			"event/dng_inout/c01d02gkey.gltf",
			"event/dng_inout/d02nkey_h.gltf",
			"event/dng_inout/kumonosu.gltf",
			"snd2/sp/sp_028.sound.json"
		)
	else
		event.start_background_file_loads_4(
			"event/dng_inout/c02d02gkey.gltf",
			"event/dng_inout/d02nkey_h.gltf",
			"event/dng_inout/kumonosu.gltf",
			"snd2/sp/sp_028.sound.json"
		)
	end
	var4 = vm.f32(var4 + vm.f32(3.1415927))
	var4 = event.wrap_angle(var4) or var4
	var10 = 0
	while var10 < 30 do
		event.set_follow_camera_target(var1, var2 + 40.0, var3)
		event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
		event.swing_camera_control_to_angle(var4)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var10 = var10 + 1
		vm.wait(1)
	end
	helper_479dc9e9()
	event.load_character(5, "event/dng_inout/d02nkey_h.gltf", "info", 12)
	if active_chr_no == 0 then
		event.load_character_motion_pack(5, "event/dng_inout/c01d02gkey.gltf", "info", 0)
		event.attach_character_to_frame(0, "ef00", 12)
	else
		event.load_character_motion_pack(5, "event/dng_inout/c02d02gkey.gltf", "info", 0)
		event.attach_character_to_frame(0, "sword_hand", 12)
	end
	event.set_character_active(12)
	event.load_character(5, "event/dng_inout/kumonosu.gltf", "info", 13)
	event.set_character_position(13, var1, var2 + 20.0, var3)
	event.set_character_rotation(13, 0.0, var4, 0.0)
	var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_028.sound.json") or var11
	event.attach_object_handle_to_character(1, 1)
	event.set_object_handle_visible(1, 0)
	event.set_object_sequence_motion(0, "d02くもの巣取り", 2)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	wait_frames(20)
	event.play_sound_effect(var11, 0)
	event.set_character_active(1, 13)
	event.set_character_motion(13, "巣消える", 6)
	wait_objects(0)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_follow_camera(0)
	event.attach_object_handle_to_character(1, 1)
	event.set_object_handle_visible(1, 1)
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

return helper_09075129
