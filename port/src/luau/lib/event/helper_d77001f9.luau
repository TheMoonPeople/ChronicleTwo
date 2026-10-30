--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_d77001f9(se_id: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	do
		local out1, out2, out3 = event.get_object_handle_position(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.set_object_sequence_position(3, pos_x - 50.0, pos_y, pos_z)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.08726647)
	event.set_object_sequence_rotation(5, 0.0, -1.5707964, 0.0)
	event.set_object_sequence_rotation(6, 0.0, 1.5707964, 0.0)
	event.set_object_sequence_rotation(22, 0.0, -1.5707964, 0.0)
	event.set_object_sequence_rotation(9, 0.0, 1.5707964, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.set_object_handle_footstep_sound(0, 6)
	event.set_object_handle_footstep_sound(1, 6)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 90)
	event.add_object_sequence_path_point(0, -160.36, 2.7, 634.04)
	event.add_object_sequence_path_point(0, -124.87, 2.7, 630.96)
	event.add_object_sequence_path_point(0, -89.31, 4.88, 627.74)
	event.add_object_sequence_path_point(0, -78.59, 9.51, 627.52)
	event.add_object_sequence_path_point(0, -58.26, 12.02, 627.52)
	event.add_object_sequence_path_point(0, -23.27, 22.08, 626.47)
	event.start_object_sequence_path(0)
	event.clear_object_sequence_path(1)
	event.set_object_sequence_path_frames(1, 90)
	event.add_object_sequence_path_point(1, -117.93, 2.01, 644.18)
	event.add_object_sequence_path_point(1, -87.39, 5.06, 643.55)
	event.add_object_sequence_path_point(1, -79.65, 10.25, 643.38)
	event.add_object_sequence_path_point(1, -61.53, 13.02, 643.01)
	event.add_object_sequence_path_point(1, -15.8, 26.38, 642.06)
	event.start_object_sequence_path(1)
	wait_frames(72)
	event.set_object_handle_footstep_sound(0, 4)
	event.set_object_handle_footstep_sound(1, 4)
	event.play_sound_effect(se_id, 12)
	event.rotate_object_sequence(6, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(22, 0.0, 0.0, 0.0, 30)
	event.rotate_object_sequence(9, 0.0, 0.0, 0.0, 30)
	wait_frames(20)
	event.rotate_object_sequence(0, 0.0, 3.03, 0.0, 30)
	wait_frames(10)
	wait_frames(15)
	event.play_sound_effect(se_id, 13)
	event.rotate_object_sequence(3, 0.0, 0.0, 0.0, 30)
	wait_frames(30)
	event.play_sound_effect(se_id, 14)
	event.move_object_sequence(3, pos_x, pos_y, pos_z, 60)
	wait_frames(60)
	wait_frames(15)
end

return helper_d77001f9
