--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_8e4884b7()
	local var0: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var3: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or var0
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_3(1, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -75.0, -35.0, 1200.0)
		event.set_object_handle_rotation(0, 0.0, 3.1415927, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 7)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-127.01131, -7.1499996, 911.04)
		event.set_camera_sequence_look_at(-62.911304, 39.29, 1129.9199)
		event.mark_camera_sequence_fade_track()
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.play_sound_effect(var0, 1)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(1)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.copy_vector(rot_x, rot_y, var3)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var3 = vm.f32(vector_z - vm.f32(3.1415927))
		var3 = event.wrap_angle(var3) or var3
		event.rotate_object_sequence_eased(1, rot_x, rot_y, var3, 40, 0, 0.5)
		at = 2
		wait_objects(1)
		event.move_object_sequence_eased(3, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		at = 3
		wait_frames(20)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -75.0, -35.0, 1055.0, 30)
		event.set_object_handle_footstep_sound(0, 16)
		at = 4
		wait_objects(3)
		event.move_object_sequence_eased(3, pos_x, pos_y, pos_z, 32, 0, 0.5)
		at = 5
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 30)
		event.delay_object_sequence_position_track(0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -75.0, -25.0, 1015.0, 40)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		at = 6
		wait_objects(3)
		event.set_object_handle_footstep_sound(0, 0)
		event.rotate_object_sequence_eased(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
		at = 7
		wait_objects(1)
	end, function(received: { any }): boolean
		if at <= 1 then
			var3 = vm.f32(vector_z - vm.f32(3.1415927))
			helper_238b5abc(1)
		end
		if at <= 2 then
			wait_frames_skipping(20)
		end
		if at <= 3 then
			helper_238b5abc(3)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_238b5abc(3)
		end
		if at <= 6 then
			helper_238b5abc(1)
		end
		return true
	end)
	at = 8
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 1)
	at = 9
	vm.wait(9)
	event.set_object_handle_rotation(1, vector_x, vector_y, vector_z)
	event.set_object_handle_position(3, pos_x, pos_y, pos_z)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	helper_9dafbc83(-75.0, -10.0, 950.0, vm.f32(3.1415927))
	event.set_camera_position(-75.0, 50.0, 1030.0)
	event.set_camera_look_at(-75.0, 20.0, 950.0)
	event.reset_follow_camera(0)
	event.start_crossfade(30)
	event.finish_event()
end

return helper_8e4884b7
