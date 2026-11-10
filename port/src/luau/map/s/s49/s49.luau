--!strict
-- map/s/s49/s49.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b8bc()
	local time: f32 = 0
	local var1: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(532, 1)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.load_map_sounds(5821)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_map_sounds(5821)
		var1 = event.load_sound_effect_file_2(5821) or var1
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
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320280)
		event.set_object_sequence_motion(0, "寝てる会話", 2)
		event.queue_object_sequence_next_motion(0, "寝てる", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5320290)
		wait_objects(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_motion(0, "首ふる", 2)
		event.queue_object_sequence_next_motion(0, "寝てる", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5320295)
		wait_objects(0)
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
		helper_4116e6bb(5320300)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320305)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320310)
		wait_objects(1)
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
		helper_4116e6bb(5320315)
		wait_objects(1)
		event.set_object_sequence_motion(1, "上向く", 2)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(2, "上向く", 2)
		event.queue_object_sequence_next_motion(2, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320320)
		wait_objects(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320323)
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
		helper_4116e6bb(5320325)
		wait_objects(1)
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
		helper_4116e6bb(5320330)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320335)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "泣き目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5320340)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.set_object_sequence_motion(0, "首ふる", 2)
		event.queue_object_sequence_next_motion(0, "寝てる", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5320345)
		wait_objects(0)
		event.set_camera_sequence_position(44.6, 20.65, 33.29)
		event.set_camera_sequence_look_at(64.25, 16.57, 22.61)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(5320350)
		event.set_object_sequence_motion(1, "死", 2)
		event.queue_object_sequence_next_motion(1, "死L", 4)
		event.delay_object_sequence_texture_animation_track(1, 60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "ゆっくり目とじ")
		event.set_object_sequence_motion(2, "死", 2)
		event.queue_object_sequence_next_motion(2, "死L", 4)
		event.set_mouth_texture_animations(1, "わらい口パク２")
		helper_4116e6bb(5320360)
		wait_objects(1)
		event.set_camera_sequence_position(93.32, 20.1, 22.37)
		event.set_camera_sequence_look_at(63.34, 19.1, 24.49)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "死に")
		event.play_sound_effect(var1, 11)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "泣き顔")
		event.set_object_handle_texture_animation(0, 1, "泣き目～おどろき目")
		event.set_object_sequence_motion(0, "母さん！！", 6)
		event.queue_object_sequence_next_motion(0, "母さん！！L", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(5320370)
		wait_objects(0)
		event.play_sound_effect(var1, 12)
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
		helper_4116e6bb(5320375)
		vm.wait(30)
		vm.wait(31)
	end)
	vm.entry(32)
	event.cancel_drama_scene_skip()
	event.start_crossfade(60)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.clear_camera_sequence()
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_active(0)
end

