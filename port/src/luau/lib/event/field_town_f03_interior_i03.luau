--!strict
--- Event helpers for the Field Town f03 Interior i03 scenes (Osmond's lab and the Lunatic Wisdom Institute).

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local field_town_f03_interior_i03 = {}

--- Spawns Osmond asleep in the lab unless the save flag marking him awake is set.
function field_town_f03_interior_i03.place_sleeping_osmond()
	local awake_flag: s32 = 0
	local osmond_slot: s32 = 0
	awake_flag = event.get_save_flag(408) or awake_flag
	if awake_flag == 0 then
		osmond_slot = event.find_scene_character_slot(301) or osmond_slot
		event.delete_character(osmond_slot)
		event.delete_villager(osmond_slot)
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/e400/e414/e414_osmond.gltf", "info", osmond_slot)
		event.set_character_active(osmond_slot)
		event.set_character_position(osmond_slot, -57.0056, 8.73, 219.919)
		event.set_character_rotation(osmond_slot, 0.0, -0.157, 0.0)
		event.set_character_motion(osmond_slot, "寝る", 4)
		event.set_scene_character_number(osmond_slot, 301)
	end
end

--- Plays event e412, in which the party talks with Osmond and receives the electric worm.
function field_town_f03_interior_i03.play_event_412()
	local osmond_slot: s32 = 0
	local item_sound_file: s32 = 0
	local event_sound_file: s32 = 0
	local playable_character: s32 = 0
	local owned_item_count: s32 = 0
	local invention_status: s32 = 0
	vm.section(function()
		event.fade_out_screen(0)
		event.set_camera_position(-141.13, 113.38, 123.83)
		event.set_camera_look_at(-246.69, 70.4, -33.02)
		event.set_save_flag(412, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		osmond_slot = event.find_scene_character_slot(301) or osmond_slot
		event.set_character_active(0, osmond_slot)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(54)
		event.play_music(0)
		event.load_map_sounds(4500)
		item_sound_file = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or item_sound_file
		event_sound_file = event.load_sound_effect_file_2(4500) or event_sound_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e412/")
		event.load_message_file(0, 5, "e412_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e412_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e412_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e412_osmond.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e412_mimizu_e.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_character_to_frame(34, "mimizu", 35)
		event.load_character(5, "e412_kareha.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.load_character(5, "e412_mimizu.gltf", "info", 37)
		event.set_character_active(0, 37)
		event.change_directory("")
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 38)
		event.set_character_active(0, 38)
		event.attach_object_handle_to_map_part_2(3, "p03_f03i0301-1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e412/e412_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e412/e412_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -292.9, 40.4, -58.14)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -276.7, 40.4, -72.82)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -57.0056, 8.73, 219.919)
		event.set_object_handle_rotation(2, 0.0, -0.157, 0.0)
		event.set_object_handle_motion(2, "寝る", 4)
		event.set_object_handle_footstep_sound(2, 6)
		event.set_character_position(36, -64.95, 10.43, 154.8)
		event.set_character_rotation(36, 0.0, 0.0, 0.0)
		event.set_object_handle_position(3, -57.0056, 1.362, 219.919)
		event.set_object_handle_rotation(3, 0.0, -0.157, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-141.13, 113.38, 123.83)
		event.set_camera_sequence_look_at(-246.69, 70.4, -33.02)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 80)
		event.add_object_sequence_path_point(0, -292.9, 40.4, -58.14)
		event.add_object_sequence_path_point(0, -292.45, 40.4, -27.37)
		event.add_object_sequence_path_point(0, -284.23, 32.04, 8.02)
		event.add_object_sequence_path_point(0, -277.65, 25.11, 28.59)
		event.start_object_sequence_path(0, 1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 80)
		event.add_object_sequence_path_point(1, -276.7, 40.4, -72.82)
		event.add_object_sequence_path_point(1, -272.25, 40.4, -27.73)
		event.add_object_sequence_path_point(1, -265.38, 32.95, 2.25)
		event.start_object_sequence_path(1, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.fade_in_screen(30)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-60.4, 30.75, 94.03)
		event.set_camera_sequence_look_at(-57.07, 26.26, 219.16)
		event.set_character_active(0, 0)
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_object_sequence_position(0, -68.91, 0.0, 141.39)
		event.set_object_sequence_rotation(0, 0.0, 0.19, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, -52.53, 0.0, 138.51)
		event.set_object_sequence_rotation(1, 0.0, -0.13, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		wait.frames(60)
		event.set_object_sequence_motion(2, "あくびin", 2)
		event.queue_object_sequence_next_motion(2, "あくびループ", 4)
		message.show_voiced(4120010)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "あくびout", 6)
		event.wait_object_sequence_motion_end(2)
		object.wait_until_done(2)
		event.play_sound_effect(event_sound_file, 2)
		event.rotate_object_sequence_eased(3, 0.0, -3.14, 0.0, 12, 0, 0.6)
		event.rotate_object_sequence_eased(2, 0.0, -3.14, 0.0, 12, 0, 0.6)
		event.set_object_sequence_motion(2, "回る", 6)
		event.queue_object_sequence_next_motion(2, "座る（イス）", 4)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "会話（座り）in", 6)
		event.queue_object_sequence_next_motion(2, "会話（座り）ループ", 6)
		event.queue_object_sequence_next_motion(2, "会話（座り）out", 6)
		event.queue_object_sequence_next_motion(2, "座る（イス）", 4)
		wait.frames(10)
		message.show_voiced(4120020)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-104.52, 93.75, 72.59)
		event.set_camera_sequence_look_at(-60.02, 16.31, 170.08)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_sequence_motion(2, "ジャンプ（イス）", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.delay_object_sequence_position_track(2, 14)
		event.jump_object_sequence(2, -58.85, 1.39, 188.8, -0.3, 10)
		event.delay_object_sequence_sound_track(2, 16)
		event.play_object_sequence_sound(2, event_sound_file, 3)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4120030)
		object.wait_until_done(0)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-31.93, 15.15, 145.12)
		event.set_camera_sequence_look_at(-57.86, 15.41, 187.43)
		message.show_voiced(4120040)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced(4120043)
		object.wait_until_done(2)
		message.show_voiced(4120046)
		event.set_camera_sequence_position(-61.55, 45.1, 105.25)
		event.set_camera_sequence_look_at(-58.99, 3.18, 187.49)
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4120050)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4120055)
		object.wait_until_done(0)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "手を取るin", 2)
		event.queue_object_sequence_next_motion(2, "手を取るループ", 4)
		event.delay_object_sequence_sound_track(2, 20)
		event.play_object_sequence_sound(2, event_sound_file, 4)
		message.show_voiced_with_button_prompt(4120060, -1, 0)
		object.wait_until_done(2)
		event.pause_music()
		wait.frames(10)
		event.play_sound_effect(event_sound_file, 5)
		wait.frames(10)
		event.set_character_active(1, 36)
		event.set_character_motion(36, "枯れ葉", 6)
		sound.play_voice_line(4120070, -1)
		wait.frames(10)
		sound.play_voice_line(4120080, -1)
		wait.frames(30)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_character_active(0, 36)
		event.set_camera_sequence_position(-67.89, 95.56, 17.98)
		event.set_camera_sequence_look_at(-0.19, 24.67, 90.58)
		event.play_music(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_position(0, 12.0, 0.0, 129.0)
		event.set_object_sequence_rotation(0, 0.0, -2.87, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(1, -12.0, 0.0, 129.0)
		event.set_object_sequence_rotation(1, 0.0, 2.87, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(2, 0.22, 16.25, 71.22)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "座る（作業）", 4)
		event.fade_in_screen(30)
		wait.frames(60)
		event.set_camera_sequence_position(-32.43, 23.17, 110.46)
		event.set_camera_sequence_look_at(-0.77, 29.3, 74.63)
		event.set_object_sequence_motion(2, "会話（座る作業）", 6)
		event.queue_object_sequence_next_motion(2, "座る（作業）", 4)
		message.show_voiced(4120090)
		message.show_voiced(4120095)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-0.62, 52.01, 189.19)
		event.set_camera_sequence_look_at(0.13, 6.74, 74.63)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4120100)
		object.wait_until_done(0)
		event.set_object_sequence_motion(2, "考えるin", 2)
		event.queue_object_sequence_next_motion(2, "考えるループ", 4)
		message.show_voiced(4120110)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-101.47, 52.81, 157.92)
		event.set_camera_sequence_look_at(19.07, 4.97, 86.26)
		event.set_object_sequence_motion(2, "ジャンプ（座り降りる作業）", 6)
		event.delay_object_sequence_position_track(2, 14)
		event.jump_object_sequence(2, 0.0, 0.0, 100.0, -0.3, 10)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, event_sound_file, 6)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "上→オズ", 6)
		event.delay_object_sequence_motion_track(0, 10)
		event.queue_object_sequence_next_motion(0, "オズ→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.delay_object_sequence_motion_track(1, 16)
		event.set_object_sequence_motion(1, "上から右見", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "立ち")
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 90)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 100.0)
		event.add_object_sequence_path_point(2, 30.37, 0.0, 110.52)
		event.add_object_sequence_path_point(2, 80.4, 0.0, 119.89)
		event.add_object_sequence_path_point(2, 145.29, 7.33, 119.81)
		event.add_object_sequence_path_point(2, 185.25, 18.79, 102.01)
		event.add_object_sequence_path_point(2, 222.42, 20.0, 55.61)
		event.add_object_sequence_path_point(2, 244.29, 20.0, 1.8)
		event.start_object_sequence_path(2, 1)
		event.delay_object_sequence_sound_track(2, 90)
		event.play_object_sequence_sound(2, event_sound_file, 7)
		object.wait_until_done(2)
		event.set_character_active(35)
		wait.frames(30)
		event.delay_object_sequence_motion_track(0, 76)
		event.set_object_sequence_motion(0, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_motion_track(1, 80)
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 86)
		event.set_object_sequence_motion(2, "ジャンプ（立ち上がる作業）", 2)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 90)
		event.add_object_sequence_path_point(2, 244.29, 20.0, 1.8)
		event.add_object_sequence_path_point(2, 222.42, 20.0, 55.61)
		event.add_object_sequence_path_point(2, 185.25, 18.79, 102.01)
		event.add_object_sequence_path_point(2, 145.29, 7.33, 119.81)
		event.add_object_sequence_path_point(2, 80.4, 0.0, 119.89)
		event.add_object_sequence_path_point(2, 30.37, 0.0, 110.52)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 100.0)
		event.start_object_sequence_path(2, 1)
		object.wait_until_done(2)
		event.delay_object_sequence_position_track(2, 10)
		event.jump_object_sequence(2, 0.22, 20.73, 71.22, -0.4, 10)
		event.rotate_object_sequence(2, 0.0, 3.12, 0.0, 10)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, event_sound_file, 8)
		object.wait_until_done(2)
		wait.frames(10)
		event.set_camera_sequence_position(12.14, 18.23, 108.78)
		event.set_camera_sequence_look_at(-2.76, 35.85, 71.25)
		event.set_character_active(1, 37)
		event.set_character_visible(37, 1, 1, 0.025)
		event.set_character_position(37, -11.36, 50.18, 62.56)
		event.set_character_rotation(37, 0.2, 0.38, 0.0)
		event.play_sound_effect(event_sound_file, 9)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "ミミズin", 6)
		event.queue_object_sequence_next_motion(2, "ミミズループ", 4)
		event.delay_object_sequence_sound_track(2, 20)
		event.play_object_sequence_sound(2, event_sound_file, 10)
		message.show_voiced(4120120)
		object.wait_until_done(2)
		event.set_character_active(0, 37)
		event.set_camera_sequence_position(-39.38, 71.0, 40.08)
		event.set_camera_sequence_look_at(-8.79, 33.78, 82.73)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4120130)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4120140)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-35.69, 30.29, 106.67)
		event.set_camera_sequence_look_at(-1.38, 34.39, 76.96)
		event.set_object_sequence_motion(2, "会話２", 6)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		message.show_voiced(4120150)
		message.show_voiced(4120155)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-1.94, 15.83, 175.3)
		event.set_camera_sequence_look_at(0.28, 29.07, 77.05)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "すごい！", 6)
		event.queue_object_sequence_next_motion(0, "すごい！L", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, event_sound_file, 11)
		event.set_object_sequence_motion(2, "エヘンin", 6)
		event.queue_object_sequence_next_motion(2, "エヘンループ", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4120160)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "上から右見", 6)
		event.queue_object_sequence_next_motion(1, "右向き会話", 6)
		event.queue_object_sequence_next_motion(1, "右向きL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4120170)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "すごい！戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向きL", 4)
		event.set_object_sequence_motion(1, "右から上見", 6)
		event.queue_object_sequence_next_motion(1, "上向きL", 6)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_motion(2, "エヘンとまるループ", 4)
		message.show_voiced_with_button_prompt(4120180, -1, 2)
		object.wait_until_done(2)
		wait.frames(60)
		event.set_camera_sequence_position(40.55, 84.1, 44.3)
		event.set_camera_sequence_look_at(3.43, 29.07, 90.92)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(2, "立ち2", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4120190)
		object.wait_until_done(0)
		event.set_object_sequence_motion(2, "会話２", 6)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		message.show_voiced(4120200)
		message.show_voiced(4120205)
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "なるほど", 6)
		event.queue_object_sequence_next_motion(0, "なるほどL", 4)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, event_sound_file, 12)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4120210)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_sequence_motion(1, "上から右見", 6)
		event.queue_object_sequence_next_motion(1, "右向き会話", 6)
		event.queue_object_sequence_next_motion(1, "右向きL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4120220)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-86.38, 18.21, 93.39)
		event.set_camera_sequence_look_at(7.04, 16.83, 103.58)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "上→左", 6)
		event.queue_object_sequence_next_motion(0, "左L", 4)
		event.set_object_sequence_motion(1, "上向くL", 5.0, 1)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "近オズ見", 6)
		event.queue_object_sequence_next_motion(1, "近オズ見L", 4)
		event.play_sound_effect(event_sound_file, 13)
		event.set_object_sequence_motion(2, "ジャンプ（立ち降りる作業）", 6)
		event.wait_object_sequence_motion_end(2)
		event.delay_object_sequence_position_track(2, 6)
		event.jump_object_sequence(2, -4.56, 0.0, 94.9, -0.3, 10)
		event.delay_object_sequence_rotation_track(2, 14)
		event.rotate_object_sequence(2, 0.0, -0.2, 0.0, 10)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "歩き")
		event.move_object_sequence(2, -9.95, 0.0, 115.32, 30)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "モニカ前in", 2)
		event.queue_object_sequence_next_motion(2, "モニカ前ループ", 4)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "会話（モニカ前）", 6)
		event.queue_object_sequence_next_motion(2, "モニカ前ループ", 4)
		message.show_voiced(4120230)
		event.set_object_sequence_motion(1, "近オズ見会話", 6)
		event.queue_object_sequence_next_motion(1, "近オズ見L", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4120240)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-2.05, 15.78, 172.81)
		event.set_camera_sequence_look_at(-0.14, 17.4, 100.38)
		event.set_object_sequence_motion(0, "オズ見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "下向くL", 4, -1.0, 1)
		event.set_object_sequence_position(2, 0.0, 0.0, 100.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "会話２", 6)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		message.show_voiced(4120250)
		message.show_voiced(4120255)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-25.65, 31.52, 124.65)
		event.set_camera_sequence_look_at(-0.14, 12.1, 100.38)
		message.show_voiced(4120260)
		event.set_camera_sequence_position(-41.74, 45.78, 69.3)
		event.set_camera_sequence_look_at(-3.45, 12.1, 116.17)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "会話２", 6)
		event.queue_object_sequence_next_motion(2, "立ち2", 4)
		message.show_voiced(4120270)
		object.wait_until_done(2)
		owned_item_count = event.get_owned_item_count(309) or owned_item_count
		if owned_item_count >= 1 then
			field_town_f03_interior_i03.play_osmond_talk_aquarium_owned()
		else
			invention_status = event.is_invention_created(309) or invention_status
			if invention_status >= 0 then
				field_town_f03_interior_i03.play_osmond_talk_aquarium_invented()
			else
				field_town_f03_interior_i03.play_osmond_talk_no_aquarium()
			end
		end
		event.set_camera_sequence_position(-5.15, 15.19, 86.26)
		event.set_camera_sequence_look_at(13.27, 25.71, 128.54)
		event.move_camera_sequence_eased(0.51, 18.67, 99.25, 13.27, 25.71, 128.54, 90, 2, 0.3)
		event.detach_character_from_frame(35)
		if playable_character == 0 then
			event.attach_character_to_frame(0, "item", 35)
		else
			event.attach_character_to_frame(32, "item", 35)
		end
		event.set_object_sequence_motion(0, "ミミズゲット", 4)
		event.pause_music()
		event.set_character_active(0, 34)
		event.set_character_active(1, 38)
		event.set_character_position(38, 17.1, 30.73, 123.76)
		event.set_character_rotation(38, 0.0, 0.48, 0.0)
		event.set_character_motion(38, "発動", 6)
		wait.frames(2)
		event.play_sound_effect(item_sound_file, 0)
		wait.frames(120)
		event.play_sound_effect(event_sound_file, 14)
		inventory.announce_received(360, 1)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.play_music(0)
	event.stop_sound_effect(item_sound_file, 0)
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.load_message_file(0, -1)
	event.set_character_active(osmond_slot)
	event.set_object_handle_rotation(3, 0.0, -0.157, 0.0)
	inventory.resolve_overflow_alt(0)
	character.place_standing_and_reset_cloth(vm.f32(-15.3), 0.0, vm.f32(129.1), vm.f32(-1.71))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Plays event e414, in which the party walks in and talks.
