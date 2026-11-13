--!strict
--- Event helpers specific to the Palm Brinks s60 map.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local palm_brinks_s60 = {}

--- Plays the e824 cutscene in which the playable character and the other party member listen to Need speak while the camera pushes in on her.
function palm_brinks_s60.play_e824_speech_scene()
	local active_character_id: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(824, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_character_id = event.get_playable_character() or active_character_id
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e824/")
		event.load_message_file(0, 5, "e824.txt")
		if active_character_id == 0 then
			event.load_character_motion_pack(5, "e824_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_character_id == 1 then
			event.load_character_motion_pack(5, "e824_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e824_need.gltf", "info", 10)
		event.set_scene_status_flags(1, 10, 8, 1)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e824_hanabi.gltf", "info", 11)
		event.set_character_active(11)
		event.change_directory("")
		if active_character_id == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e824/e824_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e800/e824/e824_monica.gltf", "info", 8)
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
		event.set_character_visible(3, 0)
		event.set_object_handle_position(0, 72.11, -90.0, 76.71)
		event.set_object_handle_rotation(0, 0.0, -3.02, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 54.92, -90.0, 77.88)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 44.14, -49.08, -126.86)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "しんけん顔")
		event.set_object_handle_texture_animation(2, 1, "しんけん目パチ")
		event.enable_drama_skip()
		event.set_scene_status_flags(1, 0, 8, 0)
		event.set_scene_status_flags(1, 8, 8, 0)
		event.set_event_map_visible(1)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(55.46, 200.34, 515.95)
		event.set_camera_sequence_look_at(53.44, 227.2, 372.83)
		event.fade_in_screen(0)
		event.set_event_map_visible(1)
		event.set_camera_sequence_position(44.0, -16.0, -75.76)
		event.set_camera_sequence_look_at(44.0, -29.0, -122.08)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(2, 1, "通常口パク")
		event.delay_object_sequence_texture_animation_track(2, 300)
		event.set_object_sequence_texture_animation(2, 0, "通常口パク")
		event.set_object_sequence_motion(2, "いつか世界に・・・", 4)
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "いつか世界に・・・Ｌ", 4)
		message.show_voiced_for(8240090, 360)
		event.set_camera_sequence_position(44.2, -3.01, -177.99)
		event.set_camera_sequence_look_at(35.75, -20.84, -125.36)
		event.move_camera_sequence(44.2, -3.01, -177.99, 52.28, -20.84, -125.25, 420)
		event.set_event_map_visible(0)
		event.set_object_sequence_texture_animation(2, 1, "通常口パク")
		event.delay_object_sequence_texture_animation_track(2, 336.0)
		event.set_object_sequence_texture_animation(2, 0, "通常口パク")
		event.set_object_sequence_motion(2, "なぜなら１", 2)
		event.queue_object_sequence_next_motion(2, "なぜなら１Ｌ", 4)
		event.queue_object_sequence_next_motion(2, "なぜならＬ～なぜなら２", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら２Ｌ", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら２～なぜなら１", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら１Ｌ", 4)
		event.queue_object_sequence_next_motion(2, "なぜならＬ～なぜなら２", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら２Ｌ", 4)
		message.show_voiced_for(8240110, 420)
		event.set_event_map_visible(1)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	for index = 0, 99 do
		event.delete_character(12 + index)
	end
	event.load_message_file(0, -1)
end

--- Plays the ending movie with Spanish captions, then shows a still image until a button is pressed and fades out.
function palm_brinks_s60.play_ending_movie_with_captions()
	local block: s32 = 0
	event.fade_out_screen(0)
	event.stop_all_sounds()
	wait.frames(6)
	event.fade_in_screen(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_movie_caption(0, 0)
	event.set_movie_caption(1, 0, 300, "[UNI00a1]Hurra! [UNI00a1]Hurra!", 150)
	event.set_movie_caption(1, 1, 600, "[UNI00a1]Hip, hip! [UNI00a1]Hurra!", 150)
	event.set_movie_caption(1, 2, 900, "Vale, ya basta.", 150)
	event.set_movie_caption(1, 3, 1200, "[UNI00a1]Hurra! [UNI00a1]Hurra! ", 150)
	event.set_movie_caption(
		1,
		4,
		1500,
		"Hoy, la l[UNI00ed]nea de ferrocarril Blackstone partir[UNI00e1] en un\nnuevo viaje por toda nuestra regi[UNI00f3]n.",
		150
	)
	event.set_movie_caption(
		1,
		5,
		1800,
		"Espero que esto sirva de ejemplo para el resto del mundo y\nque comience de nuevo el desarrollo.",
		150
	)
	event.set_movie_caption(1, 6, 2100, "[UNI00a1]Guau! Ahora s[UNI00ed] que parece un buen alcalde.", 150)
	event.set_movie_caption(1, 7, 2400, "S[UNI00ed], tienes raz[UNI00f3]n.", 150)
	event.set_movie_caption(
		1,
		8,
		2700,
		"[UNI00a1]Aunque a[UNI00fa]n nos queden muchas dificultades que pasar,\nestoy seguro que si trabajamos todos juntos,\nlo conseguiremos!",
		150
	)
	event.set_movie_caption(1, 9, 3000, "[UNI00a1]Viva! [UNI00a1]Hurra!", 150)
	event.set_movie_caption(
		1,
		10,
		3300,
		"[UNI00a1]Vosotros, queridos ciudadanos de Palm Brinks, hab[UNI00e9]is vivido \nmuchas tormentas y hab[UNI00e9]is hecho frente a muchas adversidades,\npor lo que todos os merec[UNI00e9]is esta victoria!",
		150
	)
	event.set_movie_caption(1, 11, 3600, "[UNI00a1]Viva Palm Brinks! [UNI00a1]Viva!", 150)
	event.set_movie_caption(1, 12, 3900, "Hubo un tiempo en el que nuestro mundo estaba asolado por la oscuridad.", 150)
	event.set_movie_caption(1, 13, 4200, "La gente de este tiempo luch[UNI00f3] y reclam[UNI00f3] su futuro.", 150)
	event.set_movie_caption(
		1,
		14,
		4500,
		"Pero la historia de aquella batalla nunca pudo pasar\na las siguientes generaciones.",
		150
	)
	event.set_movie_caption(
		1,
		15,
		4800,
		"[UNI00bf]Pas[UNI00f3] de verdad esta incre[UNI00ed]ble aventura o no?\nNadie lo sabe con certeza.",
		150
	)
	event.set_movie_caption(
		1,
		16,
		5100,
		"Pero...\nPero si pudieseis daros un paseo por el cielo de la noche y hablar con la Luna,\nseguro que os contar[UNI00ed]a todo lo que ocurri[UNI00f3] en esa extra[UNI00f1]a aventura.",
		150
	)
	event.set_movie_caption(0, 1)
	event.play_movie(5, "movie/end2.mp4")
	vm.wait(2)
	event.set_movie_caption(0, 0)
	block = event.load_event_image_4(5, "textures/event/e700/e736/e73601.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e73601", block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 224)
	event.set_event_sprite_draw_pass(1, 1)
	event.fade_in_screen(60)
	wait.frames(90)
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.fade_out_screen(30)
	wait.frames(30)
end

return palm_brinks_s60
