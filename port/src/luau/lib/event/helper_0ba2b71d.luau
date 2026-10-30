--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_0ba2b71d()
	local var0: s32 = 0
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	event.initialize_event()
	event.fade_out_screen(10)
	wait_frames(10)
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_032.sound.json") or var0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.load_character(5, "event/d03/p00_26a.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(1, 12)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_scene_status_flags(1, 12, 8, 1)
	event.load_item_model(5, 341, "info", 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(2, 13)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_position(0, 0.0, 0.0, 90.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "持ち上げ停止", 4, -1.0, 1)
	event.set_object_sequence_position(1, 0.0, 172.0, -192.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "肉つかみ", 4)
	event.set_object_sequence_position(2, 0.0, 31.0, 90.0)
	event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
	event.play_sound_effect(var0, 0)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-43.92, 11.08, 211.68)
	event.set_camera_sequence_look_at(-1.94, 50.04, 41.38)
	event.fade_in_screen(30)
	var6 = -6.0
	var7 = 16.0
	var8 = 0
	while var8 < 76 do
		event.add_object_sequence_position_offset(1, 0.0, var6, 3.8157895)
		var6 = vm.f32(var6 * vm.f32(0.958))
		var8 = var8 + 1
		vm.wait(2)
	end
	event.set_camera_sequence_position(-45.71, 26.34, 49.83)
	event.set_camera_sequence_look_at(1.77, 54.14, 135.5)
	event.fade_out_screen(30)
	event.add_object_sequence_position_offset(1, 0.0, 0.0, -8.0)
	var6 = vm.f32(0.14)
	var7 = vm.f32(1.6)
	var8 = 0
	while var8 < 30 do
		event.add_object_sequence_position_offset(0, 0.0, var6 + vm.f32(0.6), var7)
		event.add_object_sequence_position_offset(1, 0.0, var6, var7)
		event.add_object_sequence_position_offset(2, 0.0, var6 + vm.f32(0.6), var7)
		var6 = vm.f32(var6 * vm.f32(1.06))
		var7 = vm.f32(var7 * vm.f32(1.06))
		var8 = var8 + 1
		vm.wait(3)
	end
	event.delete_character(12)
	event.delete_character(13)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

return helper_0ba2b71d
