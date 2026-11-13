--!strict
--- Plays the flashback scenes that lead from the town into dungeon floor d05b01.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Plays the flashback cutscene in which the mother lies in bed and dies while her child calls out to her.
local function play_mother_deathbed_scene()
	local time_of_day: f32 = 0
	local sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(532, 1)
		time_of_day = event.get_scene_time_of_day() or time_of_day
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.load_map_sounds(5821)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_map_sounds(5821)
		sound_bank = event.load_sound_effect_file_2(5821) or sound_bank
		event.set_character_active(0, 0)
		event.change_directory("event/e500/e532/")
		event.load_message_file(0, 5, "e532.txt")
		event.load_character(5, "e532_y_guil.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e532_haha.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e532_bed.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_character_to_frame(10, "haha", 9)
		event.change_directory("")
		event.set_object_handle_position(0, 70.0, 0.0, 10.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "寝てる", 4)
		event.step_object_handle_motion(0)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "泣き目パチ")
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "寝てる", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "わらい顔")
		event.set_object_handle_texture_animation(1, 1, "くるし目パチ")
		event.set_object_handle_position(2, 70.0, 0.0, 10.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "寝てる", 4)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(39.84, 60.52, -60.15)
		event.set_camera_sequence_look_at(66.03, 22.1, 15.31)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320280)
		event.set_object_sequence_motion(0, "寝てる会話", 2)
		event.queue_object_sequence_next_motion(0, "寝てる", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5320290)
		object.wait_until_done(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_motion(0, "首ふる", 2)
		event.queue_object_sequence_next_motion(0, "寝てる", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5320295)
		object.wait_until_done(0)
		event.set_camera_sequence_position(44.6, 20.65, 33.29)
		event.set_camera_sequence_look_at(64.25, 16.57, 22.61)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "泣き目パチ")
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "苦しい", 2)
		event.queue_object_sequence_next_motion(1, "寝てる", 4)
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "くるし目パチ２")
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "くるし目パチ")
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "苦しい", 2)
		event.queue_object_sequence_next_motion(2, "寝てる", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320300)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320305)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320310)
		object.wait_until_done(1)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "苦しい", 2)
		event.queue_object_sequence_next_motion(1, "寝てる", 4)
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "くるし目パチ２")
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "くるし目パチ")
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "苦しい", 2)
		event.queue_object_sequence_next_motion(2, "寝てる", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320315)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "上向く", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(2, "上向く", 2)
		event.queue_object_sequence_next_motion(2, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320320)
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320323)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "上向く戻り", 2)
		event.queue_object_sequence_next_motion(1, "寝てる", 4)
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "前向き～左向き")
		event.set_object_sequence_texture_animation(1, 1, "前向き～左向き")
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "上向く戻り", 2)
		event.queue_object_sequence_next_motion(2, "寝てる", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320325)
		object.wait_until_done(1)
		event.set_camera_sequence_position(93.32, 20.1, 22.37)
		event.set_camera_sequence_look_at(63.34, 19.1, 24.49)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "わらい顔")
		event.set_object_handle_texture_animation(1, 1, "くるし目パチ")
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "泣き目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320330)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320335)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "泣き目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5320340)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_motion(0, "首ふる", 2)
		event.queue_object_sequence_next_motion(0, "寝てる", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5320345)
		object.wait_until_done(0)
		event.set_camera_sequence_position(44.6, 20.65, 33.29)
		event.set_camera_sequence_look_at(64.25, 16.57, 22.61)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(5320350)
		event.set_object_sequence_motion(1, "死", 2)
		event.queue_object_sequence_next_motion(1, "死L", 4)
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "ゆっくり目とじ")
		event.set_object_sequence_motion(2, "死", 2)
		event.queue_object_sequence_next_motion(2, "死L", 4)
		event.set_mouth_texture_animations(1, "わらい口パク２")
		message.show_voiced(5320360)
		object.wait_until_done(1)
		event.set_camera_sequence_position(93.32, 20.1, 22.37)
		event.set_camera_sequence_look_at(63.34, 19.1, 24.49)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.play_sound_effect(sound_bank, 11)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "泣き目～おどろき目")
		event.set_object_sequence_motion(0, "母さん！！", 6)
		event.queue_object_sequence_next_motion(0, "母さん！！L", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5320370)
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 12)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_motion(0, "目を開けて", 2)
		event.queue_object_sequence_next_motion(0, "目を開けてL", 4)
		event.set_object_sequence_motion(1, "目を開けて", 2)
		event.queue_object_sequence_next_motion(1, "目を開けてL", 4)
		event.set_object_sequence_motion(2, "目を開けて", 2)
		event.queue_object_sequence_next_motion(2, "目を開けてL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(5320375)
		vm.wait(30)
		vm.wait(31)
	end)
	vm.entry(32)
	event.cancel_drama_scene_skip()
	event.start_crossfade(60)
	event.set_time_of_day(time_of_day)
	event.set_time_of_day_advancing(1)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.clear_camera_sequence()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_active(0)
