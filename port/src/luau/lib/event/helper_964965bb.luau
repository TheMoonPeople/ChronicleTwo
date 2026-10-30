--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_964965bb()
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_handle_footstep_sound(0, 21)
	event.set_object_sequence_motion(0, "走り")
	event.set_object_sequence_position(0, 0.0, 0.0, 40.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.52, 68.45, 152.82)
	event.set_camera_sequence_look_at(-32.44, 32.28, 0.35)
	event.move_object_sequence(0, 0.0, 0.0, -140.0, 60)
	wait_frames(30)
	event.fade_out_screen(30)
	wait_frames(30)
	event.set_character_motion(0, "立ち")
	wait_frames(60)
	event.finish_event()
end

return helper_964965bb
