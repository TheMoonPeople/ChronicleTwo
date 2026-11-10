--!strict
-- map/s/s26/s26_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06561a1b = require("@lib/event/helper_06561a1b")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_6b9da980 = require("@lib/event/helper_6b9da980")
local helper_6e932de7 = require("@lib/event/helper_6e932de7")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_a518823a = require("@lib/event/helper_a518823a")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_11378()
	local active_chr_no: s32 = 0
	local block_2: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(3, 36)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "effect/giostone.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(5, 35)
	event.clear_object_sequence(4, 35)
	event.set_object_sequence_object(4, 5)
	print("00000000000000000000000000000000000000000000\n")
	event.load_event_image_4(5, "textures/menu/eventdl.json", 0)
	block_2 = event.load_event_image_4(5, "textures/event/e200/e254/e254_1.json", 1) or block_2
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25401", block_2)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e25402", block_2)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	print("1111111111111111111111111111111111111111111111\n")
end

--- Helper function.
local function helper_21700000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
	print("00000000000000000000000000000000000000000000\n")
	print("1111111111111111111111111111111111111111111111\n")
end

--- Helper function.
local function helper_10ef0()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(38)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_event_image(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(1)
end

--- Helper function.
local function helper_128e0()
	local var0: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(88.14, 44.81, 0.0)
		event.set_camera_sequence_look_at(0.0, 19.45, 0.0)
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.load_map_sounds(2239)
		var5 = event.load_sound_effect_file_2(2239) or var5
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(57)
		helper_11378()
		event.enable_drama_skip()
		event.play_music(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(88.14, 44.81, 0.0)
		event.set_camera_sequence_look_at(0.0, 19.45, 0.0)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 38)
		event.set_character_active(1, 36)
		event.set_character_active(1, 35)
		event.set_object_sequence_position(0, -20.0, 0.0, 20.0)
		event.set_object_sequence_rotation(0, 0.0, 2.3561945, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 20.0, 0.0, 20.0)
		event.set_object_sequence_rotation(1, 0.0, -2.3561945, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(3, -20.0, 0.0, -20.0)
		event.set_object_sequence_rotation(3, 0.0, 0.7853982, 0.0)
		event.set_object_sequence_motion(3, "ジオストーン持ち", 4)
		event.attach_character_to_frame(36, "gio", 35)
		event.fade_in_screen(30)
		at = 3
		wait_frames(30)
		event.open_message_window_2(
			0,
			"Esto es una Geopiedra. Est[UNI00e1] llena\ndel saber de los ancianos.<page>Si las metes en el reactor,\npodr[UNI00e1]s construir m[UNI00e1]s cosas\ncon el Carpenterion."
		)
		at = 4
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_object_sequence_motion(3, "炉にくべる", 2)
		at = 5
		wait_frames(23)
		event.play_sound_effect(var5, 9)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(4, "gio")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.detach_character_from_frame(35)
		print("x=", vm.float(pos_x), "y=", vm.float(pos_y), "z=", vm.float(pos_z), "\n")
		event.set_object_sequence_position(4, pos_x, pos_y, pos_z)
		event.jump_object_sequence(4, 0.0, 0.0, 0.0, -0.25, 30)
		at = 6
		wait_frames(30)
		event.play_sound_effect(var5, 10)
		event.set_character_active(0, 35)
		at = 7
		wait_frames(15)
		event.set_menu_value(5, 5, 74)
		var0 = 0
		while var0 == 0 do
			at = 8
			vm.wait(8)
			var0 = event.get_menu_value_2(8) or var0
		end
		event.set_menu_value(4)
		event.set_menu_value(3, 1)
		var0 = 0
		while var0 == 0 do
			at = 9
			vm.wait(9)
			var9 = helper_6e932de7(64)
			var0 = event.get_menu_value(7, var9) or var0
		end
		event.set_menu_value(3, 0)
		event.set_menu_value(7)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "[UNI00a1]Uy!\nCasi se me olvida.")
		at = 10
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"En las Geopiedras no hay s[UNI00f3]lo informaci[UNI00f3]n\nsobre c[UNI00f3]mo construir cosas, sino tambi[UNI00e9]n\nsobre c[UNI00f3]mo conseguir un futuro mejor."
		)
		at = 11
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_event_map_visible(0)
		event.set_event_sprite_draw_pass(0, 2)
		event.set_object_sequence_color(20, 128.0, 128.0, 128.0, 128.0)
		event.start_crossfade(15)
		at = 12
		wait_frames(15)
		event.open_message_window_2(
			0,
			"A medida que vayas construyendo el mundo\nnuevo, podr[UNI00e1]s ver los progresos gracias a la\nopci[UNI00f3]n Analizar del men[UNI00fa] Georama."
		)
		at = 13
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0)
		event.start_crossfade(15)
		at = 14
		wait_frames(15)
		event.set_event_sprite_draw_pass(0, 0)
		event.open_message_window_2(
			0,
			"F[UNI00ed]jate: en la esquina superior derecha del men[UNI00fa] Georama\n, ver[UNI00e1]s una cosa que pone\nPolyn restante."
		)
		at = 15
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"Para que las cosas existan\n, hace falta cierta energ[UNI00ed]a.<page>Nosotros la llamamos Polyn."
		)
		at = 16
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"Hay un l[UNI00ed]mite respecto a la cantidad de Polyn\nque puedes tener en el campo Georama.\nEl Carpenterion no te\n permitir[UNI00e1] superarlo.<page>Acu[UNI00e9]rdate bien de lo que te digo."
		)
		at = 17
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_event_map_visible(1)
		event.set_event_sprite_draw_pass(1, 0)
		event.start_crossfade(15)
		at = 18
		wait_frames(15)
		event.open_message_window_2(
			0,
			"Si tienes alguna duda\n, preg[UNI00fa]ntame con el\nWalkie-talkie. Yo te la resolver[UNI00e9]."
		)
		at = 19
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"Bueno, creo que el resto os lo dejar[UNI00e9]\na vosotros, j[UNI00f3]venes. Yo voy a coger\n ese tren."
		)
		at = 20
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.open_message_window_2(
			0,
			"Me pondr[UNI00e9] en el [UNI00fa]ltimo vag[UNI00f3]n, as[UNI00ed] que\nasomaos de vez en cuando. [UNI00bf]De acuerdo?<page>Si necesit[UNI00e1]is materias primas de Georama,\nhablad conmigo."
		)
		at = 21
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_camera_sequence_position(15.0, 17.57, 15.0)
		event.set_camera_sequence_look_at(-20.0, 15.0, -20.0)
		event.move_camera_sequence(4.35, 17.57, 4.35, -20.0, 15.0, -20.0, 300)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "Hale. [UNI00a1]Empecemos de una vez!\n[UNI00bf]Listo?")
		at = 22
		helper_0ffc2526(0, -1, 36, global1, var4)
		event.set_object_sequence_motion(3, "立ち")
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 23
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(4)
		end
		if at <= 2 then
			helper_21700000()
			wait_frames_skipping(30)
		end
		if at <= 3 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 4 then
			wait_frames_skipping(23)
		end
		if at <= 5 then
			print("x=", vm.float(pos_x), "y=", vm.float(pos_y), "z=", vm.float(pos_z), "\n")
			wait_frames_skipping(30)
		end
		if at <= 6 then
			wait_frames_skipping(15)
		end
		if at <= 7 then
			var0 = 0
		end
		if at <= 8 then
			local _ = if var0 == 0 then 1 else 0
			var0 = 0
		end
		if at <= 9 then
			var9 = helper_6b9da980(64)
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 10 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 11 then
			wait_frames_skipping(15)
		end
		if at <= 12 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 13 then
			wait_frames_skipping(15)
		end
		if at <= 14 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 15 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 16 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 17 then
			wait_frames_skipping(15)
		end
		if at <= 18 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 19 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 20 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 21 then
			helper_249b75d1(0, -1, 36, global1, var4)
		end
		if at <= 22 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_map_visible(1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_menu_value(4)
	event.set_menu_value(7)
	helper_10ef0()
	event.finish_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_d350()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	block = event.load_event_image_4(5, "textures/event/e200/e250/e250_1.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e25001", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(9, 0)
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_object_handle_frame_visible(5, "tue", 0)
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
end

--- Helper function.
local function helper_d000()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character(39)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_e398()
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(2231)
		helper_d350()
		event.stop_music(0)
		wait_frames(4)
		event.load_music(192)
		event.play_environment_music(220)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_save_flag(43, 1)
		event.set_function_point_enabled("", "fire-0", 0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(61.11, 28.64, 11.99)
		event.set_camera_sequence_look_at(34.15, 26.92, 87.57)
		event.move_camera_sequence_eased(61.11, 28.64, 11.99, -6.39, 26.92, -14.44, 90, 2, 0.2)
		event.set_object_sequence_position(0, -24.93, 0.0, -74.55)
		event.set_object_sequence_rotation(0, 0.0, -0.77, 0.0)
		event.set_object_sequence_position(1, -6.49, 0.0, -68.74)
		event.set_object_sequence_rotation(1, 0.0, -0.24, 0.0)
		event.set_object_sequence_position(5, -36.31, 0.0, -7.52)
		event.set_object_sequence_rotation(5, 0.0, 2.52, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -28.68, 0.0, -40.21, 90)
		event.rotate_object_sequence(0, 0.0, 0.19, 0.0, 30)
		event.move_object_sequence(1, -28.95, 0.0, -26.6, 90)
		event.rotate_object_sequence(1, 0.0, 0.12, 0.0, 30)
		wait_frames(90)
		event.play_music(0)
		event.set_object_sequence_texture_animation(0, 1, "うれし半口")
		event.set_object_sequence_motion(0, "立ち", 0)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "かなりキョロキョロ", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_object_sequence_motion(5, "会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		helper_4116e6bb(2500300)
		event.set_camera_sequence_position(-8.78, 24.17, 51.3)
		event.set_camera_sequence_look_at(-16.28, 24.17, 38.68)
		event.move_camera_sequence_eased(-8.78, 24.17, 51.3, 4.48, 24.17, 43.59, 210, 2, 0.4)
		helper_4116e6bb(2500310)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(61.11, 28.64, 11.99)
		event.set_camera_sequence_look_at(-6.39, 26.92, -14.44)
		helper_4116e6bb(2500320)
		event.set_camera_sequence_position(7.29, 21.91, 58.86)
		event.set_camera_sequence_look_at(-28.35, 17.54, 8.66)
		event.set_object_sequence_position(0, -25.04, 0.0, -22.19)
		event.set_object_sequence_rotation(0, 0.0, 1.39, 0.0)
		event.set_object_sequence_position(1, -42.75, 0.0, -17.11)
		event.set_object_sequence_rotation(1, 0.0, 0.36, 0.0)
		event.set_object_sequence_position(5, -35.97, 0.0, 6.92)
		event.set_object_sequence_rotation(5, 0.0, 2.88, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "→下見立ち", 6, -1.0, 1)
		event.call_command(466, 0, "下見立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(2500330)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500340)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(2500350)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "これは？", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "これは？L", 4)
		event.delay_camera_sequence_position_track(10)
		event.move_camera_sequence_eased(7.29, 21.91, 58.86, -13.44, 17.54, 2.84, 30, 2, 0.4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(2500360)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500370)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(2500380)
		event.reset_mouth_texture_animations()
		wait_camera()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(9, 128.0, 128.0, 128.0, 128.0, 10)
		helper_4116e6bb(2500390)
		helper_4116e6bb(2500400)
		helper_4116e6bb(2500410)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_camera_sequence_position(52.08, 130.61, 41.85)
		event.set_camera_sequence_look_at(2.22, 22.34, 3.5)
		event.set_object_sequence_position(0, -23.71, -1.07, -19.28)
		event.set_object_sequence_rotation(0, 0.0, 0.91, 0.0)
		event.set_object_sequence_position(1, -28.62, 0.82, 11.54)
		event.set_object_sequence_rotation(1, 0.0, 1.68, 0.0)
		event.set_object_sequence_position(5, -2.8, -0.0, 32.42)
		event.set_object_sequence_rotation(5, 0.0, 3.0, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.move_camera_sequence_eased(45.54, 116.59, 36.82, -4.32, 8.32, -1.53, 330, 2, 0.4)
		helper_1584c528(2500420, 260)
		helper_1584c528(2500425, 90)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(12.93, 17.36, -15.66)
		event.set_camera_sequence_look_at(8.82, 17.73, -6.03)
		event.move_camera_sequence_eased(12.93, 17.36, -15.66, 2.22, 17.73, -16.01, 270, 2, 0.4)
		event.set_object_sequence_rotation(1, 0.0, 1.32, 0.0)
		helper_1584c528(2500430, 300)
		event.fade_out_music(30)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "Nueva explicaci[UNI00f3]n sobre Georama en el men[UNI00fa] Ayuda.")
		helper_75684dd8(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait_frames(4)
		event.load_music(22)
		event.play_music(0)
		event.set_save_flag(43, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(4.11, 22.66, -17.12)
		event.set_camera_sequence_look_at(0.71, 19.07, 8.38)
		event.move_camera_sequence_eased(2.27, 22.66, -3.34, -1.12, 19.07, 22.16, 180, 2, 0.4)
		helper_1584c528(2500440, 210)
		helper_1584c528(2500450, 252)
		event.set_camera_sequence_position(-45.1, 19.94, -58.7)
		event.set_camera_sequence_look_at(-8.21, 23.23, 19.97)
		event.set_object_sequence_position(0, -34.66, 0.0, 3.86)
		event.set_object_sequence_rotation(0, 0.0, 1.15, 0.0)
		event.set_object_sequence_position(1, -22.93, -0.0, 24.09)
		event.set_object_sequence_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_sequence_position(5, 21.52, -0.0, 23.04)
		event.set_object_sequence_rotation(5, 0.0, -1.96, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2500460)
		event.reset_mouth_texture_animations()
		wait_objects(1)
		event.set_object_sequence_motion(0, "会話", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(2500470)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(2500480)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		helper_4116e6bb(2500490)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_function_point_enabled("", "fire-0", 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	helper_d000()
	event.stop_environment_music()
	event.fade_out_screen(0)
end

--- Helper function.
local function helper_14bc4()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e280/e280_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e280/e280_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.load_character(5, "event/e200/e280/e280_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e200/e280/e280_noam.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e280/e280_zak.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e200/e280/e280_wicky.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e280/e280_mogri.gltf", "info", 38)
	event.attach_object_handle_to_character(6, 38)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e280/e280_tobo.gltf", "info", 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e280/e280_rococo.gltf", "info", 41)
	event.attach_object_handle_to_character(8, 41)
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.set_character_active(0, 41)
	event.load_message_file(0, 5, "event/e200/e280/e280b_1.txt")
end

--- Helper function.
local function helper_21b00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_14798()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(37)
	end
	event.delete_character(39)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(40)
	event.delete_character(41)
	event.jump_to_map_3(-1, "s02", 503)
end

--- Helper function.
local function helper_16014()
	local var0: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(112)
		event.load_map_sounds(2514)
		var0 = event.load_sound_effect_file_2(2514) or var0
		event.play_music(0)
		helper_14bc4()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 39)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_character_active(1, 38)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		event.set_object_sequence_position(0, -6.46, 0.0, 61.2)
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, 7.05, 0.0, 67.92)
		event.set_object_sequence_rotation(1, 0.0, -2.92, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(5, 0.0, 0.0, -28.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "手紙を閉じるL", 4)
		event.set_object_sequence_position(6, 23.39, 0.0, -13.65)
		event.set_object_sequence_rotation(6, 0.0, -1.08, 0.0)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_position(8, 25.95, 0.0, 9.52)
		event.set_object_sequence_rotation(8, 0.0, -1.92, 0.0)
		event.set_object_sequence_motion(8, "立ち", 4)
		event.set_object_sequence_position(4, 7.8, 0.0, 25.45)
		event.set_object_sequence_rotation(4, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_position(7, -14.77, 0.0, 24.05)
		event.set_object_sequence_rotation(7, 0.0, 2.68, 0.0)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(2, -25.0, 0.0, 11.97)
		event.set_object_sequence_rotation(2, 0.0, 1.8, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_position(3, -24.95, 0.0, -10.56)
		event.set_object_sequence_rotation(3, 0.0, 0.96, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.fade_in_screen(30)
		at = 2
		wait_frames(15)
		at = 3
		wait_frames(90)
		event.play_sound_effect(var0, 16)
		event.set_object_sequence_motion(5, "手紙を開く", 2)
		event.queue_object_sequence_next_motion(5, "手紙を開くL", 4)
		at = 4
		wait_frames(60)
		event.set_camera_sequence_position(0.0, 17.78, 7.71)
		event.set_camera_sequence_look_at(0.0, 17.46, 0.0)
		event.set_object_sequence_motion(5, "手紙を読む", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(8, "ぷるぷる", 4)
		event.set_object_sequence_motion(4, "下向き立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_motion(2, "泣く", 4)
		event.set_object_sequence_motion(3, "泣く", 4)
		event.start_crossfade(30)
		at = 5
		wait_frames(15)
		at = 6
		wait_frames(60)
		at = 7
		helper_4116e6bb(2800220)
		event.set_camera_speed(0)
		event.clear_camera_sequence()
		event.move_camera_sequence_angle_height_distance_eased(-1.6, 0.32, 7.71, 250, 1, 1.0)
		event.move_camera_sequence_angle_height_distance(1.6, 0.32, 7.71, 500)
		event.delay_camera_sequence_angle_track(1)
		event.move_camera_sequence_angle_height_distance_eased(0.0, 0.32, 7.71, 250, 2, 1.0)
		event.set_message_button_prompt(0, 0)
		at = 8
		helper_0e75aa9e(2800225, -1, 16)
		at = 9
		helper_0e75aa9e(2800230, -1, 16)
		at = 10
		helper_0e75aa9e(2800240, -1, 20)
		at = 11
		helper_0e75aa9e(2800250, -1, 16)
		at = 12
		helper_0e75aa9e(2800260, -1, 16)
		at = 13
		helper_0e75aa9e(2800270, -1, 16)
		at = 14
		helper_0e75aa9e(2800275, -1, 16)
		event.set_message_button_prompt(0, 1)
		event.set_object_sequence_motion(5, "手紙を開くL")
		at = 15
		wait_camera()
		at = 16
		wait_frames(30)
		event.play_sound_effect(var0, 17)
		event.set_object_sequence_motion(5, "手紙を閉じる", 4)
		event.queue_object_sequence_next_motion(5, "手紙を閉じるL", 4)
		at = 17
		wait_frames(60)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		event.set_object_sequence_motion(6, "泣く", 4)
		event.set_object_sequence_motion(8, "泣く", 4)
		event.set_object_sequence_motion(4, "泣く", 4)
		event.set_object_sequence_motion(7, "泣く", 4)
		at = 18
		wait_frames(15)
		at = 19
		helper_4116e6bb(2800280)
		at = 20
		wait_frames(30)
		event.set_object_handle_frame_visible(5, "letter", 0)
		event.set_object_handle_frame_visible(5, "letter4", 0)
		event.set_camera_sequence_position(-13.25, 21.72, -2.6)
		event.set_camera_sequence_look_at(3.29, 19.71, -29.35)
		event.set_object_sequence_motion(5, "グスッ", 4)
		at = 21
		wait_frames(15)
		at = 22
		helper_4116e6bb(2800290)
		at = 23
		helper_4116e6bb(2800295)
		at = 24
		wait_frames(30)
		event.set_camera_sequence_position(-12.64, 27.88, 28.23)
		event.set_camera_sequence_look_at(-0.15, 19.71, 58.96)
		event.set_object_sequence_motion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 25
		wait_frames(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 26
		helper_4116e6bb(2800300)
		event.reset_mouth_texture_animations()
		at = 27
		wait_frames(30)
		event.set_camera_sequence_position(-13.25, 21.72, -2.6)
		event.set_camera_sequence_look_at(3.29, 19.71, -29.35)
		event.set_object_sequence_motion(5, "座り", 4)
		at = 28
		wait_frames(15)
		at = 29
		helper_4116e6bb(2800310)
		at = 30
		wait_frames(30)
		event.set_camera_sequence_position(-92.53, 119.19, 118.35)
		event.set_camera_sequence_look_at(11.54, 11.66, -7.56)
		at = 31
		wait_frames(15)
		at = 32
		helper_4116e6bb(2800320)
		at = 33
		helper_4116e6bb(2800330)
		at = 34
		wait_frames(60)
		event.set_object_sequence_motion(5, "見をのりだす", 4)
		event.queue_object_sequence_next_motion(5, "見をのりだすL", 4)
		at = 35
		helper_1584c528(2800340, 60)
		at = 36
		wait_frames(30)
		event.set_camera_sequence_position(-12.64, 27.88, 28.23)
		event.set_camera_sequence_look_at(-0.15, 19.71, 58.96)
		event.set_object_sequence_motion(1, "はい？（会話リアクション）", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 37
		helper_4116e6bb(2800350)
		event.reset_mouth_texture_animations()
		at = 38
		wait_frames(30)
		event.set_camera_sequence_position(0.0, 20.92, -6.23)
		event.set_camera_sequence_look_at(0.0, 19.86, -20.55)
		at = 39
		wait_frames(15)
		at = 40
		helper_4116e6bb(2800360)
		at = 41
		wait_frames(30)
		event.set_camera_sequence_position(-5.07, 23.48, 27.69)
		event.set_camera_sequence_look_at(2.31, 23.67, 72.31)
		at = 42
		wait_frames(15)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 43
		helper_4116e6bb(2800370)
		event.set_object_sequence_motion(1, "歩き")
		event.rotate_object_sequence(1, 0.0, 2.28, 0.0, 20)
		at = 44
		wait_objects(1)
		event.move_object_sequence(1, 29.3, 0.0, 46.07, 60)
		event.move_camera_sequence_eased(-18.11, 17.54, 36.58, -0.8, 23.67, 74.6, 480, 0, 0)
		at = 45
		helper_1584c528(2800380, 120)
		at = 46
		helper_1584c528(2800390, 270)
		at = 47
		helper_4116e6bb(2800400)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21b00000()
			wait_frames_skipping(15)
		end
		if at <= 2 then
			wait_frames_skipping(90)
		end
		if at <= 3 then
			wait_frames_skipping(60)
		end
		if at <= 4 then
			wait_frames_skipping(15)
		end
		if at <= 5 then
			wait_frames_skipping(60)
		end
		if at <= 6 then
			helper_8cd371d7(2800220)
		end
		if at <= 7 then
			helper_a518823a(2800225, -1, 16)
		end
		if at <= 8 then
			helper_a518823a(2800230, -1, 16)
		end
		if at <= 9 then
			helper_a518823a(2800240, -1, 20)
		end
		if at <= 10 then
			helper_a518823a(2800250, -1, 16)
		end
		if at <= 11 then
			helper_a518823a(2800260, -1, 16)
		end
		if at <= 12 then
			helper_a518823a(2800270, -1, 16)
		end
		if at <= 13 then
			helper_a518823a(2800275, -1, 16)
		end
		if at <= 14 then
			helper_344d6cd8()
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			wait_frames_skipping(60)
		end
		if at <= 17 then
			wait_frames_skipping(15)
		end
		if at <= 18 then
			helper_8cd371d7(2800280)
		end
		if at <= 19 then
			wait_frames_skipping(30)
		end
		if at <= 20 then
			wait_frames_skipping(15)
		end
		if at <= 21 then
			helper_8cd371d7(2800290)
		end
		if at <= 22 then
			helper_8cd371d7(2800295)
		end
		if at <= 23 then
			wait_frames_skipping(30)
		end
		if at <= 24 then
			wait_frames_skipping(15)
		end
		if at <= 25 then
			helper_8cd371d7(2800300)
		end
		if at <= 26 then
			wait_frames_skipping(30)
		end
		if at <= 27 then
			wait_frames_skipping(15)
		end
		if at <= 28 then
			helper_8cd371d7(2800310)
		end
		if at <= 29 then
			wait_frames_skipping(30)
		end
		if at <= 30 then
			wait_frames_skipping(15)
		end
		if at <= 31 then
			helper_8cd371d7(2800320)
		end
		if at <= 32 then
			helper_8cd371d7(2800330)
		end
		if at <= 33 then
			wait_frames_skipping(60)
		end
		if at <= 34 then
			helper_52aadc70(2800340, 60)
		end
		if at <= 35 then
			wait_frames_skipping(30)
		end
		if at <= 36 then
			helper_8cd371d7(2800350)
		end
		if at <= 37 then
			wait_frames_skipping(30)
		end
		if at <= 38 then
			wait_frames_skipping(15)
		end
		if at <= 39 then
			helper_8cd371d7(2800360)
		end
		if at <= 40 then
			wait_frames_skipping(30)
		end
		if at <= 41 then
			wait_frames_skipping(15)
		end
		if at <= 42 then
			helper_8cd371d7(2800370)
		end
		if at <= 43 then
			helper_238b5abc(1)
		end
		if at <= 44 then
			helper_52aadc70(2800380, 120)
		end
		if at <= 45 then
			helper_52aadc70(2800390, 270)
		end
		if at <= 46 then
			helper_8cd371d7(2800400)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	helper_14798()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_128e0

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_e398()
	event.fade_out_screen(0)
	vm.wait(2)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g01", 504)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_128e0()
	event.jump_to_map_3(-1, "g01", 506)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_06561a1b()
	event.jump_to_map_3(-1, "s70", 532)
	vm.wait(2)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_e398()
	event.fade_in_screen(30)
end

--- Event 700, which map data, a script or the engine runs by number.
function script.event_700()
	event.remove_item(385)
	helper_16014()
	event.fade_in_screen(30)
end

return script
