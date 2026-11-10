--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_926d0569 = require("@lib/event/helper_926d0569")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_e787350a = require("@lib/event/helper_e787350a")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_5f7fbd09()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(624, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var0
		var1 = event.load_sound_effect_file_2(2841) or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.show_dungeon_status_bar(0, 1.0)
		event.change_directory("event/e600/e624/")
		event.load_message_file(0, 5, "e624_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e624_mints.gltf", "info", 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e624_monica.gltf", "info", 0)
		end
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e624_lapis_tuti.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_sequence_to_object_frame(1, 0, "item", 0.0, 0.0, 0.0, -1)
		event.change_directory("")
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, 0.0, 4.0, -920.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-40.26, 20.64, -866.67)
		event.set_camera_sequence_look_at(-1.7, 36.27, -951.09)
		event.move_camera_sequence_eased(-29.36, 23.4, -890.54, -1.7, 36.27, -951.09, 90, 2, 1.0)
		event.play_sound_effect(var1, 0)
		event.fade_in_screen(30)
		wait_frames(30)
		if active_chr_no == 0 then
			helper_4116e6bb(6240010)
		else
			helper_4116e6bb(6240020)
		end
		event.clear_camera_sequence()
		event.stop_sound_effect(var1, 0)
		event.pause_music()
		event.attach_object_handle_to_map_part_3(30, "p01_s1301-m-m", "s1301_3-m0")
		event.set_object_handle_visible(30, 0)
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		if active_chr_no == 0 then
			event.set_camera_sequence_position(0.0, 51.31, -963.58)
			event.set_camera_sequence_look_at(0.0, 28.64, -917.36)
			event.move_camera_sequence_eased(0.0, 46.94, -952.38, 0.0, 28.64, -917.36, 120, 2, 0.4)
			event.set_character_position(9, 7.74, 35.0, -918.0)
			event.set_character_rotation(9, 0.2, 0.24, 0.0)
		else
			event.set_camera_sequence_position(0.0, 53.31, -963.58)
			event.set_camera_sequence_look_at(0.0, 30.64, -917.36)
			event.move_camera_sequence_eased(0.0, 48.94, -952.38, 0.0, 30.64, -917.36, 120, 2, 0.4)
			event.set_character_position(9, -4.45, 37.0, -918.0)
			event.set_character_rotation(9, 0.2, -0.24, 0.0)
		end
		event.set_character_motion(9, "発動", 6)
		event.set_object_sequence_motion(0, "ラピスゲット", 4, -1.0, 1)
		wait_frames(2)
		event.play_sound_effect(var0, 0)
		wait_frames(120)
		event.play_sound_effect(var1, 1)
		helper_e787350a(365, 1)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.stop_sound_effect(var1, 0)
	event.stop_sound_effect(var0, 0)
	event.play_music(0)
	event.set_object_handle_visible(2, 1)
	event.set_object_handle_visible(3, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	helper_926d0569()
	helper_9dafbc83(0.0, 4.0, -920.0, 0.0)
	event.set_camera_look_at(0.0, 34.0, -920.0)
	event.set_camera_position(0.0, 44.0, -800.0)
	event.reset_follow_camera(0)
	helper_a87eb945(0)
end

return helper_5f7fbd09
