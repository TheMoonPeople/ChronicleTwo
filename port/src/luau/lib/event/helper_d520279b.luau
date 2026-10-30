--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b76e3b36 = require("@lib/event/helper_b76e3b36")
local helper_d552d8eb = require("@lib/event/helper_d552d8eb")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d520279b()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local rot_y: f32 = 0
	local angle: f32 = 0
	local var11: s32 = 0
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or var0
	helper_b76e3b36()
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m4")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m5")
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m4")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m5")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_handle_position(0, 2101.51, 40.82, 2060.52)
	event.set_object_handle_rotation(0, 0.0, -2.26, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_footstep_sound(0, 6)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(1)
		rot_y = out2 or rot_y
	end
	angle = vm.f32(rot_y - vm.f32(3.1415927))
	angle = event.wrap_angle(angle) or angle
	pos_x = vm.f32(vm.f32(vm.sin(angle) * 200.0) + pos_x_2)
	pos_y = pos_y_2
	pos_z = vm.f32(vm.f32(vm.cos(angle) * 200.0) + pos_z_2)
	event.set_object_handle_position(1, pos_x, pos_y, pos_z)
	event.move_object_sequence_eased(1, pos_x_2, pos_y_2, pos_z_2, 40, 2, 1.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(1514.63, 208.98, 2402.32)
	event.set_camera_sequence_look_at(1792.39, 155.32, 2165.78)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 1)
	event.play_sound_effect(var0, 0)
	event.fade_in_screen(30)
	wait_objects(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	helper_d552d8eb()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_sequence_position(1899.12, 13.68, 1889.27)
	event.set_camera_sequence_look_at(1958.62, 31.92, 1939.67)
	var11 = event.get_sound_id(2) or var11
	event.play_sound_effect(var11, 106)
	event.set_character_active(0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
	wait_frames(30)
	event.set_object_sequence_motion(0, "走り")
	event.delay_object_sequence_motion_track(0, 56)
	event.set_object_sequence_motion(0, "立ち")
	event.move_object_sequence(0, 2087.08, 40.82, 2048.3, 14)
	event.move_object_sequence(0, 2037.85, 0.0, 2005.99, 32)
	event.move_object_sequence(0, 2017.4, 0.0, 1988.67, 10)
	wait_frames(46)
	event.set_object_handle_footstep_sound(0, 16)
	event.fade_out_screen(15)
	wait_frames(15)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	helper_9dafbc83(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.clear_effect_manager()
	event.fade_in_screen(15)
end

return helper_d520279b
