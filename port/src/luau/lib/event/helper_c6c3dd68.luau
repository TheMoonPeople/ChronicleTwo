--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_c6c3dd68()
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local var4: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 11)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -20.0, 100.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.move_object_sequence(0, 0.0, -20.0, 37.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, 0.0, 40)
	event.move_object_sequence(0, 0.0, 0.0, -30.0, 40)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 120)
	event.set_object_sequence_motion(0, "立ち")
	event.delay_object_sequence_sound_track(0, 1)
	event.reset_object_sequence_dynamic_animation(0)
	event.start_crossfade(30)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(44.65, 9.01, 185.68)
	event.set_camera_sequence_look_at(9.77, 32.28, 31.49)
	wait_frames(60)
	event.set_object_handle_footstep_sound(0, 2)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(60)
	wait_camera()
	wait_objects(0)
	var4 = event.get_triggered_event_data_2(9) or var4
	event.attach_object_handle_to_map_part_3(0, var4, "d01w10_4-m0")
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
end

return helper_c6c3dd68
