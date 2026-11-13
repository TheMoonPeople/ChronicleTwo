--!strict
--- Event scenes shared by the first boss room of Starlight Canyon.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local starlight_canyon_boss_1 = {}

--- Plays event 348, in which the party walks with Lin and looks up before the screen fades out.
function starlight_canyon_boss_1.play_lin_look_up_scene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(348, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		sound_bank = event.load_sound_effect_file_2(3829) or sound_bank
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 or playable_character ~= 1 then
			event.switch_dungeon_main_character(0)
			event.set_playable_character(0)
			playable_character = 0
		end
		event.change_directory("event/e300/e348/")
		event.load_message_file(0, 5, "e348.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e348_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e348_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e348_lin.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_mints.gltf", "info", 10)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 9)
			event.attach_object_handle_to_character(0, 9)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 9)
			event.load_equipment_model(5, 1, 4, "info", 9)
			event.load_equipment_model(5, 1, 3, "info", 9)
			event.load_equipment_model(5, 1, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.attach_object_handle_to_character(3, 1)
		event.set_object_handle_visible(3, 0)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 1521.47, -107.28, 771.74)
		event.set_object_handle_rotation(0, 0.0, -2.88, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 1505.66, -106.53, 783.49)
		event.set_object_handle_rotation(1, 0.0, 3.04, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 1506.3, -108.37, 803.96)
		event.set_object_handle_rotation(2, 0.0, -3.12, 0.0)
		event.set_object_handle_motion(2, "歩き", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "無表情")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_texture_animation(2, 1, "半口")
		event.move_object_sequence(0, 1521.47, -107.28, 731.74, 80)
		event.move_object_sequence(1, 1505.66, -106.53, 743.49, 80)
		event.move_object_sequence(2, 1506.3, -108.37, 763.96, 80)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1478.0, -94.44, 748.45)
		event.set_camera_sequence_look_at(1526.09, -83.38, 795.48)
		event.move_camera_sequence(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
		event.fade_in_screen(30)
		step = 2
		wait.frames(80)
		event.set_camera_sequence_position(1635.22, -45.35, 898.95)
		event.set_camera_sequence_look_at(1509.85, -91.47, 744.47)
		event.move_camera_sequence_eased(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
		event.set_object_sequence_position(0, 1522.58, -104.86, 733.22)
		event.set_object_sequence_rotation(0, 0.0, -2.52, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 1508.09, -104.9, 755.07)
		event.set_object_sequence_rotation(1, 0.0, -2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 1536.72, -109.15, 777.79)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.move_object_sequence(0, 1491.96, -99.81, 672.57, 90)
		event.move_object_sequence(1, 1473.85, -100.1, 691.32, 90)
		event.move_object_sequence(2, 1493.11, -100.84, 700.12, 90)
		step = 3
		message.show_voiced_for(3480010, 120)
		step = 4
		camera.wait_until_done()
		step = 5
		wait.frames(10)
		event.set_camera_sequence_position(1459.8, -32.33, 632.79)
		event.set_camera_sequence_look_at(1494.99, -96.61, 704.05)
		event.move_camera_sequence_eased(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "上見立ち", 4)
		step = 6
		camera.wait_until_done()
		step = 7
		wait.frames(10)
		event.set_camera_sequence_position(1518.17, -76.49, 671.12)
		event.set_camera_sequence_look_at(1493.05, -78.0, 693.7)
		event.set_object_sequence_position(2, 1501.04, -100.84, 688.87)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(1, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		step = 8
		message.show_voiced(3480020)
		event.fade_out_screen(30)
		step = 9
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			local _ = playable_character ~= 0
			local _ = playable_character ~= 1
			playable_character = 0
			wait.frames_skipping(80)
		end
		if step <= 2 then
			message.show_voiced_for_skipping(3480010, 120)
		end
		if step <= 3 then
			wait.background_load_skipping()
		end
		if step <= 4 then
			wait.frames_skipping(10)
		end
		if step <= 5 then
			wait.background_load_skipping()
		end
		if step <= 6 then
			wait.frames_skipping(10)
		end
		if step <= 7 then
			message.show_voiced_skipping(3480020)
		end
		if step <= 8 then
			wait.frames_skipping(30)
		end
		return true
	end)
	step = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.attach_object_handle_to_character(0, 1)
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_position(0, 1390.73, -76.07, 523.09)
	event.set_character_rotation(0, 0.0, -2.28, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Shows the continued recap text of event 356, the defeat of Gilton and the farewell to Crest, in a message window between fades.
function starlight_canyon_boss_1.show_event_356_recap()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.fade_in_screen(30)
	event.open_message_window_2(0, "Ｅ３５６　～ギルトーニ撃退・クレストとの別れ～(つづき)")
	message.show_and_wait(0, -1, 5, 0, 0)
	event.fade_out_screen(30)
	wait.frames(30)
	event.finish_event()
end

return starlight_canyon_boss_1