function field_town_f03_interior_i03.play_event_414()
	local playable_character: s32 = 0
	vm.section(function()
		event.set_camera_position(-141.13, 113.38, 123.83)
		event.set_camera_look_at(-246.69, 70.4, -33.02)
		event.set_save_flag(414, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e414/")
		event.load_message_file(0, 5, "e414_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e414_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e414_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e414/e414_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e414/e414_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, -292.9, 40.4, -58.14)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -276.7, 40.4, -72.82)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-141.13, 113.38, 123.83)
		event.set_camera_sequence_look_at(-246.69, 70.4, -33.02)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 80)
		event.add_object_sequence_path_point(0, -292.9, 40.4, -58.14)
		event.add_object_sequence_path_point(0, -292.45, 40.4, -27.37)
		event.add_object_sequence_path_point(0, -284.23, 32.04, 8.02)
		event.add_object_sequence_path_point(0, -277.65, 25.11, 28.59)
		event.start_object_sequence_path(0, 1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 80)
		event.add_object_sequence_path_point(1, -276.7, 40.4, -72.82)
		event.add_object_sequence_path_point(1, -272.25, 40.4, -27.73)
		event.add_object_sequence_path_point(1, -265.38, 32.95, 2.25)
		event.start_object_sequence_path(1, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.fade_in_screen(30)
		object.wait_until_done(1)
		event.set_camera_sequence_position(-32.57, 31.52, 76.71)
		event.set_camera_sequence_look_at(-55.79, 32.69, 217.54)
		event.set_character_active(0, 0)
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.set_object_sequence_position(0, -66.07, 0.0, 134.78)
		event.set_object_sequence_rotation(0, 0.0, -0.13, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, -48.48, 0.0, 138.36)
		event.set_object_sequence_rotation(1, 0.0, -0.13, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		message.show_voiced(4140010)
		event.set_camera_sequence_position(-26.03, 73.06, 273.78)
		event.set_camera_sequence_look_at(-57.55, 11.55, 129.5)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向く会話", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4140020)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4140030)
		object.wait_until_done(1)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(-92.0, 0.0, 117.0, vm.f32(0.59))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Plays event e428, in which Chap hands the party the translation device.
function field_town_f03_interior_i03.play_event_428()
	local researcher_slot: s32 = 0
	local item_sound_file: s32 = 0
	local event_sound_file: s32 = 0
	local playable_character: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.set_save_flag(428, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		researcher_slot = event.find_scene_character_slot(303) or researcher_slot
		event.set_character_active(0, researcher_slot)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(54)
		event.play_music(0)
		event.load_map_sounds(4506)
		item_sound_file = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or item_sound_file
		event_sound_file = event.load_sound_effect_file_2(4506) or event_sound_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e428/")
		event.load_message_file(0, 5, "e428_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e428_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e428_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e428_chap.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e428_lunaken.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e428_honyaku.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_character_to_frame(35, "h", 36)
		event.load_character(5, "e434_honyaku_Y.gltf", "info", 37)
		event.set_character_active(0, 37)
		image_block = event.load_event_image_4(5, "e428_1.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e42801", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e42802", image_block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(5, 1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.change_directory("")
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 38)
		event.set_character_active(0, 38)
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e428/e428_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e428/e428_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		if playable_character == 0 then
			event.attach_character_to_frame(0, "item", 37)
		else
			event.attach_character_to_frame(32, "item", 37)
		end
		event.set_object_handle_position(0, 20.0, 69.1, -210.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 0.0, 69.1, -210.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -208.12, 20.0, 88.84)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 6)
		event.set_object_handle_position(3, -55.15, 1.09, 220.25)
		event.set_object_handle_rotation(3, 0.0, 1.08, 0.0)
		event.set_object_handle_motion(3, "座る", 4)
		event.set_object_handle_footstep_sound(3, 6)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(11.21, 73.31, -143.14)
		event.set_camera_sequence_look_at(10.97, 89.26, -210.05)
		event.fade_in_screen(30)
		wait.frames(30)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(0, 1, "口とじ～半口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(1, 1, "口とじ～半口")
		wait.frames(30)
		event.set_camera_sequence_position(-2.42, 119.18, -230.92)
		event.set_camera_sequence_look_at(-49.1, 99.28, -160.19)
		event.move_camera_sequence_eased(-2.42, 119.18, -230.92, 29.39, 99.28, -151.85, 60, 0, 1.0)
		camera.wait_until_done()
		event.set_camera_sequence_position(333.36, 139.53, -117.52)
		event.set_camera_sequence_look_at(202.7, 64.84, 9.49)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_position(1, 263.03, 26.3, 11.44)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 160)
		event.set_object_sequence_motion(1, "立ち")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 160)
		event.add_object_sequence_path_point(1, 263.03, 29.31, 11.44)
		event.add_object_sequence_path_point(1, 239.48, 10.51, 56.28)
		event.add_object_sequence_path_point(1, 190.07, -0.0, 93.17)
		event.add_object_sequence_path_point(1, 133.12, -0.0, 104.78)
		event.start_object_sequence_path(1, 1)
		event.set_object_sequence_position(0, 280.36, 37.89, -11.47)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 180)
		event.set_object_sequence_motion(0, "立ち")
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 180)
		event.add_object_sequence_path_point(0, 280.36, 40.89, -11.47)
		event.add_object_sequence_path_point(0, 267.35, 24.37, 25.15)
		event.add_object_sequence_path_point(0, 235.12, 10.0, 77.4)
		event.add_object_sequence_path_point(0, 191.58, -0.0, 108.67)
		event.add_object_sequence_path_point(0, 159.8, -0.0, 123.59)
		event.add_object_sequence_path_point(0, 129.32, -0.0, 127.59)
		event.start_object_sequence_path(0, 1)
		wait.frames(60)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 140)
		event.add_object_sequence_path_point(2, -208.12, 20.0, 88.84)
		event.add_object_sequence_path_point(2, -177.39, 16.54, 118.19)
		event.add_object_sequence_path_point(2, -136.65, 4.85, 136.99)
		event.add_object_sequence_path_point(2, -106.68, -0.0, 149.15)
		event.add_object_sequence_path_point(2, -77.88, -0.0, 145.09)
		event.start_object_sequence_path(2, 1)
		object.wait_until_done(2)
		event.set_camera_sequence_position(140.48, 39.87, 119.98)
		event.set_camera_sequence_look_at(53.59, 6.42, 120.03)
		event.set_object_sequence_position(0, 100.0, 0.0, 130.0)
		event.set_object_sequence_rotation(0, 0.0, -1.69, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 100.0, 0.0, 110.0)
		event.set_object_sequence_rotation(1, 0.0, -1.45, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 0.0, 0.0, 120.0)
		event.set_object_sequence_rotation(2, 0.0, 1.57, 0.0)
		event.move_object_sequence(2, 60.0, 0.0, 120.0, 90)
		event.set_object_sequence_motion(2, "歩き（手振り）", 4)
		event.queue_object_sequence_next_motion(2, "歩き", 4)
		event.delay_object_sequence_motion_track(2, 23)
		event.set_object_sequence_motion(2, "立ち")
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4280005)
		object.wait_until_done(2)
		wait.frames(10)
		event.set_camera_sequence_position(88.52, 13.64, 103.92)
		event.set_camera_sequence_look_at(61.13, 17.27, 120.58)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4280010)
		object.wait_until_done(2)
		event.set_camera_sequence_position(25.57, 38.04, 119.09)
		event.set_camera_sequence_look_at(88.34, 14.0, 120.01)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おどろき顔")
		event.set_object_handle_texture_animation(1, 1, "おどろき目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4280020)
		event.move_object_sequence(2, 87.17, 0.0, 113.28, 40)
		event.rotate_object_sequence(2, 0.0, 1.69, 0.0, 10)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "立ち")
		object.wait_until_done(2)
		wait.frames(6)
		event.set_camera_sequence_position(65.28, 12.75, 87.66)
		event.set_camera_sequence_look_at(91.29, 17.73, 110.53)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "口とじ～半口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おどろき顔")
		event.set_object_handle_texture_animation(1, 1, "おどろき目～通常目")
		event.set_object_handle_texture_animation(1, 1, "口あけ～口とじ")
		event.play_sound_effect(event_sound_file, 2)
		event.set_object_sequence_motion(2, "指すin", 6)
		event.queue_object_sequence_next_motion(2, "指す（会話）", 6)
		event.queue_object_sequence_next_motion(2, "指すループ", 4)
		event.set_object_sequence_motion(1, "のけぞり", 6)
		event.queue_object_sequence_next_motion(1, "のけぞりL", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280030)
		object.wait_until_done(2)
		object.wait_until_done(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "まばたき目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4280040)
		event.set_camera_sequence_position(147.39, 61.78, 168.46)
		event.set_camera_sequence_look_at(74.68, 8.86, 114.05)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.move_object_sequence(2, 60.0, 0.0, 120.0, 40)
		event.rotate_object_sequence(2, 0.0, -1.31, 0.0, 10)
		event.delay_object_sequence_rotation_track(2, 20)
		event.rotate_object_sequence(2, 0.0, -1.6, 0.0, 10)
		event.set_object_sequence_motion(2, "立ち（後手）", 4)
		event.set_object_sequence_normal_drive(2)
		event.set_object_sequence_motion(2, "歩き（後手）")
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "立ち（後手）")
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280050)
		object.wait_until_done(2)
		event.set_camera_sequence_position(88.52, 13.64, 103.92)
		event.set_camera_sequence_look_at(61.13, 17.27, 120.58)
		event.play_sound_effect(event_sound_file, 3)
		event.rotate_object_sequence(2, 0.0, 1.57, 0.0, 20)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "立ち（後手）", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280055)
		object.wait_until_done(2)
		event.set_camera_sequence_position(148.59, 59.87, 169.61)
		event.set_camera_sequence_look_at(73.77, 3.31, 110.58)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4280060)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280070)
		event.set_camera_sequence_position(138.73, 11.1, 119.37)
		event.set_camera_sequence_look_at(58.75, 24.2, 119.86)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280080)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280085)
		object.wait_until_done(2)
		event.set_camera_sequence_position(92.81, 38.23, 102.21)
		event.set_camera_sequence_look_at(58.75, 11.98, 119.86)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280090)
		object.wait_until_done(2)
		event.set_camera_sequence_position(21.41, 40.91, 119.91)
		event.set_camera_sequence_look_at(94.63, 8.7, 119.61)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4280100)
		object.wait_until_done(0)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280110)
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4280120)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4280125)
		object.wait_until_done(0)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280130)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280135)
		object.wait_until_done(2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "まばたき目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4280140)
		event.set_camera_sequence_position(88.52, 13.64, 103.92)
		event.set_camera_sequence_look_at(61.13, 17.27, 120.58)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.delay_object_sequence_color_track(4, 30)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4280150)
		object.wait_until_done(4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4280160)
		event.delay_object_sequence_color_track(5, 30)
		event.set_object_sequence_color(5, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4280170)
		object.wait_until_done(5)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4280180)
		event.set_object_sequence_color(4, 128, 128, 128, 0)
		event.set_object_sequence_color(5, 128, 128, 128, 0)
		event.set_camera_sequence_position(92.81, 38.23, 102.21)
		event.set_camera_sequence_look_at(58.75, 11.98, 119.86)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280190)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280200)
		object.wait_until_done(2)
		event.set_camera_sequence_position(131.77, 54.55, 45.18)
		event.set_camera_sequence_look_at(63.6, 14.05, 123.57)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280210)
		event.play_sound_effect(event_sound_file, 4)
		event.set_object_sequence_motion(2, "歩き")
		event.delay_object_sequence_motion_track(2, 46)
		event.set_object_sequence_motion(2, "立ち")
		event.move_object_sequence(2, 20.0, 0.0, 120.0, 46)
		event.rotate_object_sequence(2, 0.0, -1.57, 0.0, 10)
		object.wait_until_done(2)
		wait.frames(8)
		event.set_object_sequence_motion(2, "向く（研究員）in", 6)
		event.queue_object_sequence_next_motion(2, "向く（研究員）ループ", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280220)
		object.wait_until_done(2)
		message.show_voiced(4280230)
		event.set_camera_sequence_position(42.44, 8.84, 186.99)
		event.set_camera_sequence_look_at(10.97, 20.1, 123.47)
		event.set_object_sequence_position(3, -3.58, 0.0, 164.54)
		event.set_object_sequence_rotation(3, 0.0, 2.64, 0.0)
		event.move_object_sequence(3, 8.02, 0.0, 141.96, 30)
		event.set_object_sequence_motion(3, "歩き", 4)
		event.delay_object_sequence_motion_track(3, 30)
		event.set_object_sequence_motion(3, "立ち(下向き）")
		event.set_object_sequence_motion(2, "立ち（見上げ）", 4)
		event.set_object_sequence_rotation(2, 0.0, -1.09, 0.0)
		object.wait_until_done(3)
		event.set_object_sequence_motion(2, "会話（見上げ）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（見上げ）", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280240)
		object.wait_until_done(2)
		event.set_object_sequence_motion(3, "はっ", 6)
		event.queue_object_sequence_next_motion(3, "立ち(下向き）", 4)
		message.show_voiced(4280250)
		object.wait_until_done(3)
		event.move_object_sequence(3, -70.0, 0.0, 141.96, 40)
		event.rotate_object_sequence(3, 0.0, -1.57, 0.0, 8)
		event.set_object_sequence_motion(3, "走り")
		object.wait_until_done(3)
		event.set_object_sequence_motion(3, "立ち")
		event.set_character_active(36)
		event.set_object_sequence_rotation(3, 0.0, 1.57, 0.0)
		wait.frames(30)
		event.set_object_sequence_motion(3, "走り", 4)
		event.delay_object_sequence_motion_track(3, 40)
		event.set_object_sequence_motion(3, "立ち(持ち）")
		event.move_object_sequence(3, 12.68, 0.0, 141.55, 40)
		event.delay_object_sequence_rotation_track(3, 32)
		event.rotate_object_sequence(3, 0.0, 2.64, 0.0, 8)
		object.wait_until_done(3)
		wait.frames(6)
		event.play_sound_effect(event_sound_file, 5)
		event.set_object_sequence_motion(3, "渡すin", 6)
		event.queue_object_sequence_next_motion(3, "渡すループ", 4)
		event.set_object_sequence_motion(2, "受け取るin", 6)
		event.queue_object_sequence_next_motion(2, "受け取るループ", 4)
		object.wait_until_done(3)
		event.detach_character_from_frame(36)
		event.attach_character_to_frame(34, "h", 36)
		event.set_object_sequence_motion(3, "渡すout", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280260)
		object.wait_until_done(3)
		event.set_object_handle_position(3, -55.15, 1.09, 220.25)
		event.set_object_handle_rotation(3, 0.0, 1.08, 0.0)
		event.set_object_handle_motion(3, "座る", 4)
		event.set_camera_sequence_position(16.79, 44.45, 119.66)
		event.set_camera_sequence_look_at(102.21, 4.83, 119.41)
		event.set_object_sequence_rotation(2, 0.0, 1.47, 0.0)
		event.set_object_sequence_position(2, 50.0, 0.0, 120.0)
		event.move_object_sequence(2, 80.0, 0.0, 127.0, 46)
		event.set_object_sequence_motion(2, "歩き（持ち）", 4)
		event.delay_object_sequence_motion_track(2, 46)
		event.set_object_sequence_motion(2, "立ち（持ち）")
		object.wait_until_done(2)
		wait.frames(4)
		event.play_sound_effect(event_sound_file, 6)
		event.set_object_sequence_motion(2, "渡すin", 6)
		event.queue_object_sequence_next_motion(2, "渡すループ", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280270)
		event.set_object_sequence_motion(0, "うけとる", 6)
		event.queue_object_sequence_next_motion(0, "うけとるL", 4)
		object.wait_until_done(0)
		event.play_sound_effect(event_sound_file, 7)
		wait.frames(10)
		event.set_camera_sequence_position(61.46, 21.85, 115.36)
		event.set_camera_sequence_look_at(100.98, 26.73, 130.47)
		event.move_camera_sequence_eased(70.43, 23.74, 118.79, 100.98, 26.73, 130.47, 90, 2, 0.3)
		event.set_object_sequence_position(2, 60.0, 0.0, 120.0)
		event.set_object_sequence_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(37)
		event.set_object_sequence_motion(0, "ほんやく機ゲット", 4, -1.0, 1)
		event.pause_music()
		event.set_character_active(1, 38)
		event.set_character_position(38, 93.41, 28.09, 127.58)
		event.set_character_rotation(38, 0.0, 1.2, 0.0)
		event.set_character_motion(38, "発動", 6)
		wait.frames(2)
		event.play_sound_effect(item_sound_file, 0)
		wait.frames(120)
		event.play_sound_effect(event_sound_file, 8)
		inventory.announce_received(373, 1)
		event.set_character_active(0, 37)
		event.set_character_active(0, 36)
		event.set_character_active(0, 38)
		event.play_music(0)
		event.set_camera_sequence_position(123.51, 47.51, 60.57)
		event.set_camera_sequence_look_at(72.34, -0.96, 139.59)
		event.set_object_sequence_motion(0, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4280280)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280290)
		event.set_camera_sequence_position(88.52, 13.64, 103.92)
		event.set_camera_sequence_look_at(61.13, 17.27, 120.58)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280300)
		object.wait_until_done(2)
		event.set_camera_sequence_position(25.57, 38.04, 119.09)
		event.set_camera_sequence_look_at(88.34, 14.0, 120.01)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		message.show_voiced(4280310)
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "考える", 6)
		event.queue_object_sequence_next_motion(0, "考えるL", 4)
		event.set_mouth_texture_animations(0, "真剣口パク")
		message.show_voiced(4280320)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "考える戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		message.show_voiced(4280330)
		event.set_object_sequence_motion(2, "またねin", 6)
		event.queue_object_sequence_next_motion(2, "またねループ", 4)
		event.set_mouth_texture_animations(2, "わらい口パク")
		message.show_voiced(4280340)
		object.wait_until_done(2)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(item_sound_file, 0)
	event.play_music(0)
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	inventory.resolve_overflow_alt(0)
	event.set_character_active(researcher_slot)
	character.place_standing_and_reset_cloth(vm.f32(136.9), 0.0, vm.f32(92.6), -1.75)
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Plays event e468, in which the party and Osmond react excitedly and an item is received.
function field_town_f03_interior_i03.play_event_468()
	local osmond_slot: s32 = 0
	local event_sound_file: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		event.set_save_flag(468, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		osmond_slot = event.find_scene_character_slot(301) or osmond_slot
		event.set_character_active(0, osmond_slot)
		event.stop_music(0)
		event.load_map_sounds(4520)
		event_sound_file = event.load_sound_effect_file_2(4520) or event_sound_file
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e468/")
		event.load_message_file(0, 5, "e468_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e468_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e468_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e468_osmond.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e468/e468_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e468/e468_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.load_item_model(5, 154, "info", 35)
		event.set_character_active(35)
		event.set_object_handle_position(0, -247.64, 8.6, 49.13)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_handle_position(1, -282.38, 14.67, 40.57)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(1, 6)
		event.set_object_handle_position(2, -89.55, 0.0, 80.94)
		event.set_object_handle_rotation(2, 0.0, 1.56, 0.0)
		event.set_object_handle_footstep_sound(2, 6)
		event.set_character_position(35, 7.23, 29.01, 8.69)
		event.set_character_rotation(35, 0.0, -0.6, 0.0)
		event.set_character_motion(35, "立ち-足", 5)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(3.28, 114.18, 221.29)
		event.set_camera_sequence_look_at(-125.61, 36.71, 82.9)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 80)
		event.add_object_sequence_path_point(0, -247.64, 8.6, 49.13)
		event.add_object_sequence_path_point(0, -235.43, 0.0, 70.71)
		event.add_object_sequence_path_point(0, -190.96, 0.0, 91.56)
		event.start_object_sequence_path(0, 1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 80)
		event.set_object_sequence_motion(0, "立ち")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -282.38, 14.67, 40.57)
		event.add_object_sequence_path_point(1, -272.58, 6.9, 61.69)
		event.add_object_sequence_path_point(1, -240.47, 0.0, 89.87)
		event.add_object_sequence_path_point(1, -204.44, 0.0, 106.62)
		event.start_object_sequence_path(1, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		object.wait_until_done(1)
		event.set_object_sequence_motion(2, "回る", 2)
		event.queue_object_sequence_next_motion(2, "立ち")
		event.rotate_object_sequence(2, 0.0, -1.6, 0.0, 20)
		object.wait_until_done(2)
		message.show_voiced(4680010)
		message.show_voiced(4680015)
		event.set_camera_sequence_position(0.0, 56.0, 185.0)
		event.set_camera_sequence_look_at(0.0, 16.0, 36.0)
		event.set_object_sequence_position(0, 0.0, 0.0, 100.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(1, -25.0, 0.0, 100.0)
		event.set_object_sequence_rotation(1, 0.0, 2.9, 0.0)
		event.set_object_sequence_position(2, 25.0, 0.0, 100.0)
		event.set_object_sequence_rotation(2, 0.0, -2.9, 0.0)
		message.show_voiced(4680020)
		message.show_voiced(4680030)
		message.show_voiced(4680040)
		event.play_sound_effect(event_sound_file, 2)
		event.set_object_sequence_motion(0, "すごい！", 6)
		event.queue_object_sequence_next_motion(0, "すごい！L", 4)
		message.show_voiced(4680050)
		event.set_object_sequence_motion(2, "すごい！", 6)
		event.queue_object_sequence_next_motion(2, "すごい！L", 4)
		message.show_voiced(4680060)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "がっつL", 4)
		event.set_object_sequence_motion(2, "がっつ", 6)
		event.queue_object_sequence_next_motion(2, "がっつL", 4)
		wait.frames(8)
		event.play_sound_effect(event_sound_file, 3)
		object.wait_until_done(0)
		inventory.announce_received(154, 1)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
	event.set_character_active(osmond_slot)
	inventory.resolve_overflow_alt(0)
	event.play_music(0)
	character.place_standing_and_reset_cloth(vm.f32(-15.3), 0.0, vm.f32(129.1), vm.f32(-1.71))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- Plays Osmond's conversation for when the aquarium invention has been created but is not yet owned.
function field_town_f03_interior_i03.play_osmond_talk_aquarium_invented()
	event.set_camera_sequence_position(1.94, 46.13, 182.69)
	event.set_camera_sequence_look_at(0.3, 9.85, 111.43)
	message.show_voiced(4120320)
	event.set_camera_sequence_position(12.38, 21.89, 126.92)
	event.set_camera_sequence_look_at(0.56, 16.44, 101.56)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120330)
	message.show_voiced(4120335)
	object.wait_until_done(2)
	event.set_camera_sequence_position(0.07, 37.81, 61.37)
	event.set_camera_sequence_look_at(0.86, 4.93, 133.5)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120340)
	object.wait_until_done(2)
	event.set_object_sequence_motion(0, "オズ見会話", 6)
	event.queue_object_sequence_next_motion(0, "オズ見立ち", 4)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(4120350)
	object.wait_until_done(0)
