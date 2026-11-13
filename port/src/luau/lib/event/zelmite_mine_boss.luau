--!strict
--- Cutscenes and the ending movie of the Zelmite Mine boss room.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local party = vm.module("@lib/event/party")
local wait = vm.module("@lib/event/wait")

local zelmite_mine_boss = {}

--- Plays the boss-room cutscene in which the buggy explodes and the majin drops in front of the party.
function zelmite_mine_boss.play_buggy_explosion_scene()
	local playable_character: s32 = 0
	local sound_effect: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(816, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.stop_music(0)
		wait.frames(6)
		event.load_music(111)
		event.play_music(0)
		event.load_map_sounds(8809)
		sound_effect = event.load_sound_effect_file_2(8809) or sound_effect
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e816/")
		event.load_message_file(0, 5, "e816_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e816_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e816_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e816_majin.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		image_block = event.load_event_image_4(5, "e816telop01_1.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e816telop01", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.load_character(5, "event/e200/e206/e206_bbaku.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_map_part_2(4, "p04")
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_visible(4, 1)
		event.set_object_handle_position(0, 772.29, -72.1, 1522.76)
		event.set_object_handle_rotation(0, 0.0, -2.64, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 0.0, -1000.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_scale(2, 8.0, 8.0, 8.0)
		event.set_character_position(11, 974.5, 0.34, 1616.44)
		event.set_character_rotation(11, 0.0, 1.32, 0.0)
		event.set_character_scale(11, 1.0, 1.0, 1.0)
		if playable_character == 0 then
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
		else
			event.set_character_active(0, 0)
		end
		event.enable_drama_skip()
		event.delay_object_sequence_position_track(0, 20)
		event.move_object_sequence(0, 850.58, -72.1, 1669.29, 40)
		event.delay_object_sequence_rotation_track(0, 20)
		event.rotate_object_sequence(0, 0.0, 0.52, 0.0, 8)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(988.97, 77.53, 1641.42)
		event.set_camera_sequence_look_at(768.43, -42.14, 1535.48)
		event.fade_in_screen(30)
		wait.frames(20)
		event.play_sound_effect(sound_effect, 0)
		wait.frames(50)
		event.stop_sound_effect(sound_effect, 0)
		event.play_sound_effect(sound_effect, 1)
		event.shake_camera_sequence_vertically(0.0, 1.0, 0.0, 50)
		event.set_character_active(11)
		event.set_character_motion(11, "ｴﾌｪｸﾄ_バギー爆発", 6)
		wait.frames(10)
		event.set_object_handle_visible(4, 0)
		event.set_object_sequence_rotation(0, 0.0, -2.6, 0.0)
		wait.frames(40)
		event.move_object_sequence(0, 805.68, -72.1, 1578.18, 90)
		event.set_object_sequence_motion(0, "歩き")
		object.wait_until_done(0)
		event.set_camera_sequence_position(526.21, 180.7, 925.23)
		event.set_camera_sequence_look_at(591.71, 28.27, 1249.82)
		if playable_character == 0 then
			event.set_character_active(1, 8)
			event.set_character_active(1, 9)
		else
			event.set_character_active(1, 0)
		end
		event.set_object_sequence_position(0, 647.7, -69.42, 1336.0)
		event.set_object_sequence_rotation(0, 0.0, -2.48, 0.0)
		event.move_object_sequence(0, 594.08, -64.59, 1267.87, 90)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, 642.51, -70.56, 1362.06)
		event.set_object_sequence_rotation(1, 0.0, -2.6, 0.0)
		event.move_object_sequence(1, 586.91, -65.57, 1291.72, 90)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(0)
		event.set_camera_sequence_position(680.66, 6.68, 980.64)
		event.set_camera_sequence_look_at(575.95, -0.27, 930.94)
		event.move_camera_sequence_eased(680.66, 6.68, 980.64, 608.93, 31.74, 882.58, 40, 0, 0.4)
		camera.wait_until_done()
		event.move_camera_sequence_eased(680.66, 6.68, 980.64, 576.22, 34.02, 919.65, 14, 2, 0.2)
		camera.wait_until_done()
		wait.frames(30)
		event.set_camera_sequence_position(577.41, -36.52, 1231.62)
		event.set_camera_sequence_look_at(593.55, -49.69, 1286.96)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_motion(0, "指さす", 6)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_effect, 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8160010)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8160015)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160020)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-175.42, 20.69, 292.74)
		event.set_camera_sequence_look_at(-130.55, 18.84, 404.37)
		event.fade_out_music(60)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(0, 30.86, -3.88, 469.02)
		event.set_object_sequence_rotation(0, 0.0, -2.12, 0.0)
		event.move_object_sequence(0, -163.18, 0.0, 334.91, 50)
		event.set_object_sequence_motion(0, "走り", 4)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 6)
		event.set_object_sequence_motion(0, "キョロキョロ", 4)
		event.delay_object_sequence_texture_animation_track(0, 30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_position(1, 73.45, -7.05, 525.46)
		event.set_object_sequence_rotation(1, 0.0, -2.12, 0.0)
		event.move_object_sequence(1, -116.94, 0.0, 392.73, 60)
		event.delay_object_sequence_rotation_track(1, 50)
		event.rotate_object_sequence(1, 0.0, 2.84, 0.0, 10)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		wait.frames(20)
		message.show_voiced(8160030)
		message.show_voiced(8160035)
		event.set_camera_sequence_position(57.5, 40.21, 529.52)
		event.set_camera_sequence_look_at(-184.49, 8.41, 336.31)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, -182.92, 0.0, 359.09)
		event.set_object_sequence_rotation(1, 0.0, -2.36, 0.0)
		event.set_object_sequence_position(2, -367.65, 0.0, 193.54)
		event.set_object_sequence_rotation(2, 0.0, 0.9, 0.0)
		event.set_object_sequence_motion(2, "ふってくる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_sound_effect(sound_effect, 3)
		wait.frames(10)
		event.set_object_sequence_motion(0, "ドスン", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "着地振動", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.shake_camera_sequence(0.0, 8.0, 0.0, 40)
		wait.frames(20)
		event.move_camera_sequence_eased(57.5, 40.21, 529.52, -184.49, 99.45, 336.31, 60, 0, 0.2)
		wait.frames(20)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 20)
		camera.wait_until_done()
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		wait.frames(30)
		event.set_event_sprite_draw_pass(0, 0)
		wait.frames(10)
		event.set_camera_sequence_position(-201.98, 60.97, 306.62)
		event.set_camera_sequence_look_at(-164.55, 1.55, 356.48)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160040)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(8160050)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160060)
		event.set_camera_sequence_look_at(-332.71, 270.78, 221.57)
		event.set_camera_sequence_angle_height_distance(0.43, -34.0, 115.0)
		event.move_camera_sequence_angle_height_distance_eased(1.54, -34.0, 115.0, 200, 0, 0.2)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(8160070)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(8160080)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(8160090)
		camera.wait_until_done()
		event.set_camera_sequence_position(-314.29, 515.61, 172.37)
		event.set_camera_sequence_look_at(-286.23, 270.78, 236.95)
		event.play_sound_effect(sound_effect, 4)
		event.set_object_sequence_motion(2, "覗き込み会話", 6)
		event.wait_object_sequence_motion_end(2)
		object.wait_until_done(2)
		event.set_mouth_motions(2, "覗き込み会話Ｌ", 4, "覗き込み会話とまり", 0)
		message.show_voiced(8160100)
		event.set_mouth_motions(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
		message.show_voiced(8160105)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(8160110)
		event.set_mouth_motions(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
		message.show_voiced(8160120)
		event.play_sound_effect(sound_effect, 5)
		event.set_object_sequence_motion(2, "一歩前へ", 6)
		event.queue_object_sequence_next_motion(2, "一歩前へＬ", 4)
		object.wait_until_done(2)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(39)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect, 0)
	event.stop_sound_effect(sound_effect, 1)
	event.stop_sound_effect(sound_effect, 2)
	event.stop_sound_effect(sound_effect, 3)
	event.stop_sound_effect(sound_effect, 4)
	event.stop_sound_effect(sound_effect, 5)
	event.set_object_handle_visible(4, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_motion_blur(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.stop_music(0)
	wait.frames(6)
	event.load_music(40)
	event.play_music(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

--- Plays the end2 movie, adding Spanish captions when the language code is not 1, then shows a final image until a button is pressed.
function zelmite_mine_boss.play_ending_movie()
	local language_code: s32 = 0
	local image_block: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.stop_all_sounds()
		progress_step = 1
		wait.frames(6)
		event.fade_in_screen(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		language_code = event.get_language() or language_code
		print("GET_LANGUAGE=", language_code, "\n")
		if language_code ~= 1 then
			event.set_movie_caption(0, 0)
			event.set_movie_caption(1, 2, vm.ftoi(vm.f32(109.8)), "Vale, ya basta.", vm.ftoi(vm.f32(50.7)))
			event.set_movie_caption(
				1,
				4,
				vm.ftoi(vm.f32(241.80002)),
				"Hoy, la l[UNI00ed]nea de ferrocarril Blackstone partir[UNI00e1] en un\nnuevo viaje por toda nuestra regi[UNI00f3]n.",
				vm.ftoi(vm.f32(160.20001))
			)
			event.set_movie_caption(
				1,
				5,
				vm.ftoi(vm.f32(555.9)),
				"Espero que esto sirva de ejemplo para el resto del mundo y\nque comience de nuevo el desarrollo.",
				vm.ftoi(vm.f32(143.40001))
			)
			event.set_movie_caption(
				1,
				6,
				vm.ftoi(vm.f32(788.4)),
				"[UNI00a1]Guau! Ahora s[UNI00ed] que parece un buen alcalde.",
				vm.ftoi(vm.f32(99.299995))
			)
			event.set_movie_caption(1, 7, vm.ftoi(vm.f32(897.3)), "S[UNI00ed], tienes raz[UNI00f3]n.", vm.ftoi(vm.f32(33.6)))
			event.set_movie_caption(
				1,
				8,
				vm.ftoi(937.5),
				"[UNI00a1]Aunque a[UNI00fa]n nos queden muchas dificultades que pasar,\nestoy seguro que si trabajamos todos juntos,\nlo conseguiremos!",
				vm.ftoi(vm.f32(234.6))
			)
			event.set_movie_caption(
				1,
				10,
				vm.ftoi(1294.5),
				"[UNI00a1]Vosotros, queridos ciudadanos de Palm Brinks, hab[UNI00e9]is vivido \nmuchas tormentas y hab[UNI00e9]is hecho frente a muchas adversidades,\npor lo que todos os merec[UNI00e9]is esta victoria!",
				vm.ftoi(vm.f32(311.1))
			)
			event.set_movie_caption(
				1,
				12,
				vm.ftoi(vm.f32(1611.6001)),
				"Hubo un tiempo en el que nuestro mundo estaba asolado por la oscuridad.",
				vm.ftoi(vm.f32(96.6))
			)
			event.set_movie_caption(
				1,
				13,
				vm.ftoi(vm.f32(1820.7)),
				"La gente de este tiempo luch[UNI00f3] y reclam[UNI00f3] su futuro.",
				vm.ftoi(vm.f32(99.299995))
			)
			event.set_movie_caption(
				1,
				14,
				vm.ftoi(vm.f32(2121.6)),
				"Pero la historia de aquella batalla nunca pudo pasar\na las siguientes generaciones.",
				vm.ftoi(vm.f32(128.40001))
			)
			event.set_movie_caption(
				1,
				15,
				vm.ftoi(vm.f32(2328.6)),
				"[UNI00bf]Pas[UNI00f3] de verdad esta incre[UNI00ed]ble aventura o no?\nNadie lo sabe con certeza.",
				vm.ftoi(vm.f32(209.09999))
			)
			event.set_movie_caption(
				1,
				16,
				vm.ftoi(vm.f32(2623.2002)),
				"Pero...\nPero si pudieseis daros un paseo por el cielo de la noche y hablar con la Luna,\nseguro que os contar[UNI00ed]a todo lo que ocurri[UNI00f3] en esa extra[UNI00f1]a aventura.",
				vm.ftoi(vm.f32(242.70001))
			)
			event.set_movie_caption(0, 1)
		end
		event.play_movie(5, "movie/end2.mp4")
		progress_step = 2
		vm.wait(2)
		if language_code ~= 1 then
			event.set_movie_caption(0, 0)
		end
		event.set_pause_enabled(0)
		image_block = event.load_event_image_4(5, "textures/event/e800/e824/e82401_1.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_color(0, 0, 0, 0, 128)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e82401", image_block)
		event.set_event_sprite_color(1, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.fade_in_screen(60)
		progress_step = 3
		wait.frames(90)
		while true do
			if wait.get_button_state(0) ~= 0 then
				break
			else
				progress_step = 4
				vm.wait(4)
			end
		end
		event.fade_out_screen(30)
		progress_step = 5
		wait.frames(30)
		return
	end, function(received: { any })
		if progress_step <= 5 then
			if progress_step <= 1 then
				print("GET_LANGUAGE=", language_code, "\n")
			end
			if progress_step <= 2 then
				wait.frames_skipping(90)
			end
			if progress_step <= 4 then
				wait.frames_skipping(30)
			end
			local _ = party.get_change_state_skipping(0)
			return 0
		end
		return nil
	end)
end

--- Plays the boss-room cutscene in which the party watches a majin shrink while talking.
function zelmite_mine_boss.play_majin_shrink_scene()
	local playable_character: s32 = 0
	local sound_effect: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(820, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.stop_music(0)
		event.load_map_sounds(8811)
		sound_effect = event.load_sound_effect_file_2(8811) or sound_effect
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e820/")
		event.load_message_file(0, 5, "e820_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e820_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e820_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e820_majin.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e816/e816_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -125.17, 0.0, -85.85)
		event.set_object_handle_rotation(0, 0.0, -1.68, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -128.34, 0.0, -68.5)
		event.set_object_handle_rotation(1, 0.0, -1.92, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -352.78, 0.0, -122.42)
		event.set_object_handle_rotation(2, 0.0, 0.72, 0.0)
		event.set_object_handle_scale(2, 8.0, 8.0, 8.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(2, "縮む", 6)
		event.wait_object_sequence_motion_end(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-95.35, 412.01, -39.79)
		event.set_camera_sequence_look_at(-253.9, 198.62, -86.06)
		event.play_sound_effect(sound_effect, 0)
		event.fade_in_screen(30)
		message.show_voiced(8200010)
		object.wait_until_done(2)
		wait.frames(30)
		event.set_camera_sequence_position(-57.24, 82.46, -60.42)
		event.set_camera_sequence_look_at(-126.19, 22.03, -77.1)
		event.move_camera_sequence_eased(-57.24, 4.84, -60.42, -126.19, 22.03, -77.1, 90, 0, 1.0)
		message.show_voiced(8200020)
		message.show_voiced(8200030)
		message.show_voiced(8200040)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向く会話", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		message.show_voiced(8200045)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		message.show_voiced(8200050)
		object.wait_until_done(1)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_motion_blur(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.finish_event()
end

--- Waits through the skippable delays that follow the ending movie and logs the language code.
function zelmite_mine_boss.wait_after_ending()
	local language_code: s32 = 0
	wait.frames_skipping(6)
	print("GET_LANGUAGE=", language_code, "\n")
	wait.frames_skipping(90)
	local _ = party.get_change_state_skipping(0)
	wait.frames_skipping(30)
end

return zelmite_mine_boss
