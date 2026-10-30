--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_31cdc3de()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var7: f32 = 0
	local pos_y_3: f32 = 0
	local var9: f32 = 0
	local var13: f32 = 0
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	pos_x = vm.f32(1707.99)
	pos_y = vm.f32(-8.19)
	pos_z = vm.f32(-424.51)
	rot_y = vm.f32(-2.3561945)
	event.set_character_motion(0, "立ち")
	event.load_character_motion_pack(5, "event/e400/e438/e438_mints.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, pos_x, pos_y, pos_z)
	event.set_object_sequence_rotation(0, 0.0, rot_y, 0.0)
	event.set_object_sequence_motion(0, "上見立ち", 4)
	event.load_character(5, "chara/c02_base.gltf", "info", 9)
	event.load_character_motion_pack(5, "event/e400/e438/e438_monica.gltf", "info", 9)
	event.set_character_active(9)
	event.attach_object_handle_to_character(1, 9)
	event.load_equipment_model(5, 1, 4, "info", 9)
	event.load_equipment_model(5, 1, 3, "info", 9)
	event.load_equipment_model(5, 1, 2, "info", 9, 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(5, 13)
	event.set_object_handle_visible(5, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, vm.f32(pos_x - 10.0) + 10.0, -5.03, vm.f32(pos_z + 10.0) + 10.0)
	event.set_object_sequence_rotation(1, 0.0, -2.6, 0.0)
	event.set_object_sequence_motion(1, "上見立ち", 4)
	event.reset_object_handle_dynamic_animation(1)
	event.load_character(5, "event/e400/e438/e438_paw.gltf", "info", 14)
	event.set_character_active(14)
	event.attach_object_handle_to_character(6, 14)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_position(6, vm.f32(pos_x + 10.0) + 10.0, -6.28, vm.f32(pos_z - 10.0) + 10.0)
	event.set_object_sequence_rotation(6, 0.0, -2.12, 0.0)
	event.set_object_sequence_motion(6, "見上げるL", 4)
	event.attach_object_handle_to_map_part_2(2, "p01_battleship")
	event.set_object_handle_visible(2, 0)
	pos_x_2 = vm.f32(1682.18)
	pos_y_2 = vm.f32(29.66)
	pos_z_2 = vm.f32(-487.46)
	var7 = vm.f32(1712.17)
	pos_y_3 = vm.f32(13.54)
	var9 = vm.f32(-420.33)
	var13 = vm.f32(19.26)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(pos_x_2, pos_y_2, pos_z_2)
	event.set_camera_sequence_look_at(var7, pos_y_3, var9)
	wait_frames(60)
	event.move_camera_sequence_look_at(var7, var13, var9, 210)
	event.move_camera_sequence_angle_height_distance(1.47, -10.82, 76.77, 210)
	wait_frames(210)
	wait_frames(150)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(13)
	event.delete_character(14)
	event.set_object_handle_visible(2, 1)
	event.finish_event()
end

return helper_31cdc3de