end

--- Plays Osmond's conversation for when the player already owns the aquarium (item 309).
function field_town_f03_interior_i03.play_osmond_talk_aquarium_owned()
	event.set_camera_sequence_position(1.94, 46.13, 182.69)
	event.set_camera_sequence_look_at(0.3, 9.85, 111.43)
	message.show_voiced(4120280)
	event.set_camera_sequence_position(12.38, 21.89, 126.92)
	event.set_camera_sequence_look_at(0.56, 16.44, 101.56)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120290)
	message.show_voiced(4120295)
	object.wait_until_done(2)
	event.set_camera_sequence_position(0.07, 37.81, 61.37)
	event.set_camera_sequence_look_at(0.86, 4.93, 133.5)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120300)
	object.wait_until_done(2)
	event.set_object_sequence_motion(0, "オズ見会話", 6)
	event.queue_object_sequence_next_motion(0, "オズ見立ち", 4)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(4120310)
	object.wait_until_done(0)
end

--- Plays Osmond's conversation for when the player has neither the aquarium nor its invention.
function field_town_f03_interior_i03.play_osmond_talk_no_aquarium()
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(4120360)
	event.set_camera_sequence_position(61.53, 21.92, 103.15)
	event.set_camera_sequence_look_at(-3.45, 12.1, 116.17)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120370)
	message.show_voiced(4120375)
	object.wait_until_done(2)
	event.set_object_sequence_motion(0, "オズ見会話", 6)
	event.queue_object_sequence_next_motion(0, "オズ見立ち", 4)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(4120380)
	object.wait_until_done(0)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120390)
	object.wait_until_done(2)
	event.set_camera_sequence_position(11.42, 18.58, 127.72)
	event.set_camera_sequence_look_at(-0.07, 16.07, 102.57)
	event.set_object_sequence_motion(2, "考える（立ち）in", 6)
	event.queue_object_sequence_next_motion(2, "考える（立ち）ループ", 4)
	message.show_voiced(4120395)
	object.wait_until_done(2)
	event.set_object_sequence_motion(2, "考える（立ち）戻り", 6)
	event.queue_object_sequence_next_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120400)
	object.wait_until_done(2)
	event.set_camera_sequence_position(-29.49, 18.58, 77.42)
	event.set_camera_sequence_look_at(4.8, 16.07, 120.22)
	event.set_object_sequence_motion(0, "オズ見会話", 6)
	event.queue_object_sequence_next_motion(0, "オズ見立ち", 4)
	event.set_mouth_texture_animations(0, "わらい口パク")
	message.show_voiced(4120410)
	object.wait_until_done(0)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120420)
	object.wait_until_done(2)
	event.set_camera_sequence_position(11.42, 18.58, 127.72)
	event.set_camera_sequence_look_at(-0.07, 16.07, 102.57)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120430)
	object.wait_until_done(2)
	event.set_camera_sequence_position(-2.05, 15.78, 172.81)
	event.set_camera_sequence_look_at(-0.14, 17.4, 100.38)
	event.set_object_sequence_motion(2, "会話２", 6)
	event.queue_object_sequence_next_motion(2, "立ち2", 4)
	message.show_voiced(4120440)
	object.wait_until_done(2)
	event.set_object_sequence_motion(0, "オズ見会話", 6)
	event.queue_object_sequence_next_motion(0, "オズ見立ち", 4)
	event.set_mouth_texture_animations(0, "通常口パク")
	message.show_voiced(4120450)
	object.wait_until_done(0)
