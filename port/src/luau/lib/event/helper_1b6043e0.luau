--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0226fccb = require("@lib/event/helper_0226fccb")
local helper_042a5b29 = require("@lib/event/helper_042a5b29")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_6cf80642 = require("@lib/event/helper_6cf80642")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b76e3b36 = require("@lib/event/helper_b76e3b36")
local helper_d552d8eb = require("@lib/event/helper_d552d8eb")
local helper_f72a4299 = require("@lib/event/helper_f72a4299")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_1b6043e0()
	local flag: s32 = 0
	local time: f32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_save_flag(30, 0)
		at = 2
		helper_b76e3b36()
		helper_f72a4299()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		var2 = event.load_sound_effect_file_3(8, "snd2/sp/sp_018.sound.json") or var2
		event.play_sound_effect(var2, 0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 6)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_active(0, 0)
		time = event.get_scene_time_of_day() or time
		if time > 0.0 and time < 5.5 then
			event.set_object_handle_shadow_enabled(0, 0)
		end
		event.attach_object_handle_to_map_part_2(1, "p01_train01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 1.3, 8.0, 500.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_2(9, "p01_shadow-0")
		event.set_object_handle_visible(9, 0)
		event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m6")
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m7")
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m18")
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m19")
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m6")
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "train10-m7")
		event.set_object_sequence_object(7, 7)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_2(8, "p01_train01")
		event.create_effect("列車煙")
		event.set_effect_value(0, 8)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-185.19, 68.62, 1049.53)
		event.set_camera_sequence_look_at(140.3, 63.52, 109.43)
		event.fade_in_screen(30)
		event.enable_drama_skip()
		event.move_object_sequence_eased(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
		at = 3
		wait_objects(1)
		at = 4
		wait_frames(10)
		event.start_crossfade(30)
		event.set_object_handle_position(1, 1.3, 8.0, 700.0)
		helper_d552d8eb()
		event.set_save_flag(30, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_camera_sequence_position(-254.85, 60.24, -455.84)
		event.set_camera_sequence_look_at(-89.19, 67.53, -382.63)
		event.set_character_active(1, 0)
		event.set_object_sequence_position(0, -40.0, 45.6, -366.0)
		event.set_object_sequence_rotation(0, 0.0, -1.56, 0.0)
		at = 5
		wait_frames(15)
		var3 = event.get_sound_id(2) or var3
		event.play_sound_effect(var3, 106)
		event.rotate_object_sequence(2, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(3, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
		event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(6, 0.0, -1.5, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.5, 0.0, 30)
		at = 6
		wait_frames(15)
		event.set_object_sequence_motion(0, "走り", 0, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -68.89, 43.64, -366.0, 10)
		event.move_object_sequence(0, -131.89, 0.0, -366.0, 30)
		at = 7
		wait_frames(40)
		event.fade_out_screen(10)
		at = 8
		wait_frames(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_6cf80642()
		end
		if at <= 2 then
			helper_1ef0d4b2()
			helper_238b5abc(1)
		end
		if at <= 3 then
			wait_frames_skipping(10)
		end
		if at <= 4 then
			helper_042a5b29()
			wait_frames_skipping(15)
		end
		if at <= 5 then
			wait_frames_skipping(15)
		end
		if at <= 6 then
			wait_frames_skipping(40)
		end
		if at <= 7 then
			wait_frames_skipping(10)
		end
		return true
	end)
	at = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.clear_camera_sequence()
	event.stop_sound_effect(var2, 0)
	event.clear_effect_manager()
	event.set_object_handle_position(1, 1.3, 8.0, 700.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(9, 1)
	event.set_character_active(1, 0)
	helper_9dafbc83(-130.0, 0.0, -366.0, vm.f32(-1.57))
	event.set_camera_look_at(-130.0, 30.0, -366.0)
	event.set_camera_position(-270.0, 40.0, -366.0)
	flag = event.get_save_flag(30) or flag
	if flag == 0 then
		helper_d552d8eb()
	end
	helper_0226fccb()
	event.fade_in_screen(15)
end

return helper_1b6043e0
