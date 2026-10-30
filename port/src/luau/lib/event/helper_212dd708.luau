--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d355d559 = require("@lib/event/helper_d355d559")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_212dd708()
	local var0: s32 = 0
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local var5: s32 = 0
	event.initialize_event()
	event.start_crossfade(30)
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_048.sound.json") or var0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	var5 = event.get_triggered_event_data_2(9) or var5
	event.attach_object_handle_to_map_part_3(1, var5, "d07w10_2-m0")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, var5, "d07w10_5-m0")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, var5, "d07w10_4-m0")
	event.set_object_handle_visible(3, 0)
	event.set_object_handle_position(0, 0.0, 11.0, 23.0)
	event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_handle_motion(0, "バトル立ち", 4)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.set_object_handle_position(2, 0.0, 0.0, 0.0)
	event.play_sound_effect(var0, 0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.52, 68.45, 152.82)
	event.set_camera_sequence_look_at(-32.44, 32.28, 0.35)
	event.move_object_sequence_eased(0, 0.0, 11.0, -177.0, 40, 1, 1.0)
	if helper_f7fba8ce(world_coord_rot, 0.0, 1.0) == 0 then
		print("\n\n\nROT_0.0\n\n\n")
		event.move_object_sequence_eased(1, 0.0, 0.0, -200.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, -200.0, 40, 1, 1.0)
	end
	if helper_f7fba8ce(world_coord_rot, vm.f32(3.14), 1.0) == 0 then
		print("\n\n\nROT_3.14\n\n\n")
		event.move_object_sequence_eased(1, 0.0, 0.0, 200.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, 200.0, 40, 1, 1.0)
	end
	if helper_f7fba8ce(world_coord_rot, vm.f32(1.57), 1.0) == 0 then
		print("\n\n\nROT_1.57\n\n\n")
		event.move_object_sequence_eased(1, -200.0, 0.0, 0.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, -200.0, 0.0, 0.0, 40, 1, 1.0)
	end
	if helper_f7fba8ce(world_coord_rot, vm.f32(-1.57), 1.0) == 0 then
		print("\n\n\nROT_-1.57\n\n\n")
		event.move_object_sequence_eased(1, 200.0, 0.0, 0.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, 200.0, 0.0, 0.0, 40, 1, 1.0)
	end
	wait_frames(30)
	event.fade_out_screen(30)
	wait_frames(60)
	event.set_character_motion(0, "立ち")
	event.finish_event()
end

return helper_212dd708