--- Helper function.
local function helper_e6dc()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(536, 1)
		event.load_map_sounds(5824)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(112)
		event.play_music(0)
		event.load_map_sounds(5824)
		var0 = event.load_sound_effect_file_2(5824) or var0
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
		event.set_object_handle_sound_bank(0, var0)
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
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(0, "ドア開け", 6)
		event.queue_object_sequence_next_motion(0, "ドア開けL", 4)
		event.set_object_sequence_motion(2, "ドア開け", 6)
		event.queue_object_sequence_next_motion(2, "待機", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(61.97, 46.56, -61.97)
		event.set_camera_sequence_look_at(15.12, 25.71, 12.05)
		event.move_camera_sequence_eased(61.97, 46.56, -61.97, -5.06, 25.71, -5.5, 60, 2, 1.0)
		event.fade_in_screen(30)
		at = 2
		helper_888ab2a3(20)
		event.set_object_sequence_motion(1, "左見る", 2)
		event.queue_object_sequence_next_motion(1, "左見るL", 4)
		at = 3
		wait_objects(0)
		at = 4
		helper_888ab2a3(12)
		event.play_sound_effect(var0, 8)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 5
		helper_4116e6bb(5360060)
		at = 6
		wait_camera()
		event.set_camera_sequence_position(-34.76, 39.67, -42.6)
		event.set_camera_sequence_look_at(21.19, 24.21, -4.58)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "わらい顔")
		event.set_object_handle_texture_animation(0, 1, "目あき～目とじ")
		event.play_sound_effect(var0, 9)
		event.set_object_sequence_position(0, 10.0, 0.0, 4.0)
		event.set_object_sequence_rotation(0, 0.0, -2.41, 0.0)
		event.set_object_sequence_motion(0, "座る", 6)
		event.queue_object_sequence_next_motion(0, "座るL", 4)
		at = 7
		wait_objects(0)
		event.set_object_sequence_motion(0, "下向く", 2)
		event.queue_object_sequence_next_motion(0, "下向くL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 8
		helper_4116e6bb(5360070)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 9
		helper_4116e6bb(5360075)
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
		at = 10
		helper_4116e6bb(5360080)
		event.open_voice_stream_wave(1, 5360093)
		at = 11
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_object_handle_texture_animation(0, 1, "わらい口パク")
		event.open_message_window_2(0, 5360085)
		open_message(0, -1, 8, 0, 0)
		at = 12
		helper_888ab2a3(30)
		event.fade_out_screen(80, 255, 255, 255)
		at = 13
		helper_888ab2a3(80)
		close_message(0)
		event.set_message_window_mode(0, 11)
		event.set_message_button_prompt(0, 0)
		event.fade_in_screen(0)
		event.set_event_sprite_draw_pass(0, 1)
		event.open_message_window_2(0, 5360090)
		event.set_message_draw_speed(0, 0)
		open_message(0, -1, 5, 0, 0)
		var1 = 0
		var2 = 0.0
		while var1 < 40 do
			event.set_message_window_option(0, 6, 0, var2)
			event.set_message_window_option(0, 6, 1, 0)
			event.set_message_window_option(0, 6, 2, 0)
			var2 = vm.f32(var2 + vm.f32(3.2))
			var1 = var1 + 1
			at = 14
			vm.wait(14)
		end
		at = 15
		helper_888ab2a3(30)
		var1 = 0
		var2 = 0.0
		while var1 < 30 do
			event.set_message_window_option(0, 6, 0, 128)
			event.set_message_window_option(0, 6, 1, var2)
			event.set_message_window_option(0, 6, 2, 0)
			var2 = vm.f32(var2 + vm.f32(4.266667))
			var1 = var1 + 1
			at = 16
			vm.wait(16)
		end
		at = 17
		helper_888ab2a3(30)
		var1 = 0
		var2 = 0.0
		while var1 < 30 do
			event.set_message_window_option(0, 6, 0, 128)
			event.set_message_window_option(0, 6, 1, 128)
			event.set_message_window_option(0, 6, 2, var2)
			var2 = vm.f32(var2 + vm.f32(4.266667))
			var1 = var1 + 1
			at = 18
			vm.wait(18)
		end
		at = 19
		helper_888ab2a3(60)
		close_message(0)
		event.close_voice_stream(1)
		at = 20
		helper_888ab2a3(30)
		event.open_voice_stream_wave(1, 5360095)
		at = 21
		helper_9cbdc640(1)
		event.open_message_window_2(0, 5360095)
		event.set_message_draw_speed(0, 0)
		open_message(0, -1, 5, 0, 0)
		var1 = 0
		var2 = 0.0
		while var1 < 90 do
			if var1 == 30 then
				event.play_voice_stream(1)
			end
			event.set_message_window_option(0, 6, 0, var2)
			var2 = vm.f32(var2 + vm.f32(1.4222223))
			var1 = var1 + 1
			at = 22
			vm.wait(22)
		end
		event.set_message_window_option(0, 6, 0, 128)
		at = 23
		helper_888ab2a3(60)
		event.fade_out_music(30)
		event.fade_out_screen(30, 255, 255, 255)
		at = 24
		helper_888ab2a3(30)
		close_message(0)
		event.set_message_button_prompt(0, 1)
		event.close_voice_stream(1)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(20)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			helper_038a2e4d(12)
		end
		if at <= 4 then
			helper_8cd371d7(5360060)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_238b5abc(0)
		end
		if at <= 7 then
			helper_8cd371d7(5360070)
		end
		if at <= 8 then
			helper_8cd371d7(5360075)
		end
		if at <= 9 then
			helper_8cd371d7(5360080)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_038a2e4d(30)
		end
		if at <= 12 then
			helper_038a2e4d(80)
		end
		if at <= 13 then
			helper_d16eef1e(0)
			helper_f018b3c0(0, -1, 5, 0, 0)
			var1 = 0
			var2 = 0.0
			var2 = vm.f32(var2 + vm.f32(3.2))
			local _ = var1 < 40
			var1 = var1 + 1
		end
		if at <= 14 then
			helper_038a2e4d(30)
		end
		if at <= 15 then
			var1 = 0
			var2 = 0.0
			var2 = vm.f32(var2 + vm.f32(4.266667))
			local _ = var1 < 30
			var1 = var1 + 1
		end
		if at <= 16 then
			helper_038a2e4d(30)
		end
		if at <= 17 then
			var1 = 0
			var2 = 0.0
			var2 = vm.f32(var2 + vm.f32(4.266667))
			local _ = var1 < 30
			var1 = var1 + 1
		end
		if at <= 18 then
			helper_038a2e4d(60)
		end
		if at <= 19 then
			helper_d16eef1e(0)
			helper_038a2e4d(30)
		end
		if at <= 20 then
			helper_238b5abc(1)
		end
		if at <= 21 then
			helper_f018b3c0(0, -1, 5, 0, 0)
			var1 = 0
			var2 = 0.0
			var2 = vm.f32(var2 + vm.f32(1.4222223))
			local _ = var1 < 90
			local _ = var1 == 30
			var1 = var1 + 1
		end
		if at <= 22 then
			helper_038a2e4d(60)
		end
		if at <= 23 then
			helper_038a2e4d(30)
		end
		if at <= 24 then
			helper_d16eef1e(0)
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

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_b8bc()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_b8bc()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_b8bc()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_b8bc()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_b8bc()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 561)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_e6dc()
	event.skip_next_music_load()
	event.load_dungeon_map("d05b01")
	event.load_event_script("d05b01/d05b01.stb", 571)
end

return script
