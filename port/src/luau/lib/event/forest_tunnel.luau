--!strict
--- Cutscene helpers for the Forest Tunnel train ride, taxi ride and bomb events.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local forest_tunnel = {}

--- Loads the buggy, its Polcurse and Macho riders, the bomb and spark models and the train smoke effect used by the train cutscenes.
function forest_tunnel.load_train_scene()
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.change_directory("event/e200/e204/")
	event.load_character(5, "e204_buggy.gltf", "info", 33)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.load_character(5, "e204_polcurse.gltf", "info", 32)
	event.set_character_active(0, 32)
	event.attach_object_handle_to_character(0, 32)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_character_to_frame(33, "polcurse_chair", 32)
	event.load_character(5, "e204_macho.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_character_to_frame(33, "macho_chair", 34)
	event.change_directory("")
	event.load_character(5, "event/e200/e206/e206_bbaku.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e205/e205_hibana.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.set_object_sequence_position(1, 215.71, 0.0, -731.44)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.initialize_effect_manager(5)
	event.load_effect_base("列車煙")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 4)
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
end

--- Plays the event where the buggy gang chases the train, fires at its roof and Starbre on the roof pulls out a bomb.
function forest_tunnel.play_buggy_chase_cutscene()
	local sound_bank: s32 = 0
	local telop_block: s32 = 0
	local sway_angle: f32 = 0
	local frame_count: s32 = 0
	local sway_x: f32 = 0
	local sway_y: f32 = 0
	local sway_z: f32 = 0
	local gun_hit_z: f32 = 0
	local index: s32 = 0
	local bomb_x: f32 = 0
	local bomb_y: f32 = 0
	local bomb_z: f32 = 0
	local telop_scale: f32 = 0
	local telop_scale_speed: f32 = 0
	local telop_scale_acceleration: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.fade_out_screen(0)
		event.set_save_flag(204, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		checkpoint = 1
		wait.frames(4)
		event.load_music(191)
		event.load_map_sounds(2203)
		sound_bank = event.load_sound_effect_file_2(2203) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e200/e204/")
		event.load_message_file(0, 5, "e204_1.txt")
		event.load_character_motion_pack(5, "e204_mints.gltf", "info", 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e204_starbre.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "bomb.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_character_to_frame(32, "bomb", 33)
		event.load_character(5, "e204_buggy.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_character(3, 34)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e204_polcurse.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(4, 35)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_character_to_frame(34, "polcurse_chair", 35)
		event.load_character(5, "e204_macho.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_character_to_frame(34, "macho_chair", 36)
		event.load_character(5, "gun_fire.gltf", "info", 37)
		event.set_character_active(0, 37)
		event.attach_character_to_frame(34, "dcol00", 37)
		event.load_character(5, "gun_hit.gltf", "info", 38)
		event.set_character_active(0, 38)
		event.attach_object_handle_to_character(9, 38)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 9)
		telop_block = event.load_event_image_4(5, "e204telop01_1.json", 0) or telop_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e204telop01", telop_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 10)
		event.change_directory("")
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("バギー砂煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_4(5, "p01_s03t", "s03t01-m", "door01-")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(0, 0.0, 133.53, -321.16)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_sequence_position(1, 0.0, 114.0, -303.0)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "屋根つかまり立ち", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_position(3, 240.0, 0.0, -1200.0)
		event.set_object_sequence_motion(3, "走行", 4)
		event.set_object_sequence_motion(4, "走行", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 0, "ニヤリ口")
		event.set_object_sequence_texture_animation(4, 1, "わらい口パク")
		event.set_object_sequence_position(8, 76.0, 68.0, -1100.0)
		event.set_object_sequence_rotation(8, 0.0, 1.57, 0.0)
		event.create_effect_2("バギー砂煙", 34)
		event.open_voice_stream_wave(1, 2040010)
		checkpoint = 2
		sound.wait_voice_stream_ready(1)
		event.clear_camera_sequence()
		event.enable_drama_skip()
		event.play_sound_effect(sound_bank, 0)
		event.set_camera_sequence_position(380.6, 127.31, 601.72)
		event.set_camera_sequence_look_at(243.08, 107.4, 438.53)
		event.move_camera_sequence(325.48, 121.86, 412.81, 208.11, 101.95, 231.83, 90)
		event.fade_in_screen(30)
		checkpoint = 3
		camera.wait_until_done()
		event.set_camera_sequence_position(-160.48, 189.72, -401.22)
		event.set_camera_sequence_look_at(-1.58, 128.85, -292.36)
		event.set_character_active(0)
		event.set_object_sequence_motion(0, "屋根に登る", 6)
		event.queue_object_sequence_next_motion(0, "屋根に登るL", 4)
		event.play_sound_effect(sound_bank, 1)
		event.set_function_point_enabled("p01_s03t", "door", 1)
		checkpoint = 4
		wait.frames(65)
		event.set_function_point_enabled("p01_s03t", "door", 0)
		event.set_camera_sequence_position(0.0, 155.31, -427.57)
		event.set_camera_sequence_look_at(0.0, 151.56, -332.61)
		checkpoint = 5
		object.wait_until_done(0)
		event.set_camera_sequence_position(-9.82, 215.27, -230.06)
		event.set_camera_sequence_look_at(42.69, 136.67, -377.81)
		event.set_character_active(35)
		event.set_character_active(34)
		event.set_character_active(36)
		event.move_object_sequence(3, 266.0, 0.0, -800.0, 40)
		checkpoint = 6
		wait.frames(10)
		event.set_object_sequence_motion(0, "下を見る", 6)
		event.queue_object_sequence_next_motion(0, "下を見るL", 4)
		event.play_music(0)
		checkpoint = 7
		object.wait_until_done(3)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(240.0, 70.33, -441.97)
		event.set_camera_sequence_look_at(240.0, 35.77, -608.94)
		event.play_voice_stream(1)
		event.play_sound_effect(sound_bank, 2)
		event.play_sound_effect(sound_bank, 3)
		event.add_object_sequence_position_offset(3, 0.0, 0.0, 5.0, 40)
		event.rotate_object_sequence_eased(3, 0.0, -0.46, 0.0, 6, 0, 1.0)
		event.rotate_object_sequence_eased(3, 0.0, 0.46, 0.0, 10, 0, 1.0)
		event.rotate_object_sequence_eased(3, 0.0, 0.0, 0.0, 10, 0, 1.0)
		sway_angle = 0.0
		frame_count = 0
		while frame_count < 40 do
			do
				local out1, out2, out3 = event.get_character_position(34)
				sway_x = out1 or sway_x
				sway_y = out2 or sway_y
				sway_z = out3 or sway_z
			end
			sway_x = vm.f32(vm.f32(vm.sin(sway_angle) * 30.0) + 240.0)
			event.set_character_position(34, sway_x, sway_y, sway_z)
			sway_angle = vm.f32(sway_angle + vm.f32(0.15707964))
			sway_angle = event.wrap_angle(sway_angle) or sway_angle
			frame_count = frame_count + 1
			checkpoint = 8
			vm.wait(8)
		end
		event.set_camera_sequence_position(235.72, 76.51, -605.47)
		event.set_camera_sequence_look_at(235.07, 76.26, -631.38)
		event.set_object_sequence_motion(4, "走行2", 4)
		event.set_object_sequence_motion(3, "走行2", 4)
		checkpoint = 9
		object.wait_until_done(3)
		event.set_object_sequence_motion(4, "ニヤリ", 2)
		event.queue_object_sequence_next_motion(4, "ニヤリL", 4)
		checkpoint = 10
		wait.frames(40)
		event.set_camera_sequence_position(210.48, 75.88, -1380.83)
		event.set_camera_sequence_look_at(212.75, 63.09, -1231.67)
		event.move_camera_sequence(210.48, 75.88, -1380.83, 168.48, 63.09, -1255.36, 60)
		event.set_character_active(1, 38)
		event.reset_object_sequence_motion(8)
		event.set_object_sequence_motion(8, "連射", 4)
		gun_hit_z = -1000.0
		index = 0
		while index < 4 do
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, gun_hit_z)
			event.delay_object_sequence_position_track(8, 5)
			index = index + 1
		end
		index = 0
		while index < 4 do
			gun_hit_z = vm.f32(gun_hit_z + 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, gun_hit_z)
			event.delay_object_sequence_position_track(8, 5)
			index = index + 1
		end
		index = 0
		while index < 4 do
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, gun_hit_z)
			event.delay_object_sequence_position_track(8, 5)
			index = index + 1
		end
		event.play_sound_effect(sound_bank, 4)
		event.set_character_active(1, 37)
		event.set_object_sequence_position(3, 240.0, 0.0, -1100.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "攻撃", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "攻撃", 4)
		checkpoint = 11
		camera.wait_until_done()
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(369.35, 68.75, -1068.56)
		event.set_camera_sequence_look_at(281.32, 69.68, -1068.4)
		event.move_camera_sequence(369.27, 68.75, -1111.17, 281.24, 69.68, -1111.0, 90)
		event.set_object_sequence_motion(3, "ノリノリ", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "ノリノリ", 4)
		checkpoint = 12
		camera.wait_until_done()
		event.stop_sound_effect(sound_bank, 2)
		event.set_character_active(0, 37)
		event.close_voice_stream(1)
		event.set_object_sequence_texture_animation(4, 0, "わらい口パク")
		event.set_object_sequence_texture_animation(4, 1, "ニヤリ口")
		event.set_camera_sequence_position(3.09, 138.1, -353.16)
		event.set_camera_sequence_look_at(2.77, 152.0, -320.76)
		event.play_sound_effect(sound_bank, 5)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 13
		message.show_voiced(2040020)
		event.set_object_sequence_texture_animation(0, 0, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "きづく顔")
		checkpoint = 14
		message.show_voiced(2040030)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 0, "きづく顔")
		event.set_camera_sequence_position(11.47, 169.65, -362.8)
		event.set_camera_sequence_look_at(-5.1, 143.73, -320.45)
		event.play_sound_effect(sound_bank, 6)
		event.set_character_active(32)
		event.set_object_sequence_position(0, 0.0, 133.53, -348.54)
		event.set_object_sequence_motion(0, "振り返る", 6, 1)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		checkpoint = 15
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "つかまり会話", 2)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		checkpoint = 16
		message.show_voiced(2040040)
		checkpoint = 17
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "振り返る会話", 2)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 18
		message.show_voiced(2040050)
		checkpoint = 19
		object.wait_until_done(0)
		event.set_camera_sequence_position(0.0, 135.98, -348.92)
		event.set_camera_sequence_look_at(0.0, 139.71, -310.0)
		event.set_object_sequence_position(0, 0.0, 0.0, -348.54)
		event.set_object_sequence_motion(1, "爆弾を取る", 6)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		checkpoint = 20
		wait.frames(30)
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_texture_animation(1, 0, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_character_active(33)
		checkpoint = 21
		wait.frames(30)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "bomb")
			bomb_x = out1 or bomb_x
			bomb_y = out2 or bomb_y
			bomb_z = out3 or bomb_z
		end
		event.detach_character_from_frame(33)
		event.set_character_position(33, bomb_x, bomb_y, bomb_z)
		event.set_character_rotation(33, 0.0, 3.14, 0.0)
		event.play_sound_effect(sound_bank, 8)
		checkpoint = 22
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 23
		message.show_voiced(2040060)
		event.set_camera_sequence_position(60.12, 164.95, -266.6)
		event.set_camera_sequence_look_at(-4.48, 133.95, -322.74)
		event.set_object_sequence_position(0, 0.0, 133.53, -348.54)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "振り返る会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 24
		message.show_voiced(2040070)
		checkpoint = 25
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "つかまり会話", 2)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 26
		message.show_voiced(2040080)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 27
		message.show_voiced(2040085)
		checkpoint = 28
		object.wait_until_done(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 29
		message.show_voiced(2040090)
		event.stop_sound_effect(sound_bank, 5)
		event.set_camera_sequence_position(265.45, 83.77, -902.43)
		event.set_camera_sequence_look_at(166.76, 61.63, -1102.39)
		event.play_sound_effect(sound_bank, 2)
		event.play_sound_effect(sound_bank, 9)
		event.set_character_active(1, 38)
		gun_hit_z = -1000.0
		index = 0
		while index < 4 do
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, gun_hit_z)
			event.delay_object_sequence_position_track(8, 5)
			index = index + 1
		end
		index = 0
		while index < 4 do
			gun_hit_z = vm.f32(gun_hit_z + 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, gun_hit_z)
			event.delay_object_sequence_position_track(8, 5)
			index = index + 1
		end
		index = 0
		while index < 4 do
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, gun_hit_z)
			event.delay_object_sequence_position_track(8, 5)
			index = index + 1
		end
		event.set_character_active(1, 37)
		event.set_object_sequence_motion(3, "攻撃", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "攻撃", 4)
		checkpoint = 30
		wait.frames(60)
		event.set_character_active(0, 37)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(251.7, 76.66, -1109.07)
		event.set_camera_sequence_look_at(237.17, 73.79, -1129.16)
		event.set_object_sequence_motion(3, "ニヤリ2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(3, "ニヤリ2L", 4)
		event.set_object_sequence_motion(4, "ニヤリ2", 6)
		event.queue_object_sequence_next_motion(4, "ニヤリ2L", 4)
		checkpoint = 31
		wait.frames(40)
		event.stop_sound_effect(sound_bank, 2)
		event.set_camera_sequence_position(19.44, 139.93, -287.75)
		event.set_camera_sequence_look_at(-8.51, 144.37, -325.96)
		event.play_sound_effect(sound_bank, 5)
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(0, "顔を戻す", 6)
		event.queue_object_sequence_next_motion(0, "やってみる！", 6)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		checkpoint = 32
		wait.frames(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 33
		message.show_voiced(2040100)
		checkpoint = 34
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "つかまり会話", 2)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		checkpoint = 35
		message.show_voiced(2040110)
		checkpoint = 36
		object.wait_until_done(1)
		event.stop_sound_effect(sound_bank, 5)
		event.stop_sound_effect(sound_bank, 10)
		event.set_camera_sequence_position(240.0, 37.39, -800.0)
		event.set_camera_sequence_look_at(240.0, 42.12, -900.0)
		event.move_object_sequence(3, 240.0, 0.0, -860.0, 90)
		event.set_character_active(1, 37)
		event.play_sound_effect(sound_bank, 2)
		event.play_sound_effect(sound_bank, 11)
		event.play_sound_effect(sound_bank, 12)
		event.set_object_sequence_motion(3, "攻撃戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(3, "走行2", 4)
		event.set_object_sequence_motion(4, "攻撃戻り", 6)
		event.queue_object_sequence_next_motion(4, "走行2", 4)
		checkpoint = 37
		wait.frames(10)
		event.set_character_active(0, 37)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(9, 128, 128, 128, 128, 30)
		frame_count = 0
		telop_scale = 6.0
		telop_scale_speed = 0.0
		telop_scale_acceleration = vm.f32(0.01)
		while true do
			telop_scale = vm.f32(telop_scale - telop_scale_speed)
			telop_scale_speed = vm.f32(telop_scale_speed + telop_scale_acceleration)
			if telop_scale < 1.0 then
				event.set_object_sequence_scale(9, 1.0, 1.0, 1.0)
				break
			else
				event.set_object_sequence_scale(9, telop_scale, telop_scale, telop_scale)
				frame_count = vm.i32(frame_count + 1)
				checkpoint = 38
				vm.wait(38)
			end
		end
		checkpoint = 39
		wait.frames(vm.i32(70 - frame_count))
		event.fade_out_screen(10)
		checkpoint = 40
		wait.frames(10)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 2 then
			wait.background_load_skipping()
		end
		if checkpoint <= 3 then
			wait.frames_skipping(65)
		end
		if checkpoint <= 4 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 6 then
			cutscene.skip_command(3)
		end
		if checkpoint <= 7 then
			sway_angle = 0.0
			frame_count = 0
			sway_x = vm.f32(vm.f32(vm.sin(sway_angle) * 30.0) + 240.0)
			sway_angle = vm.f32(sway_angle + vm.f32(0.15707964))
			local _ = frame_count < 40
			frame_count = frame_count + 1
		end
		if checkpoint <= 8 then
			cutscene.skip_command(3)
		end
		if checkpoint <= 9 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 10 then
			gun_hit_z = -1000.0
			index = 0
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			local _ = index < 4
			index = index + 1
			index = 0
			gun_hit_z = vm.f32(gun_hit_z + 20.0)
			local _ = index < 4
			index = index + 1
			index = 0
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			local _ = index < 4
			index = index + 1
			wait.background_load_skipping()
		end
		if checkpoint <= 11 then
			wait.background_load_skipping()
		end
		if checkpoint <= 12 then
			message.show_voiced_skipping(2040020)
		end
		if checkpoint <= 13 then
			message.show_voiced_skipping(2040030)
		end
		if checkpoint <= 14 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 15 then
			message.show_voiced_skipping(2040040)
		end
		if checkpoint <= 16 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 17 then
			message.show_voiced_skipping(2040050)
		end
		if checkpoint <= 18 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 19 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 20 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 21 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 22 then
			message.show_voiced_skipping(2040060)
		end
		if checkpoint <= 23 then
			message.show_voiced_skipping(2040070)
		end
		if checkpoint <= 24 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 25 then
			message.show_voiced_skipping(2040080)
		end
		if checkpoint <= 26 then
			message.show_voiced_skipping(2040085)
		end
		if checkpoint <= 27 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 28 then
			message.show_voiced_skipping(2040090)
		end
		if checkpoint <= 29 then
			gun_hit_z = -1000.0
			index = 0
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			local _ = index < 4
			index = index + 1
			index = 0
			gun_hit_z = vm.f32(gun_hit_z + 20.0)
			local _ = index < 4
			index = index + 1
			index = 0
			gun_hit_z = vm.f32(gun_hit_z - 20.0)
			local _ = index < 4
			index = index + 1
			wait.frames_skipping(60)
		end
		if checkpoint <= 30 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 31 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 32 then
			message.show_voiced_skipping(2040100)
		end
		if checkpoint <= 33 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 34 then
			message.show_voiced_skipping(2040110)
		end
		if checkpoint <= 35 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 36 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 37 then
			frame_count = 0
			telop_scale = 6.0
			telop_scale_speed = 0.0
			telop_scale_acceleration = vm.f32(0.01)
			telop_scale = vm.f32(telop_scale - telop_scale_speed)
			telop_scale_speed = vm.f32(telop_scale_speed + telop_scale_acceleration)
			frame_count = frame_count + 1
		end
		if checkpoint <= 38 then
			wait.frames_skipping(70 - frame_count)
		end
		if checkpoint <= 39 then
			wait.frames_skipping(10)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.play_music(0)
	event.stop_sound_effect(sound_bank, 2)
	event.stop_sound_effect(sound_bank, 4)
	event.stop_sound_effect(sound_bank, 5)
	event.stop_sound_effect(sound_bank, 9)
	event.stop_sound_effect(sound_bank, 10)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_function_point_enabled("p01_s03t", "door", 0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_event_image(0)
	event.clear_effect_manager()
	event.load_message_file(0, -1)
	event.set_character_active(0)
end

--- Plays the event where Polcurse strips and lights dynamite and Monica defeats him with slashes and fire magic.
function forest_tunnel.play_monica_fire_magic_cutscene()
	local sound_bank: s32 = 0
	local charge_effect: s32 = 0
	local cast_index: s32 = 0
	local item_x: f32 = 0
	local item_y: f32 = 0
	local item_z: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.set_save_flag(206, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		event.stop_music(0)
		checkpoint = 1
		wait.frames(4)
		event.load_music(30)
		event.load_map_sounds(2209)
		sound_bank = event.load_sound_effect_file_2(2209) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e200/e206/")
		event.load_message_file(0, 5, "e206_1.txt")
		event.load_character_motion_pack(5, "e206_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "p00_08a.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(2, 33)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e206_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(3, 34)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e206_polcurse.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(4, 35)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "e206_h_polcurse.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_object_handle_to_character(5, 36)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "b01a_buggy.gltf", "b01a_buggy", 37)
		event.set_character_active(37)
		event.attach_object_handle_to_character(6, 37)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "b01a_macho.gltf", "b01a_macho", 38)
		event.set_character_active(38)
		event.attach_character_to_frame(37, "macho_chair", 38)
		event.load_character(5, "e206_bbaku.gltf", "info", 42)
		event.load_character(5, "e206_bfire.gltf", "info", 43)
		event.load_character(5, "e206_cloth.gltf", "info", 44)
		event.load_character(5, "e206_dfire.gltf", "info", 45)
		event.load_character(5, "e206_dfire.gltf", "info", 46)
		event.load_character(5, "e206_dfire_f.gltf", "info", 47)
		event.load_character(5, "e206_dfire_f.gltf", "info", 48)
		event.load_character(5, "e206_hikari.gltf", "info", 49)
		event.load_character(5, "e206_dynagiri.gltf", "info", 50)
		event.attach_object_handle_to_character(7, 50)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.load_character(5, "e206_hyakugiri.gltf", "info", 51)
		event.load_character(5, "e206_pbaku.gltf", "info", 52)
		event.set_character_active(0, 52)
		event.load_character(5, "e206_polcurse00.gltf", "info", 53)
		event.set_character_active(1, 53)
		event.change_directory("")
		event.load_character(5, "chara/c02_base.gltf", "info", 32)
		event.load_equipment_model(5, 1, 4, "info", 32)
		event.load_equipment_model(5, 1, 3, "info", 32)
		event.load_equipment_model(5, 1, 2, "info", 32, 39)
		event.load_equipment_model(5, 1, 1, "info", 32, 40)
		event.load_equipment_model(5, 1, 0, "info", 32, 41)
		event.load_character_motion_pack(5, "event/e200/e206/e206_monica.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.set_character_active(0, 39)
		event.set_character_active(0, 40)
		event.set_character_active(0, 41)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.initialize_effect_manager(5)
		event.load_effect_base("EVモニカ魔法－火")
		event.load_effect_base("EVモニカ魔法－火ヒット")
		event.load_effect_base("モニカ魔法－溜め")
		event.create_effect_work_buffer(5, 6000)
		event.set_object_sequence_position(0, 8.0, 134.45, -334.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "びびる", 6, -1.0, 1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_sequence_position(3, -8.0, 114.0, -303.0)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(3, "屋根つかまり立ち", 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(3, 1, "通常目パチ")
		event.set_object_sequence_position(4, 220.0, 0.0, -580.0)
		event.set_object_sequence_motion(4, "じたばた", 4)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "おこり顔")
		event.set_object_handle_texture_animation(4, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒わらい顔2")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_object_handle_sound_bank(5, sound_bank)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_position(6, 220.0, 0.0, -580.0)
		event.set_object_sequence_motion(6, "走行", 4)
		event.set_character_active(0, 42)
		event.set_character_position(42, 225.0, 34.0, -486.0)
		event.set_character_active(43)
		event.set_character_position(43, 220.0, 0.0, -580.0)
		event.set_character_active(0, 44)
		event.set_character_position(44, 0.0, 139.18, -620.0)
		event.attach_character_to_frame(36, "f1", 45)
		event.set_character_position(45, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(36, "f2", 46)
		event.set_character_position(46, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(36, "f1", 47)
		event.set_character_position(47, 0.0, 2.0, 0.0)
		event.attach_character_to_frame(36, "f2", 48)
		event.set_character_position(48, 0.0, 2.0, 0.0)
		event.set_character_active(0, 49)
		event.set_character_position(49, 0.0, 139.18, -712.0)
		event.set_character_position(50, 0.0, 139.18, -460.0)
		event.set_character_rotation(50, 0.0, 3.14, 0.0)
		event.set_character_position(51, 0.0, 139.18, -490.0)
		event.set_character_rotation(51, 0.0, 0.0, 0.0)
		event.set_character_position(53, 220.0, 0.0, -580.0)
		event.set_character_rotation(53, 0.0, 0.0, 0.0)
		event.set_character_motion(53, "じたばた", 4)
		event.enable_drama_skip()
		event.set_wind(10, 0.0, 0.0, -1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(361.41, 48.91, -580.59)
		event.set_camera_sequence_look_at(233.41, 52.06, -580.59)
		event.play_sound_effect(sound_bank, 2)
		event.play_sound_effect(sound_bank, 3)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(4, "おこり顔口パク")
		checkpoint = 2
		message.show_voiced(2060010)
		event.open_voice_stream_wave(1, 2060015)
		checkpoint = 3
		sound.wait_voice_stream_ready(1)
		event.set_camera_sequence_position(220.0, 60.0, -420.0)
		event.set_camera_sequence_look_at(220.0, 60.0, -580.0)
		event.stop_sound_effect(sound_bank, 2)
		event.stop_sound_effect(sound_bank, 3)
		event.play_sound_effect(sound_bank, 4)
		event.set_character_active(0, 53)
		event.set_character_active(1, 35)
		event.move_camera_sequence_eased(256.05, 60.0, -351.07, 160.79, 130.27, -549.21, 30, 2, 1.0)
		event.set_object_sequence_motion(4, "ふっとび", 6)
		event.move_object_sequence(4, 14.0, 0.0, -610.0, 50)
		event.set_object_sequence_motion(6, "左側でダメージ", 6)
		event.queue_object_sequence_next_motion(6, "右側でダメージ", 6)
		event.move_object_sequence_eased(6, 220.0, 0.0, -1000.0, 40, 1, 1.0)
		event.set_character_active(0, 43)
		event.set_character_active(42)
		event.set_character_motion(42, "ｴﾌｪｸﾄ_バギー爆発", 6)
		event.play_voice_stream(1)
		checkpoint = 4
		wait.frames(50)
		event.set_character_active(0, 38)
		event.set_character_active(0, 37)
		event.set_camera_sequence_position(0.0, 167.16, -367.46)
		event.set_camera_sequence_look_at(0.0, 129.42, -609.2)
		event.set_object_sequence_position(4, 0.0, 139.18, -620.0)
		event.set_object_sequence_motion(4, "どさっと落ちた", 6)
		checkpoint = 5
		wait.frames(8)
		event.play_sound_effect(sound_bank, 5)
		checkpoint = 6
		wait.frames(34)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(19.88, 150.6, -361.7)
		event.set_camera_sequence_look_at(8.1, 156.22, -333.48)
		event.set_object_handle_texture_animation(0, 1, "まばたき目パチ")
		checkpoint = 7
		wait.frames(40)
		event.set_camera_sequence_position(60.03, 148.42, -606.42)
		event.set_camera_sequence_look_at(0.0, 151.12, -606.2)
		event.move_camera_sequence(60.03, 148.42, -614.42, 0.0, 151.12, -614.2, 48)
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(4, "起きあがり", 6)
		checkpoint = 8
		wait.frames(48)
		event.set_camera_sequence_position(0.0, 161.43, -576.15)
		event.set_camera_sequence_look_at(0.0, 167.01, -624.67)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "激怒顔")
		event.set_object_handle_texture_animation(4, 1, "激怒目パチ")
		event.set_object_sequence_motion(4, "顔上げ", 6)
		event.queue_object_sequence_next_motion(4, "ワナワナ", 4)
		checkpoint = 9
		message.show_voiced(2060020)
		event.set_camera_sequence_position(10.4, 144.62, -387.58)
		event.set_camera_sequence_look_at(8.88, 150.2, -322.21)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "びびる", 6, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク", "半口")
		checkpoint = 10
		message.show_voiced(2060030)
		event.set_camera_sequence_position(0.0, 156.37, -537.41)
		event.set_camera_sequence_look_at(0.0, 159.13, -624.67)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "激怒わらい顔")
		event.set_object_handle_texture_animation(4, 1, "激怒目パチ")
		event.set_object_sequence_motion(4, "脱ぎ構え", 6)
		checkpoint = 11
		wait.frames(14)
		event.play_sound_effect(sound_bank, 9)
		checkpoint = 12
		wait.frames(20)
		event.set_camera_sequence_position(49.82, 158.45, -577.41)
		event.set_camera_sequence_look_at(28.49, 183.1, -641.57)
		event.play_sound_effect(sound_bank, 10)
		event.set_character_active(0, 35)
		event.set_character_active(36)
		event.set_object_sequence_position(5, 0.0, 139.18, -620.0)
		event.set_object_sequence_motion(5, "脱ぐ", 6)
		event.queue_object_sequence_next_motion(5, "脱ぐＬ", 4)
		event.set_character_active(44)
		event.set_character_motion(44, "ｴﾌｪｸﾄ_脱衣", 6)
		checkpoint = 13
		wait.frames(16)
		event.move_camera_sequence_eased(49.82, 158.45, -577.41, 1.0, 162.91, -620.29, 20, 0, 0.4)
		checkpoint = 14
		camera.wait_until_done()
		event.play_music(0)
		checkpoint = 15
		wait.frames(4)
		event.set_character_active(0, 44)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.0, 153.08, -533.86)
		event.set_camera_sequence_look_at(0.0, 158.5, -620.41)
		checkpoint = 16
		wait.frames(70)
		event.set_camera_sequence_position(-16.28, 155.87, -380.81)
		event.set_camera_sequence_look_at(12.48, 144.4, -292.95)
		event.set_object_handle_texture_animation(0, 1, "前向き～左向き")
		event.set_object_sequence_motion(3, "つかまり会話", 6)
		event.queue_object_sequence_next_motion(3, "屋根つかまり立ち", 4)
		event.set_object_sequence_motion(0, "振り向く", 6)
		event.queue_object_sequence_next_motion(0, "振り向くL", 4)
		event.set_mouth_texture_animations(3, "通常口パク", "大口")
		checkpoint = 17
		message.show_voiced(2060040)
		event.set_object_handle_texture_animation(0, 1, "左向き～前向き")
		event.set_object_handle_texture_animation(0, 1, "半口～大口")
		event.set_object_sequence_motion(0, "振り向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "びびる", 4)
		checkpoint = 18
		message.show_voiced(2060050)
		event.start_crossfade(30)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒わらい顔")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_camera_sequence_follow_object(5, 0.0, 23.0, 0.0, 0.0, 9.8, 80.0)
		event.move_camera_sequence_angle_height_distance_eased(0.0, 9.8, 40.0, 100, 2, 1.0)
		event.set_object_sequence_position(5, 0.0, 139.18, -800.0)
		event.set_object_sequence_motion(5, "脱ぎ歩き", 4)
		event.move_object_sequence(5, 0.0, 139.18, -640.0, 150)
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		checkpoint = 19
		message.show_voiced_for(2060060, 150)
		event.set_object_sequence_motion(5, "さあさあＬ")
		event.set_object_sequence_motion_blend_step(5, 0.1)
		event.delay_object_sequence_motion_track(5, 40)
		event.set_object_sequence_motion(5, "ごらあ", 2)
		event.queue_object_sequence_next_motion(5, "ごらあＬ", 4)
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		checkpoint = 20
		message.show_voiced_for(2060070, 120)
		checkpoint = 21
		object.wait_until_done(5)
		event.release_camera_sequence_follow_object()
		event.set_object_sequence_motion(5, "後ろに気がつく", 5)
		event.set_camera_sequence_position(17.47, 148.06, -359.89)
		event.set_camera_sequence_look_at(7.59, 155.6, -333.8)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目～ひき目")
		event.set_object_sequence_motion(0, "ひく", 6)
		event.queue_object_sequence_next_motion(0, "ひくL", 4)
		event.set_mouth_texture_animations(0, "ひき口パク")
		checkpoint = 22
		message.show_voiced(2060080)
		event.start_background_file_loads_1("snd2/bgm/bg_104.sound.json")
		checkpoint = 23
		wait.background_load()
		event.set_camera_sequence_follow_object(5, 0.0, 23.0, 0.0, 0.0, 9.8, 38.0)
		event.fade_out_music(30)
		event.play_sound_effect(sound_bank, 12)
		event.set_object_sequence_position(5, 0.0, 139.18, -468.0)
		event.move_object_sequence(5, 0.0, 139.18, -450.0, 30)
		event.set_object_sequence_motion(5, "後ろに気がつく", 6)
		event.queue_object_sequence_next_motion(5, "後ろに気がつくＬ", 4)
		event.delay_object_sequence_texture_animation_track(5, 26)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "きづく顔")
		checkpoint = 24
		message.show_voiced(2060090)
		checkpoint = 25
		object.wait_until_done(5)
		event.stop_music(0)
		checkpoint = 26
		wait.frames(4)
		event.load_music_pack(104)
		event.play_music(0)
		event.release_camera_sequence_follow_object()
		event.set_character_active(33)
		event.set_object_sequence_position(2, 0.0, 139.18, -712.0)
		event.set_object_sequence_motion(5, "振りかえり", 6)
		event.queue_object_sequence_next_motion(5, "振りかえりＬ", 4)
		event.move_camera_sequence_eased(0.0, 198.49, -396.69, 0.0, 175.46, -468.0, 20, 0, 0.4)
		checkpoint = 27
		camera.wait_until_done()
		checkpoint = 28
		wait.frames(20)
		event.set_camera_sequence_position(-0.0, 161.25, -679.19)
		event.set_camera_sequence_look_at(-0.0, 158.97, -713.45)
		event.set_mouth_texture_animations(2, "口パク")
		checkpoint = 29
		message.show_voiced(2060100)
		event.set_camera_sequence_position(0.0, 166.31, -519.59)
		event.set_camera_sequence_look_at(0.0, 164.03, -473.3)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒顔")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "会話用立ち", 4)
		event.set_mouth_texture_animations(5, "激怒口パク")
		checkpoint = 30
		message.show_voiced(2060110)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒わらい顔2")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		checkpoint = 31
		message.show_voiced(2060120)
		checkpoint = 32
		object.wait_until_done(5)
		event.play_sound_effect(sound_bank, 13)
		event.set_object_sequence_motion(5, "爆弾取り出し", 6)
		event.queue_object_sequence_next_motion(5, "火付け", 6)
		event.wait_object_sequence_motion_end(5)
		checkpoint = 33
		wait.frames(24)
		event.play_sound_effect(sound_bank, 14)
		event.set_object_handle_texture_animation(5, 1, "火ふき口")
		event.set_character_active(48)
		event.set_character_motion(48, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
		checkpoint = 34
		wait.frames(8)
		event.set_character_active(46)
		event.set_character_motion(46, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
		checkpoint = 35
		wait.frames(8)
		event.play_sound_effect(sound_bank, 14)
		event.set_object_handle_texture_animation(5, 0, "火ふき口")
		event.set_object_handle_texture_animation(5, 1, "火ふき口")
		event.set_character_active(47)
		event.set_character_motion(47, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
		checkpoint = 36
		wait.frames(8)
		event.set_character_active(45)
		event.set_character_motion(45, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
		checkpoint = 37
		object.wait_until_done(5)
		event.play_sound_effect(sound_bank, 15)
		event.set_character_active(0, 47)
		event.set_character_active(0, 48)
		event.set_object_sequence_motion(5, "爆弾歩き")
		event.move_object_sequence(5, 0.0, 139.18, -490.0, 130)
		event.set_object_handle_texture_animation(5, 0, "火ふき口")
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		checkpoint = 38
		message.show_voiced_for(2060130, 120)
		checkpoint = 39
		object.wait_until_done(5)
		event.stop_sound_effect(sound_bank, 15)
		event.set_object_sequence_motion(5, "構え2", 4)
		event.set_camera_sequence_position(23.2, 152.06, -685.78)
		event.set_camera_sequence_look_at(-0.59, 157.87, -710.51)
		checkpoint = 40
		wait.frames(40)
		event.set_camera_sequence_position(0.49, 160.57, -693.45)
		event.set_camera_sequence_look_at(-0.32, 160.57, -710.52)
		event.fade_out_music(30)
		checkpoint = 41
		wait.frames(10)
		event.play_sound_effect(sound_bank, 16)
		checkpoint = 42
		wait.frames(10)
		event.set_character_active(49)
		event.set_character_motion(49, "光る", 6)
		event.init_screen_raster_effect(0.0, 0.0, 0.15707964)
		event.start_screen_raster_effect(60.0, 0.3926991, -1.0, 50)
		checkpoint = 43
		wait.frames(20)
		event.stop_music(0)
		checkpoint = 44
		wait.frames(30)
		event.start_background_file_loads_1("snd2/bgm/bg_190.sound.json")
		checkpoint = 45
		wait.background_load()
		event.set_camera_sequence_position(0.0, 162.13, -550.88)
		event.set_camera_sequence_look_at(0.0, 160.57, -488.42)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "おこり顔")
		event.set_object_handle_texture_animation(5, 1, "おこり目パチ")
		event.stop_screen_raster_effect(0.0, 0.0, 0.0, 0)
		event.load_music_pack(190)
		event.play_music(0)
		event.set_mouth_texture_animations(5, "おこり口パク")
		checkpoint = 46
		message.show_voiced(2060140)
		event.set_camera_sequence_position(21.57, 145.5, -694.43)
		event.set_camera_sequence_look_at(0.0, 145.5, -710.52)
		event.move_camera_sequence(21.57, 150.5, -694.43, 0.0, 150.5, -710.52, 48)
		event.play_sound_effect(sound_bank, 17)
		event.set_character_motion(49, "消える", 6)
		event.init_screen_raster_effect(60.0, 0.3926991, 0.15707964)
		event.start_screen_raster_effect(-1.0, -1.0, -1.0, 0)
		event.stop_screen_raster_effect(0.0, -1.0, -1.0, 40)
		event.set_character_active(0, 33)
		event.set_character_active(32)
		event.set_character_active(39)
		event.set_character_active(40)
		event.set_character_active(41)
		event.set_object_sequence_position(1, 0.0, 139.18, -712.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "目とじ")
		checkpoint = 47
		wait.frames(48)
		event.set_camera_sequence_position(16.18, 155.0, -733.35)
		event.set_camera_sequence_look_at(0.0, 155.0, -714.81)
		event.move_camera_sequence(16.18, 160.0, -733.35, 0.0, 160.0, -714.81, 48)
		event.play_sound_effect(sound_bank, 18)
		event.set_object_sequence_motion(1, "髪の毛バサッ", 6)
		event.queue_object_sequence_next_motion(1, "髪の毛バサッＬ", 4)
		checkpoint = 48
		wait.frames(48)
		event.set_character_active(0, 49)
		event.set_camera_sequence_position(0.0, 160.11, -684.49)
		event.set_camera_sequence_look_at(0.0, 160.11, -710.52)
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(1, "うつむき～構え", 6)
		event.queue_object_sequence_next_motion(1, "構えＬ", 4)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 1, "目にらみ目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～にらみ口")
		checkpoint = 49
		wait.frames(40)
		event.play_sound_effect(sound_bank, 22)
		event.stop_sound_effect(sound_bank, 16)
		checkpoint = 50
		wait.frames(20)
		event.set_camera_sequence_position(22.15, 166.63, -756.1)
		event.set_camera_sequence_look_at(1.09, 150.66, -651.12)
		event.set_object_sequence_position(5, 0.0, 139.18, -460.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "おどろき顔")
		event.set_object_handle_texture_animation(5, 1, "おこり目パチ")
		event.set_mouth_texture_animations(5, "おこり口パク")
		checkpoint = 51
		message.show_voiced(2060150)
		event.set_object_sequence_motion(1, "ジャンプ", 2)
		checkpoint = 52
		wait.frames(4)
		event.play_sound_effect(sound_bank, 23)
		checkpoint = 53
		wait.frames(8)
		event.set_camera_sequence_position(74.99, 148.72, -384.25)
		event.set_camera_sequence_look_at(-4.53, 162.4, -478.25)
		event.move_camera_sequence_eased(44.68, 149.84, -420.08, -4.53, 162.4, -478.25, 90, 2, 0.4)
		event.set_object_sequence_position(1, 0.0, 139.18, -490.0)
		event.set_object_sequence_motion(1, "斬り一連", 6, -1.0, 1)
		event.delay_object_sequence_sound_track(1, 13)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_sound_track(1, 14)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_sound_track(1, 7)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_sound_track(1, 13)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_sound_track(1, 11)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_sound_track(1, 19)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_sound_track(1, 12)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_sound_track(1, 7)
		event.play_object_sequence_sound(1, sound_bank, 25)
		event.delay_object_sequence_position_track(5, 13)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 10)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 3)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 9)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 7)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 15)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 8)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 3)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 13)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 10)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 3)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 9)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 7)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 15)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 8)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 3)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.set_object_handle_frame_draw_flag(5, "dm01", 0)
		event.set_object_handle_frame_draw_flag(5, "dm02", 0)
		event.set_object_handle_frame_draw_flag(5, "dm03", 0)
		event.set_object_handle_frame_draw_flag(5, "dm04", 0)
		event.set_object_handle_frame_draw_flag(5, "dm05", 0)
		event.set_object_handle_frame_draw_flag(5, "dm06", 0)
		event.set_object_handle_frame_draw_flag(5, "dm07", 0)
		event.set_object_handle_frame_draw_flag(5, "dm08", 0)
		event.set_character_active(0, 45)
		event.set_character_active(0, 46)
		event.set_character_active(50)
		event.set_character_motion(50, "構え2", 6)
		event.set_character_active(51)
		event.set_character_motion(51, "百烈斬り", 6)
		checkpoint = 54
		wait.frames(108)
		event.play_sound_effect(sound_bank, 26)
		event.set_object_sequence_motion(5, "構え2から上向く", 2)
		event.queue_object_sequence_next_motion(5, "構え2から上向くＬ", 4)
		checkpoint = 55
		wait.frames(20)
		event.set_character_active(0, 50)
		event.set_character_active(0, 51)
		event.set_camera_sequence_position(17.12, 167.45, -472.74)
		event.set_camera_sequence_look_at(2.04, 165.02, -453.77)
		event.set_object_sequence_position(1, 0.0, 242.0, -432.79)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "着地2", 1, -1.0, 1)
		event.delay_object_sequence_position_track(1, 14)
		event.set_object_sequence_position(1, 0.0, 142.0, -432.79)
		event.delay_object_sequence_motion_track(1, 14)
		event.set_object_sequence_motion(1, "着地2", 6)
		event.wait_object_sequence_motion_end(1)
		event.set_mouth_texture_animations(5, "おこり口パク")
		checkpoint = 56
		message.show_voiced_for(2060160, 30)
		checkpoint = 57
		object.wait_until_done(1)
		event.set_camera_sequence_position(37.04, 163.18, -414.0)
		event.set_camera_sequence_look_at(-0.44, 155.57, -479.81)
		event.set_object_sequence_position(1, 0.0, 139.18, -466.39)
		event.set_object_sequence_position(5, 0.0, 139.18, -482.06)
		event.set_object_sequence_motion(1, "着地から蹴り", 6, -1.0, 1)
		checkpoint = 58
		wait.frames(10)
		event.play_sound_effect(sound_bank, 27)
		event.set_object_sequence_motion(5, "蹴られ", 6)
		event.move_object_sequence(5, 0.0, 139.18, -582.06, 20)
		checkpoint = 59
		wait.frames(20)
		event.set_camera_sequence_position(102.08, 207.93, -668.58)
		event.set_camera_sequence_look_at(0.9, 248.52, -781.38)
		event.set_object_sequence_motion(5, "回転", 4)
		event.set_object_sequence_position(5, 0.0, 170.0, -700.0)
		event.jump_object_sequence(5, 0.0, 270.0, -810.0, -0.2, 30)
		checkpoint = 60
		wait.frames(30)
		event.set_camera_sequence_position(31.63, 178.14, -506.91)
		event.set_camera_sequence_look_at(-4.76, 161.36, -465.13)
		event.set_object_sequence_motion(1, "魔法構えＬ", 4, -1.0, 1)
		checkpoint = 61
		wait.frames(2)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "item")
			item_x = out1 or item_x
			item_y = out2 or item_y
			item_z = out3 or item_z
		end
		cast_index = 0
		while cast_index < 2 do
			event.play_sound_effect(sound_bank, 28)
			event.reset_object_sequence_motion(1)
			event.set_object_sequence_motion(1, "魔法発射", 6)
			charge_effect = event.create_effect_3("モニカ魔法－溜め", 32) or charge_effect
			event.set_effect_first_vector(item_x, item_y, item_z)
			event.set_effect_second_vector(128, 64, 64)
			event.create_effect_2("EVモニカ魔法－火", 32)
			event.set_effect_first_vector(item_x, item_y, item_z)
			event.set_effect_target(36)
			checkpoint = 62
			vm.wait(62)
			event.finish_effect(32, charge_effect)
			checkpoint = 63
			wait.frames(12)
			cast_index = cast_index + 1
		end
		event.set_camera_sequence_position(2.63, 168.94, -402.89)
		event.set_camera_sequence_look_at(2.53, 174.18, -467.22)
		cast_index = 0
		while cast_index < 2 do
			event.play_sound_effect(sound_bank, 28)
			event.reset_object_sequence_motion(1)
			event.set_object_sequence_motion(1, "魔法発射", 6)
			charge_effect = event.create_effect_3("モニカ魔法－溜め", 32) or charge_effect
			event.set_effect_first_vector(item_x, item_y, item_z)
			event.set_effect_second_vector(128, 64, 64)
			event.create_effect_2("EVモニカ魔法－火", 32)
			event.set_effect_first_vector(item_x, item_y, item_z)
			event.set_effect_target(36)
			checkpoint = 64
			vm.wait(64)
			event.finish_effect(32, charge_effect)
			checkpoint = 65
			wait.frames(12)
			event.play_sound_effect(sound_bank, 29)
			cast_index = cast_index + 1
		end
		checkpoint = 66
		wait.frames(20)
		event.play_sound_effect(sound_bank, 29)
		event.set_character_active(1, 52)
		event.set_character_position(52, 0.0, 270.0, -810.0)
		event.set_character_rotation(52, 0.0, 0.0, 0.0)
		event.set_character_motion(52, "ｴﾌｪｸﾄ_ポルカス爆発", 6)
		checkpoint = 67
		wait.frames(20)
		event.set_camera_sequence_position(384.95, 97.71, -2219.0)
		event.set_camera_sequence_look_at(49.63, 140.83, -1923.14)
		event.play_sound_effect(sound_bank, 30)
		event.move_camera_sequence(384.95, 97.71, -2219.0, -38.17, 25.4, -2159.44, 80)
		event.set_character_position(52, 0.0, 260.0, -1700.0)
		event.set_character_rotation(52, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(5, 0.0, 0.0, -1700.0)
		event.set_object_sequence_rotation(5, 0.0, 1.57, 0.0)
		event.move_object_sequence_eased(5, 0.0, 0.0, -2200.0, 40, 2, 1.0)
		event.set_object_sequence_motion(5, "バウンド", 6)
		checkpoint = 68
		wait.frames(48)
		event.play_sound_effect(sound_bank, 31)
		checkpoint = 69
		wait.frames(32)
		event.set_camera_sequence_position(-63.62, 7.53, -2200.15)
		event.set_camera_sequence_look_at(-100.22, 4.78, -2200.62)
		event.set_object_sequence_position(5, -100.0, 0.0, -2200.0)
		event.set_object_sequence_motion(5, "落ちるアップ用", 6)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒顔")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		forest_tunnel.set_ground_points_enabled(0)
		checkpoint = 70
		wait.frames(40)
		event.start_background_file_loads_1("snd2/bgm/bg_112.sound.json")
		checkpoint = 71
		wait.background_load()
		event.set_camera_sequence_position(0.0, 163.99, -340.4)
		event.set_camera_sequence_look_at(0.0, 161.92, -451.52)
		event.fade_out_music(40)
		forest_tunnel.set_ground_points_enabled(1)
		event.play_sound_effect(sound_bank, 32)
		event.set_object_sequence_motion(1, "魔法構え～立ち", 6)
		event.queue_object_sequence_next_motion(1, "振りかえり", 6)
		event.queue_object_sequence_next_motion(1, "振りかえりＬ", 4)
		checkpoint = 72
		wait.frames(30)
		event.start_crossfade(60)
		event.play_sound_effect(sound_bank, 33)
		event.set_camera_sequence_position(-3.0, 160.0, -430.4)
		event.set_camera_sequence_look_at(-3.0, 160.0, -467.48)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～通常目")
		event.set_object_sequence_texture_animation(1, 1, "にらみ口～口とじ")
		checkpoint = 73
		wait.frames(10)
		event.stop_music(0)
		checkpoint = 74
		wait.frames(10)
		event.load_music_pack(112)
		event.play_music(0)
		checkpoint = 75
		wait.frames(40)
		event.set_camera_sequence_position(21.75, 147.46, -348.38)
		event.set_camera_sequence_look_at(-0.97, 155.45, -337.06)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_position(0, 0.0, 134.45, -334.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		checkpoint = 76
		wait.frames(40)
		event.start_crossfade(60)
		event.set_camera_sequence_look_at(0.0, 154.0, -400.0)
		event.set_camera_sequence_angle_height_distance(1.11, 18.0, 175.0)
		event.move_camera_sequence_angle_height_distance(2.03, 18.0, 175.0, 160)
		checkpoint = 77
		message.show_voiced_for(2060170, 120)
		event.open_voice_stream_wave(1, 2060180)
		checkpoint = 78
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 2060180)
		message.open(0, -1, 8, 0, 0)
		checkpoint = 79
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_follow_object(1, 0.0, 23.0, 0.0, 0.57, 0.0, 30.0)
		event.move_camera_sequence_angle_height_distance_eased(1.57, 0.0, 30.0, 90, 2, 0.3)
		checkpoint = 80
		message.wait_voice_for(0, 150)
		message.close(0)
		event.close_voice_stream(1)
		checkpoint = 81
		camera.wait_until_done()
		event.release_camera_sequence_follow_object()
		event.start_crossfade(30)
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, -2.0, 0.0, 30.0)
		event.move_camera_sequence_angle_height_distance_eased(3.14, 0.0, 30.0, 90, 2, 1.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		checkpoint = 82
		message.show_voiced_for(2060190, 160)
		checkpoint = 83
		camera.wait_until_done()
		event.release_camera_sequence_follow_object()
		checkpoint = 84
		wait.frames(30)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		checkpoint = 85
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			message.show_voiced_skipping(2060010)
		end
		if checkpoint <= 2 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 3 then
			wait.frames_skipping(50)
		end
		if checkpoint <= 4 then
			wait.frames_skipping(8)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(34)
		end
		if checkpoint <= 6 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(48)
		end
		if checkpoint <= 8 then
			message.show_voiced_skipping(2060020)
		end
		if checkpoint <= 9 then
			message.show_voiced_skipping(2060030)
		end
		if checkpoint <= 10 then
			wait.frames_skipping(14)
		end
		if checkpoint <= 11 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 12 then
			wait.frames_skipping(16)
		end
		if checkpoint <= 13 then
			wait.background_load_skipping()
		end
		if checkpoint <= 14 then
			wait.frames_skipping(4)
		end
		if checkpoint <= 15 then
			wait.frames_skipping(70)
		end
		if checkpoint <= 16 then
			message.show_voiced_skipping(2060040)
		end
		if checkpoint <= 17 then
			message.show_voiced_skipping(2060050)
		end
		if checkpoint <= 18 then
			message.show_voiced_for_skipping(2060060, 150)
		end
		if checkpoint <= 19 then
			message.show_voiced_for_skipping(2060070, 120)
		end
		if checkpoint <= 20 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 21 then
			message.show_voiced_skipping(2060080)
		end
		if checkpoint <= 22 then
			wait.background_load_skipping()
		end
		if checkpoint <= 23 then
			message.show_voiced_skipping(2060090)
		end
		if checkpoint <= 24 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 25 then
			wait.frames_skipping(4)
		end
		if checkpoint <= 26 then
			wait.background_load_skipping()
		end
		if checkpoint <= 27 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 28 then
			message.show_voiced_skipping(2060100)
		end
		if checkpoint <= 29 then
			message.show_voiced_skipping(2060110)
		end
		if checkpoint <= 30 then
			message.show_voiced_skipping(2060120)
		end
		if checkpoint <= 31 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 32 then
			wait.frames_skipping(24)
		end
		if checkpoint <= 33 then
			wait.frames_skipping(8)
		end
		if checkpoint <= 34 then
			wait.frames_skipping(8)
		end
		if checkpoint <= 35 then
			wait.frames_skipping(8)
		end
		if checkpoint <= 36 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 37 then
			message.show_voiced_for_skipping(2060130, 120)
		end
		if checkpoint <= 38 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 39 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 40 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 41 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 42 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 43 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 44 then
			wait.background_load_skipping()
		end
		if checkpoint <= 45 then
			message.show_voiced_skipping(2060140)
		end
		if checkpoint <= 46 then
			wait.frames_skipping(48)
		end
		if checkpoint <= 47 then
			wait.frames_skipping(48)
		end
		if checkpoint <= 48 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 49 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 50 then
			message.show_voiced_skipping(2060150)
		end
		if checkpoint <= 51 then
			wait.frames_skipping(4)
		end
		if checkpoint <= 52 then
			wait.frames_skipping(8)
		end
		if checkpoint <= 53 then
			wait.frames_skipping(108)
		end
		if checkpoint <= 54 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 55 then
			message.show_voiced_for_skipping(2060160, 30)
		end
		if checkpoint <= 56 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 57 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 58 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 59 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 60 then
			wait.frames_skipping(2)
		end
		if checkpoint <= 61 then
			cast_index = 0
		end
		if checkpoint <= 62 then
			wait.frames_skipping(12)
		end
		if checkpoint <= 63 then
			local _ = cast_index < 2
			cast_index = cast_index + 1
			cast_index = 0
		end
		if checkpoint <= 64 then
			wait.frames_skipping(12)
		end
		if checkpoint <= 65 then
			local _ = cast_index < 2
			cast_index = cast_index + 1
			wait.frames_skipping(20)
		end
		if checkpoint <= 66 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 67 then
			wait.frames_skipping(48)
		end
		if checkpoint <= 68 then
			wait.frames_skipping(32)
		end
		if checkpoint <= 69 then
			cutscene.ignore_value(0)
			wait.frames_skipping(40)
		end
		if checkpoint <= 70 then
			wait.background_load_skipping()
		end
		if checkpoint <= 71 then
			cutscene.ignore_value(1)
			wait.frames_skipping(30)
		end
		if checkpoint <= 72 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 73 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 74 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 75 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 76 then
			message.show_voiced_for_skipping(2060170, 120)
		end
		if checkpoint <= 77 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 78 then
			message.open_skipping(0, -1, 8, 0, 0)
			wait.background_load_skipping()
		end
		if checkpoint <= 79 then
			message.wait_voice_for_skipping(0, 150)
		end
		if checkpoint <= 80 then
			message.close_skipping(0)
			wait.background_load_skipping()
		end
		if checkpoint <= 81 then
			message.show_voiced_for_skipping(2060190, 160)
		end
		if checkpoint <= 82 then
			wait.background_load_skipping()
		end
		if checkpoint <= 83 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 84 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_wind(0)
	event.stop_music(0)
	event.stop_sound_effect(sound_bank, 2)
	event.stop_sound_effect(sound_bank, 3)
	event.stop_sound_effect(sound_bank, 15)
	event.stop_sound_effect(sound_bank, 16)
	event.stop_screen_raster_effect(0.0, 0.0, 0.0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
	event.delete_character(45)
	event.delete_character(46)
	event.delete_character(47)
	event.delete_character(48)
	event.delete_character(49)
	event.delete_character(50)
	event.delete_character(51)
	event.delete_character(52)
	event.delete_character(53)
	event.load_message_file(0, -1)
	event.clear_effect_manager()
	event.set_character_active(0)
	forest_tunnel.set_ground_points_enabled(1)
	event.stop_music(0)
end

--- Plays the taxi ride cutscene with exhaust smoke and a moving camera path.
function forest_tunnel.play_taxi_ride_cutscene()
	local index: s32 = 0
	event.initialize_event()
	event.set_character_active(1, 0)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character_motion_pack(5, "event/lm/taxi_ride_c01.gltf", "info", 0)
	event.set_character_position(0, 2.0, 0.0, 0.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "タクシー", 5)
	event.load_character(5, "event/lm/taxi_ride.gltf", "info", 8)
	event.set_character_active(8)
	event.set_character_position(8, 0.0, 0.0, 0.0)
	event.set_character_rotation(8, 0.0, 0.0, 0.0)
	event.set_character_shadow_culling_off(8)
	event.set_character_motion(8, "歩き", 5)
	event.attach_object_handle_to_character(0, 8)
	event.load_character(5, "event/lm/kemuri.gltf", "info", 9)
	index = 1
	while index < 20 do
		event.copy_character(5, 9, 9 + index)
		event.set_character_active(9 + index)
		event.attach_object_handle_to_character(1 + index, 9 + index)
		event.clear_object_sequence(1 + index)
		event.set_object_sequence_object(1 + index, 1 + index)
		event.set_object_sequence_motion(1 + index, "煙", 1)
		event.delay_object_sequence_motion_track(1 + index, index * 4)
		event.set_object_sequence_motion(1 + index, "煙", 4)
		event.delay_object_sequence_position_track(1 + index, index * 4)
		event.attach_object_sequence_to_object_frame(1 + index, 0, "null10")
		event.add_object_sequence_position_offset(1 + index, 0.0, 0.0, -15.0, 66)
		event.attach_object_sequence_to_object_frame(1 + index, 0, "null10")
		event.add_object_sequence_position_offset(1 + index, 0.0, 0.0, -15.0, 66)
		event.attach_object_sequence_to_object_frame(1 + index, 0, "null10")
		event.add_object_sequence_position_offset(1 + index, 0.0, 0.0, -15.0, 66)
		index = index + 1
	end
	event.attach_object_handle_to_character_frame(27, 8, "null43")
	event.clear_object_sequence(27)
	event.set_object_sequence_object(27, 27)
	event.rotate_object_sequence(27, 0.5, 0.0, 0.0, -1)
	event.attach_object_handle_to_character_frame(28, 8, "null42")
	event.clear_object_sequence(28)
	event.set_object_sequence_object(28, 28)
	event.rotate_object_sequence(28, 0.5, 0.0, 0.0, -1)
	event.attach_object_handle_to_character_frame(29, 8, "null40")
	event.clear_object_sequence(29)
	event.set_object_sequence_object(29, 29)
	event.rotate_object_sequence(29, -0.5, 0.0, 0.0, -1)
	event.attach_object_handle_to_character_frame(30, 8, "null41")
	event.clear_object_sequence(30)
	event.set_object_sequence_object(30, 30)
	event.rotate_object_sequence(30, -0.5, 0.0, 0.0, -1)
	event.clear_camera_sequence_path()
	event.set_camera_sequence_path_frames(80)
	event.add_camera_sequence_path_point(-254.12, 158.05, 537.66, -149.78, 133.31, 345.96)
	event.add_camera_sequence_path_point(-79.6, 129.85, 505.93, -22.8, 105.11, 294.58)
	event.add_camera_sequence_path_point(60.12, 79.21, 475.99, 86.98, 63.38, 252.64)
	event.add_camera_sequence_path_point(134.1, 47.23, 375.1, 147.87, 38.33, 161.01)
	event.add_camera_sequence_path_point(106.4, 32.81, 164.74, 167.34, 33.34, -19.58)
	event.add_camera_sequence_path_point(92.2, 32.81, 138.53, 170.11, 34.94, -37.23)
	event.add_camera_sequence_path_point(81.84, 24.85, 92.91, 175.81, 36.59, -74.81)
	event.add_camera_sequence_path_point(77.43, 24.85, 58.38, 188.12, 39.2, -115.19)
	event.add_camera_sequence_path_point(67.34, 20.59, 18.63, 190.84, 41.62, -141.79)
	event.start_camera_sequence_path()
	wait.frames(30)
	event.set_character_motion(0, "タクシー", 6)
	event.set_character_motion(8, "歩き", 6)
	wait.frames(70)
	event.attach_object_handle_to_character(1, 0)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_camera_sequence_position(194.83, 44.0, -85.18)
	event.set_camera_sequence_look_at(207.25, 40.97, -133.77)
	event.set_camera_sequence_follow_object(1, 0.0, 20.0, 0.0, 0.0, 5.0, 50.0, "ground", 2)
	event.delay_object_sequence_texture_animation_track(1, 20)
	event.set_object_sequence_texture_animation(1, 0)
	event.set_object_sequence_texture_animation(1, 1, "右向き")
	event.set_object_sequence_texture_animation(1, 1, "戻り")
	event.delay_object_sequence_texture_animation_track(1, 20)
	event.set_object_sequence_texture_animation(1, 0)
	wait.frames(30)
	event.release_camera_sequence_follow_object()
	event.set_camera_sequence_position(269.01, 71.1, -486.92)
	event.set_camera_sequence_look_at(263.41, 40.72, -356.08)
	wait.frames(20)
	event.set_camera_sequence_position(386.76, 16.92, 500.03)
	event.set_camera_sequence_look_at(277.73, 31.35, 236.22)
	event.move_camera_sequence(386.76, 16.92, 500.03, 239.86, 54.62, 255.09, 20)
	event.slow_down_camera_sequence_position(0.96, 30)
	vm.wait(5)
	wait.until_button_pressed(64)
	event.delete_character(8)
	index = 0
	while index < 31 do
		event.delete_character(9 + index)
		index = index + 1
	end
	event.delete_character_extension_packs(0)
end

--- Restarts the train sub game when the game-over choice is Try again, otherwise flags the scene to exit.
function forest_tunnel.retry_or_exit_train_game(choice: any)
	event.initialize_event()
	if choice == 0 then
		event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
		event.fade_in_screen(30)
		event.start_sub_game(3)
	else
		event.set_scene_exit_flag(1)
		event.fade_in_screen(30)
		return
	end
end

--- Enables or disables the ground function points jimen1 to jimen10 of the map, except jimen8.
function forest_tunnel.set_ground_points_enabled(enabled: s32)
	event.set_function_point_enabled("", "jimen1", enabled)
	event.set_function_point_enabled("", "jimen2", enabled)
	event.set_function_point_enabled("", "jimen3", enabled)
	event.set_function_point_enabled("", "jimen4", enabled)
	event.set_function_point_enabled("", "jimen5", enabled)
	event.set_function_point_enabled("", "jimen6", enabled)
	event.set_function_point_enabled("", "jimen7", enabled)
	event.set_function_point_enabled("", "jimen9", enabled)
	event.set_function_point_enabled("", "jimen10", enabled)
end

--- Deletes the characters loaded for the train scene.
function forest_tunnel.unload_train_scene()
	event.delete_character(33)
	event.delete_character(32)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
end

return forest_tunnel