end

--- Plays the flashback cutscene in which the young Guiltoni opens the door and sits with his mother, ramping the message window colour for the closing lines.
local function play_door_scene()
	local sound_bank: s32 = 0
	local index: s32 = 0
	local ramp_value: f32 = 0
	local resume_point: number = 0
	vm.section(function()
		event.set_save_flag(536, 1)
		event.load_map_sounds(5824)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		resume_point = 1
		wait.for_frame_count(4)
		event.load_music(112)
		event.play_music(0)
		event.load_map_sounds(5824)
		sound_bank = event.load_sound_effect_file_2(5824) or sound_bank
		event.set_character_active(0, 0)
		event.change_directory("event/e500/e536/")
		event.load_message_file(0, 5, "e536.txt")
		event.load_character(5, "e536_y_guil.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e536_haha.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e536_door.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e536_chair.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 255, 255, 255, 255)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_map_part_2(4, "p01_s4901")
		event.set_object_handle_visible(4, 0)
		event.attach_object_handle_to_map_part_2(5, "p08_ai02a")
		event.set_object_handle_position(5, 0.0, 0.0, 10.0)
		event.attach_object_handle_to_map_part_3(5, "p08_ai02a", "ai020801-m")
		event.set_object_handle_visible(5, 0)
		event.set_scene_status_flags(1, 10, 64, 1)
		event.set_scene_status_flags(1, 11, 64, 1)
		event.set_object_handle_position(0, -33.0, 0.0, 71.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.step_object_handle_motion(0)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_sound_bank(0, sound_bank)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "わらい顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 15.0, 0.0, -24.400002)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(1, "座り", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -33.0, 0.0, 71.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_position(3, 10.0, 0.0, 4.0)
		event.set_object_handle_rotation(3, 0.0, -2.41, 0.0)
		event.enable_drama_skip()
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(0, "ドア開け", 6)
		event.queue_object_sequence_next_motion(0, "ドア開けL", 4)
		event.set_object_sequence_motion(2, "ドア開け", 6)
		event.queue_object_sequence_next_motion(2, "待機", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(61.97, 46.56, -61.97)
		event.set_camera_sequence_look_at(15.12, 25.71, 12.05)
		event.move_camera_sequence_eased(61.97, 46.56, -61.97, -5.06, 25.71, -5.5, 60, 2, 1.0)
		event.fade_in_screen(30)
		resume_point = 2
		wait.for_frame_count(20)
		event.set_object_sequence_motion(1, "左見る", 2)
		event.queue_object_sequence_next_motion(1, "左見るL", 4)
		resume_point = 3
		object.wait_until_done(0)
		resume_point = 4
		wait.for_frame_count(12)
		event.play_sound_effect(sound_bank, 8)
		event.set_mouth_texture_animations(0, "わらい口パク")
		resume_point = 5
		message.show_voiced(5360060)
		resume_point = 6
		camera.wait_until_done()
		event.set_camera_sequence_position(-34.76, 39.67, -42.6)
		event.set_camera_sequence_look_at(21.19, 24.21, -4.58)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "わらい顔")
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.play_sound_effect(sound_bank, 9)
		event.set_object_sequence_position(0, 10.0, 0.0, 4.0)
		event.set_object_sequence_rotation(0, 0.0, -2.41, 0.0)
		event.set_object_sequence_motion(0, "座る", 6)
		event.queue_object_sequence_next_motion(0, "座るL", 4)
		resume_point = 7
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "下向く", 2)
		event.queue_object_sequence_next_motion(0, "下向くL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		resume_point = 8
		message.show_voiced(5360070)
		event.set_mouth_texture_animations(0, "わらい口パク")
		resume_point = 9
		message.show_voiced(5360075)
		event.set_camera_sequence_position(34.3, 21.14, 15.6)
		event.set_camera_sequence_look_at(11.3, 24.63, -18.3)
		event.move_camera_sequence_eased(34.3, 21.14, 15.6, 3.12, 20.97, -11.09, 120, 2, 1.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "わらい顔")
		event.set_object_handle_texture_animation(0, 1, "目とじ～目あき")
		event.set_object_sequence_motion(0, "座り会話入り", 2)
		event.queue_object_sequence_next_motion(0, "座り会話", 4)
		event.delay_object_sequence_texture_animation_track(0, 20)
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "わらい口パク")
		resume_point = 10
		message.show_voiced(5360080)
		event.open_voice_stream_wave(1, 5360093)
		resume_point = 11
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.set_object_handle_texture_animation(0, 1, "わらい口パク")
		event.open_message_window_2(0, 5360085)
		message.open(0, -1, 8, 0, 0)
		resume_point = 12
		wait.for_frame_count(30)
		event.fade_out_screen(80, 255, 255, 255)
		resume_point = 13
		wait.for_frame_count(80)
		message.close(0)
		event.set_message_window_mode(0, 11)
		event.set_message_button_prompt(0, 0)
		event.fade_in_screen(0)
		event.set_event_sprite_draw_pass(0, 1)
		event.open_message_window_2(0, 5360090)
		event.set_message_draw_speed(0, 0)
		message.open(0, -1, 5, 0, 0)
		index = 0
		ramp_value = 0.0
		while index < 40 do
			event.set_message_window_option(0, 6, 0, ramp_value)
			event.set_message_window_option(0, 6, 1, 0)
			event.set_message_window_option(0, 6, 2, 0)
			ramp_value = vm.f32(ramp_value + vm.f32(3.2))
			index = index + 1
			resume_point = 14
			vm.wait(14)
		end
		resume_point = 15
		wait.for_frame_count(30)
		index = 0
		ramp_value = 0.0
		while index < 30 do
			event.set_message_window_option(0, 6, 0, 128)
			event.set_message_window_option(0, 6, 1, ramp_value)
			event.set_message_window_option(0, 6, 2, 0)
			ramp_value = vm.f32(ramp_value + vm.f32(4.266667))
			index = index + 1
			resume_point = 16
			vm.wait(16)
		end
		resume_point = 17
		wait.for_frame_count(30)
		index = 0
		ramp_value = 0.0
		while index < 30 do
			event.set_message_window_option(0, 6, 0, 128)
			event.set_message_window_option(0, 6, 1, 128)
			event.set_message_window_option(0, 6, 2, ramp_value)
			ramp_value = vm.f32(ramp_value + vm.f32(4.266667))
			index = index + 1
			resume_point = 18
			vm.wait(18)
		end
		resume_point = 19
		wait.for_frame_count(60)
		message.close(0)
		event.close_voice_stream(1)
		resume_point = 20
		wait.for_frame_count(30)
		event.open_voice_stream_wave(1, 5360095)
		resume_point = 21
		sound.wait_voice_stream_ready(1)
		event.open_message_window_2(0, 5360095)
		event.set_message_draw_speed(0, 0)
		message.open(0, -1, 5, 0, 0)
		index = 0
		ramp_value = 0.0
		while index < 90 do
			if index == 30 then
				event.play_voice_stream(1)
			end
			event.set_message_window_option(0, 6, 0, ramp_value)
			ramp_value = vm.f32(ramp_value + vm.f32(1.4222223))
			index = index + 1
			resume_point = 22
			vm.wait(22)
		end
		event.set_message_window_option(0, 6, 0, 128)
		resume_point = 23
		wait.for_frame_count(60)
		event.fade_out_music(30)
		event.fade_out_screen(30, 255, 255, 255)
		resume_point = 24
		wait.for_frame_count(30)
		message.close(0)
		event.set_message_button_prompt(0, 1)
		event.close_voice_stream(1)
	end, function(received: { any }): boolean
		if resume_point <= 1 then
			wait.skip_frame_count(20)
		end
		if resume_point <= 2 then
			cutscene.skip_command(0)
		end
		if resume_point <= 3 then
			wait.skip_frame_count(12)
		end
		if resume_point <= 4 then
			message.show_voiced_skipping(5360060)
		end
		if resume_point <= 5 then
			wait.background_load_skipping()
		end
		if resume_point <= 6 then
			cutscene.skip_command(0)
		end
		if resume_point <= 7 then
			message.show_voiced_skipping(5360070)
		end
		if resume_point <= 8 then
			message.show_voiced_skipping(5360075)
		end
		if resume_point <= 9 then
			message.show_voiced_skipping(5360080)
		end
		if resume_point <= 10 then
			cutscene.skip_command(1)
		end
		if resume_point <= 11 then
			message.open_skipping(0, -1, 8, 0, 0)
			wait.skip_frame_count(30)
		end
		if resume_point <= 12 then
			wait.skip_frame_count(80)
		end
		if resume_point <= 13 then
			message.close_skipping(0)
			message.open_skipping(0, -1, 5, 0, 0)
			index = 0
			ramp_value = 0.0
			ramp_value = vm.f32(ramp_value + vm.f32(3.2))
			local _ = index < 40
			index = index + 1
		end
		if resume_point <= 14 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 15 then
			index = 0
			ramp_value = 0.0
			ramp_value = vm.f32(ramp_value + vm.f32(4.266667))
			local _ = index < 30
			index = index + 1
		end
		if resume_point <= 16 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 17 then
			index = 0
			ramp_value = 0.0
			ramp_value = vm.f32(ramp_value + vm.f32(4.266667))
			local _ = index < 30
			index = index + 1
		end
		if resume_point <= 18 then
			wait.skip_frame_count(60)
		end
		if resume_point <= 19 then
			message.close_skipping(0)
			wait.skip_frame_count(30)
		end
		if resume_point <= 20 then
			cutscene.skip_command(1)
		end
		if resume_point <= 21 then
			message.open_skipping(0, -1, 5, 0, 0)
			index = 0
			ramp_value = 0.0
			ramp_value = vm.f32(ramp_value + vm.f32(1.4222223))
			local _ = index < 90
			local _ = index == 30
			index = index + 1
		end
		if resume_point <= 22 then
			wait.skip_frame_count(60)
		end
		if resume_point <= 23 then
			wait.skip_frame_count(30)
		end
		if resume_point <= 24 then
			message.close_skipping(0)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.clear_camera_sequence()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_active(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Plays the mother's deathbed flashback after a short pause.
function script.default_event()
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		wait.for_frame_count(30)
		checkpoint = 2
		play_mother_deathbed_scene()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				play_mother_deathbed_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the mother's deathbed flashback after a short pause.
function script.key_open()
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		wait.for_frame_count(30)
		checkpoint = 2
		play_mother_deathbed_scene()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				play_mother_deathbed_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the mother's deathbed scene and loads dungeon d05b01.
function script.cutscene_mother_deathbed()
	play_mother_deathbed_scene()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 561)
end
script[500] = script.cutscene_mother_deathbed

--- Plays the door scene and loads dungeon d05b01.
function script.cutscene_door_scene()
	play_door_scene()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 571)
end
script[510] = script.cutscene_door_scene

return script