end

--- Prepares the map characters on entry by placing the sleeping Osmond.
function field_town_f03_interior_i03.setup_map()
	field_town_f03_interior_i03.place_sleeping_osmond()
end

--- Shows the dialogue of the Lunatic Wisdom Institute researcher the player talked to, chosen by character id and story flags.
function field_town_f03_interior_i03.talk_to_researcher()
	local player_slot: s32 = 0
	local villager_slot: s32 = 0
	local researcher_id: s32 = 0
	local end_mode: s32 = 0
	local flag_640: s32 = 0
	local flag_456: s32 = 0
	local flag_420: s32 = 0
	local flag_408: s32 = 0
	local invention_status: s32 = 0
	local electric_fish_made: s32 = 0
	local flag_640_late: s32 = 0
	local flag_616: s32 = 0
	local flag_600: s32 = 0
	local flag_448: s32 = 0
	local playable_character: s32 = 0
	local current_player_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local look_angle: f32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	researcher_id = event.get_triggered_event_data_2(14) or researcher_id
	print("talk_chara_id=", villager_slot, "talk_chara=", researcher_id, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, villager_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	end_mode = 0
	if researcher_id == 300 then
		flag_640 = event.get_save_flag(640) or flag_640
		if flag_640 == 0 then
			flag_456 = event.get_save_flag(456) or flag_456
			if flag_456 == 0 then
				event.open_message_window_2(
					0,
					"ん？キミは・・・？ここには、世界最高の研究機関\nルナティックウィズダム研究所が、できるはず\nだったんだ。<page>今では、こんなになってしまってるけどね。"
				)
			else
				event.open_message_window_2(
					0,
					"ルナ研のすばらしさは、ひとことでは\n言い尽くせないよ。キミが自分の目で\n確かめることだね。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"グリフォンを倒さないと本当の歴史を\n取り戻すことはできないんだ。<page>グリフォンの存在自体が、この歴史を\nゆがめてしまってるんだからね。"
			)
		end
	end
	if researcher_id == 301 then
		flag_420 = event.get_save_flag(420) or flag_420
		if flag_420 == 0 then
			flag_408 = event.get_save_flag(408) or flag_408
			if flag_408 == 0 then
				event.open_message_window_2(0, "グガー、グガー")
				end_mode = 2
			else
				invention_status = event.is_invention_created(309) or invention_status
				if invention_status < 0 then
					event.open_message_window_2(
						0,
						"アクアリウムを発明するヒントは\n木箱、窓、噴水だ。<page>おまえの町にも\nそれくらいはあるだろ。"
					)
				else
					electric_fish_made = event.get_save_data_value(2) or electric_fish_made
					if electric_fish_made == 0 then
						event.open_message_window_2(
							0,
							"アクアリウムの中の魚に「電気ミミズ」を\n食わせて、電気を帯びた魚をつくるんだ。\nそいつを例のシーグラに食わせる。<page>忘れるなよ。"
						)
					else
						event.open_message_window_2(
							0,
							"おっ、電気を帯びた魚はできたようだな。\nじゃ、あとはそいつをシーグラに食わせて\nみるんだ。ま、せいぜい、がんばってな。"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"お！成功したみたいだな。\nやはり、私の発明品は役に立つ。\nうむうむ。"
			)
		end
	end
	if researcher_id == 302 then
		event.open_message_window_2(
			0,
			"オズモンドといい、所長といい、\nこのルナ研は、変わり者が多いんだよな～。"
		)
	end
	if researcher_id == 303 then
		flag_640_late = event.get_save_flag(640) or flag_640_late
		if flag_640_late == 0 then
			flag_616 = event.get_save_flag(616) or flag_616
			if flag_616 == 0 then
				flag_600 = event.get_save_flag(600) or flag_600
				if flag_600 == 0 then
					flag_448 = event.get_save_flag(448) or flag_448
					if flag_448 == 0 then
						event.open_message_window_2(
							0,
							"シェルトーキーは、大切にしてくれよ。\nあれはルナ研の大事な発明品のひとつなんだ。"
						)
					else
						event.open_message_window_2(
							0,
							"時間がない。急いでくれ、ユリス、モニカ。\nグリフォンの軍勢がエイナたちに迫っている。\n恐らく、長くは持ちこたえられない・・・"
						)
					end
				else
					event.open_message_window_2(0, "グリフォンとはいったいどんな奴\nなんだろう・・・")
				end
			else
				event.open_message_window_2(
					0,
					"ラピス探しか・・・ラピスは古代の民によって\nつくられた英知の結晶だ。ルナ研の\nコンピュータ分析によって<page>七色蝶の森、ステラ渓谷、潮騒の洞窟、\nガンドール火山の４箇所に隠されている\nことがわかった。"
				)
				cutscene.face_each_other(player_slot, villager_slot, 0)
				message.say_bubble(0, -1, villager_slot, player_slot, 0)
				end_mode = 1
				event.open_message_window_2(
					0,
					"隠された場所の入り口には必ず、\n星がかたどられた紋章がついているはずだ。\n探してみてくれ。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"いよいよ、グリフォンを倒すときが来た。\n世界の運命はキミたちの双肩にかかっている。\n頼んだぞ！"
			)
		end
	end
	if researcher_id == 304 then
		event.open_message_window_2(
			0,
			"この研究所では、すべてが実力主義。\n能力があれば、たとえ子供であろうと\nトップに君臨することもできるのだ。"
		)
	end
	if researcher_id == 305 then
		event.open_message_window_2(
			0,
			"シーグラたちが運んでくるルナストーンは\n私たちの頭をスッキリさせて、研究に集中\nさせてくれる効果があるんだ。<page>ルナストーンの正体が何なのかは\n私たちもわからないんだけどね。"
		)
	end
	if researcher_id == 306 then
		event.open_message_window_2(
			0,
			"海の上にある研究施設なんてイカすだろ？\nこの研究所に入るためにどれだけ勉強した\nことか・・・"
		)
	end
	if researcher_id == 307 then
		event.open_message_window_2(
			0,
			"ところでキミ、このルナ研のデザイン、\nどう思う？<page>これじゃ、まるで遊園地じゃないかぁ？\nいったいダレの趣味なんだか・・・"
		)
	end
	if researcher_id == 308 then
		event.open_message_window_2(
			0,
			"いつか、私も所長を越えて、トップに\n立って見せるぞ。なにしろ、この研究所は\n実力の世界なんだから。"
		)
	end
	if researcher_id == 309 then
		event.open_message_window_2(
			0,
			"私は所長を尊敬しています。なんてったって、\nあの歳で、ベストセラー技術書「超科学者バイブル」\n全４０巻を書き上げた人だからな。"
		)
	end
	if researcher_id == 310 then
		event.open_message_window_2(
			0,
			"ボクまだ新人なんです。この研究所で\nいろんなことを学んで、立派な研究員に\nなりたいと思っています。<page>どうぞ、よろしくお願いします！"
		)
	end
	if researcher_id == 311 then
		event.open_message_window_2(
			0,
			"この研究所から見る海は\n最高だよ。<page>海の闇と空の闇が\n地平線のかなたで\n一体化しているんだ。"
		)
	end
	if researcher_id == 312 then
		event.open_message_window_2(
			0,
			"ここは、第２ラボ。<page>ルナ研は、\n研究室によって、\n研究内容が違うんだ。"
		)
	end
	if researcher_id == 313 then
		event.open_message_window_2(
			0,
			"ここルナ研は、夜の空間を\n作り出し、更にルナストーンの\n力を高めているんだ。"
		)
	end
	if researcher_id == 314 then
		event.open_message_window_2(
			0,
			"研究員なりたての頃は、どこがどの研究所なのか\nよく迷ったものだ。君もそうだろ。\nでは、覚え方を教えてあげよう。<page>まず、第一ラボは赤、第二ラボは青、\n第三ラボは紫、第四ラボは緑だ。\n各々の研究所で色が違うって訳だ。"
		)
	end
	if researcher_id == 315 then
		event.open_message_window_2(
			0,
			"センターラボの上に輝くエンブレムは\n月をイメージして作られたらしい。"
		)
	end
	if researcher_id == 316 then
		event.open_message_window_2(
			0,
			"昔、シグーと言う海竜が、たくさん\nルナストーンを運んでくれたおかげで\nこの研究所が完成したと聞いたよ。<page>かしこい海竜がいるものだな。"
		)
	end
	if researcher_id == 317 then
		event.open_message_window_2(
			0,
			"内緒だぞ。<page>オズモンドさんの\n寒いギャグには、僕らも\n飽き飽きしてるんだ。"
		)
	end
	if researcher_id == 318 then
		event.open_message_window_2(
			0,
			"何を隠そう、この僕も\n電気ミミズの研究に携わったのだ。\n今は別の研究にとりかかっている。<page>何かって？秘密だよ。\n外部の者にそう簡単に\n言えるものではないのだ。"
		)
	end
	if researcher_id == 319 then
		event.open_message_window_2(
			0,
			"何だ？君たちも\n研究員になりたいのか？<page>この研究所に入るのは、\n並大抵のことじゃないんだ。\nものすごく倍率が高いしね。"
		)
	end
	if researcher_id == 320 then
		event.open_message_window_2(
			0,
			"このルナ研のデザインに\nケチをつける研究員もいるらしいが\n僕はイカしていると思うな・・・<page>ま、少数意見というのも\n事実だがな。"
		)
	end
	if researcher_id == 321 then
		event.open_message_window_2(
			0,
			"今、極秘の研究内容について\n話しているところなんだ。<page>ちょっと\n席を外してくれないか。"
		)
	end
	if researcher_id == 322 then
		event.open_message_window_2(
			0,
			"申し訳ない。今、\n極秘の研究内容について\n話し合っているんだ。<page>少しばかり厄介なことに\nなっていてね・・・"
		)
	end
	if researcher_id == 323 then
		event.open_message_window_2(
			0,
			"Ｄｒ．チャップは、\nもちろん才能もあるが\n努力の人でもある。<page>僕なんて\nまだまだ・・・"
		)
	end
	if researcher_id == 324 then
		event.open_message_window_2(
			0,
			"君か？オズモンドさんに\n反論したって話、聞いたけど。<page>別に非難してるわけじゃないぜ。\n感心してるんだ。疑うことから\n何かが生まれるってこともあるからね。"
		)
	end
	if researcher_id == 325 then
		event.open_message_window_2(
			0,
			"この派手な照明に\n目が慣れないって？<page>君たち、過去から来た人間には\n慣れるのに\n少し時間がかかるだろうな。"
		)
	end
	if researcher_id == 326 then
		event.open_message_window_2(
			0,
			"いやー、少しばかり\n頭を冷やしているところだよ。<page>あんまり根詰めてやっていると\n効率も悪くなるからね。"
		)
	end
	if researcher_id == 327 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
			event.open_message_window_2(
				0,
				"君もなかなかの発明家と聞いたよ。\nどうだ？大きくなったら、\nルナ研の研究員にならないか。<page>そうか、君が大人になる頃は\nまだ、このルナ研は、\n姿形が無いんだっけ・・・"
			)
		else
			event.open_message_window_2(
				0,
				"いろんな物を発明しちゃう男って、\nかっこいいと思わないかい？<page>おっと、でも僕に惚れてもムダだよ。\n僕は研究一筋なんだからね。"
			)
		end
	end
	if researcher_id == 328 then
		event.open_message_window_2(
			0,
			"画期的な発明を思いついたんだ。\nモンスターと人間が\n共存するためのシステムなんだ。<page>人間の言葉を理解する機械を\n作るのだ。"
		)
	end
	if researcher_id == 329 then
		event.open_message_window_2(
			0,
			"ルナ研の中枢は\nルナストーンによって\nできている。<page>ルナストーンが無ければ、たちまち\nこのルナ研の全てのシステムが\nストップしてしまうだろう。"
		)
	end
	if end_mode == 0 then
		cutscene.talk(villager_slot, -1, 0, 0)
	end
	if end_mode == 1 then
		message.say_bubble(0, -1, villager_slot, player_slot, 0)
		event.set_character_motion(villager_slot, "立ち")
		event.finish_event()
	end
	if end_mode == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		current_player_slot = event.get_player_character_slot() or current_player_slot
		do
			local out1, _, out3 = event.get_character_position(current_player_slot)
			player_x = out1 or player_x
			player_z = out3 or player_z
		end
		do
			local out1, _, out3 = event.get_character_position(villager_slot)
			villager_x = out1 or villager_x
			villager_z = out3 or villager_z
		end
		look_angle = event.get_look_angle(villager_x - player_x, villager_z - player_z) or look_angle
		character.turn_to_angle(current_player_slot, look_angle)
		event.set_character_rotation(current_player_slot, 0.0, look_angle, 0.0)
		event.set_character_motion(current_player_slot, "立ち")
		message.say_bubble(0, -1, villager_slot, current_player_slot, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, villager_slot)
end

return field_town_f03_interior_i03
