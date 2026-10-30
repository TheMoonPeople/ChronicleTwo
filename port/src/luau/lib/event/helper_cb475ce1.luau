--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_cb475ce1()
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local angle: f32 = 0
	event.initialize_event()
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, angle =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, angle)
	angle = vm.f32(angle + vm.f32(3.1415927))
	angle = event.wrap_angle(angle) or angle
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, angle)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_handle_footstep_sound(0, 18)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(56.71, 54.78, -129.16)
	event.set_camera_sequence_look_at(-1.53, 22.52, 48.82)
	event.move_object_sequence(0, 0.0, 0.0, 155.0, 40)
	event.set_object_sequence_motion(0, "走り", 4)
	event.delay_object_sequence_motion_track(0, 40)
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(10)
	event.fade_out_screen(30)
	wait_frames(30)
	wait_frames(60)
	event.finish_event()
end

return helper_cb475ce1
