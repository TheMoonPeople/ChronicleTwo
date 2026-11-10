--!strict
-- map/d/d02/d02_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_03a1d6f1 = require("@lib/event/helper_03a1d6f1")
local helper_09075129 = require("@lib/event/helper_09075129")
local helper_0a3840c7 = require("@lib/event/helper_0a3840c7")
local helper_17b6d01b = require("@lib/event/helper_17b6d01b")
local helper_1a7fd8eb = require("@lib/event/helper_1a7fd8eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_313d0b27 = require("@lib/event/helper_313d0b27")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_35195a56 = require("@lib/event/helper_35195a56")
local helper_384e16e1 = require("@lib/event/helper_384e16e1")
local helper_39ab7f1f = require("@lib/event/helper_39ab7f1f")
local helper_3cf99f2c = require("@lib/event/helper_3cf99f2c")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_49c6448e = require("@lib/event/helper_49c6448e")
local helper_4c1ba28b = require("@lib/event/helper_4c1ba28b")
local helper_4d4dffcb = require("@lib/event/helper_4d4dffcb")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_55646435 = require("@lib/event/helper_55646435")
local helper_56390e5a = require("@lib/event/helper_56390e5a")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_5b28e690 = require("@lib/event/helper_5b28e690")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_64f3e42f = require("@lib/event/helper_64f3e42f")
local helper_6c7de8d8 = require("@lib/event/helper_6c7de8d8")
local helper_6c8af328 = require("@lib/event/helper_6c8af328")
local helper_74f9cdb5 = require("@lib/event/helper_74f9cdb5")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7870f366 = require("@lib/event/helper_7870f366")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_7b560508 = require("@lib/event/helper_7b560508")
local helper_86f3f24c = require("@lib/event/helper_86f3f24c")
local helper_9594e622 = require("@lib/event/helper_9594e622")
local helper_a583d6cd = require("@lib/event/helper_a583d6cd")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_ac9d5b12 = require("@lib/event/helper_ac9d5b12")
local helper_b1b0c1a6 = require("@lib/event/helper_b1b0c1a6")
local helper_b2cb6e46 = require("@lib/event/helper_b2cb6e46")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c3f198dd = require("@lib/event/helper_c3f198dd")
local helper_c55efd8e = require("@lib/event/helper_c55efd8e")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_ced7968c = require("@lib/event/helper_ced7968c")
local helper_d1646134 = require("@lib/event/helper_d1646134")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e91d3484 = require("@lib/event/helper_e91d3484")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f4832f7a = require("@lib/event/helper_f4832f7a")
local helper_f7c4a947 = require("@lib/event/helper_f7c4a947")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local helper_f90045b0 = require("@lib/event/helper_f90045b0")
local helper_fe9d3952 = require("@lib/event/helper_fe9d3952")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_message_answer = require("@lib/event/wait_message_answer")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3f104(arg0: s32)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local block: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local active_chr_no: s32 = 0
	local var12: f32 = 0
	local var13: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
			var5 = out4 or var5
		end
		var5 = vm.f32(var5 + vm.f32(1.5707964))
		var5 = event.wrap_angle(var5) or var5
		event.set_event_world_coordinate(var2, var3, var4, var5)
		var6 = event.get_dungeon_floor_status() or var6
		if var6 ~= 0 then
			if bit32.band(var6, 1) ~= 0 then
				event.switch_dungeon_main_character(1)
			end
			if bit32.band(var6, 2) ~= 0 then
				event.switch_dungeon_main_character(0)
			end
		end
		if arg0 ~= 0 then
			var8 = event.get_dungeon_floor() or var8
			var9 = event.get_dungeon_previous_floor() or var9
			event.load_dungeon_map_display(5, 0, 1, var8, var9)
			event.fade_dungeon_map(1, 30)
		else
			event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d01_1.json", 0)
			event.set_event_image_texture(0, "logo_d01")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 60)
		end
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "dungeon/chara/mints_01in.gltf", "info", 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "dungeon/chara/monica_01in.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 116.96, 18.76, 19.22)
		event.set_object_sequence_rotation(0, 0.0, -1.96, 0.0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 3)
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(173.18, 55.5, 1.04)
		event.set_camera_sequence_look_at(50.97, 32.07, 20.9)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		if active_chr_no == 0 then
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 160, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 140)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 130)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			if arg0 ~= 0 then
				at = 2
				wait_frames(30)
				event.set_dungeon_map_piece_moving(1)
			end
			at = 3
			wait_objects(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.3)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		else
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 100, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 60)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 50)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			if arg0 ~= 0 then
				at = 4
				wait_frames(30)
				event.set_dungeon_map_piece_moving(1)
			end
			at = 5
			wait_objects(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.2)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		end
		event.set_object_handle_footstep_sound(0, 16)
		at = 6
		wait_frames(14)
		event.play_sound_effect(var1, 2)
		event.jump_object_sequence(0, -85.0, 0.0, 50.0, -0.25, 30)
		event.delay_object_sequence_rotation_track(0, 10)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 20)
		at = 7
		wait_frames(16)
		if arg0 ~= 0 then
			event.fade_dungeon_map(0, 60)
		else
			event.fade_event_image(0, 0, 60)
		end
		at = 8
		wait_objects(0)
		event.play_sound_effect(var1, 4)
		at = 9
		wait_frames(30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -170.0, 0.0, 50.0, 50)
		at = 10
		wait_camera()
		event.start_crossfade(30)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			var12 = out2 or var12
		end
		event.set_camera_sequence_look_at(-170.0, 30.0, 50.0)
		var12 = vm.f32(var12 - vm.f32(3.1415927))
		var12 = event.wrap_angle(var12) or var12
		event.set_camera_sequence_angle_height_distance(var12, 5.0, 100.0)
		event.show_dungeon_status_bar(1)
		at = 11
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		at = 12
		wait_frames(15)
	end, function(received: { any }): boolean
		if at <= 1 then
			var5 = vm.f32(var5 + vm.f32(1.5707964))
			wait_frames_skipping(30)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			wait_frames_skipping(14)
		end
		if at <= 6 then
			wait_frames_skipping(16)
		end
		if at <= 7 then
			helper_238b5abc(0)
		end
		if at <= 8 then
			wait_frames_skipping(30)
		end
		if at <= 9 then
			helper_344d6cd8()
		end
		if at <= 10 then
			var12 = vm.f32(var12 - vm.f32(3.1415927))
			helper_238b5abc(0)
		end
		if at <= 11 then
			wait_frames_skipping(15)
		end
		return true
	end)
	at = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.fade_in_screen(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_motion(0, "立ち")
	event.set_object_handle_position(0, -170.0, 0.0, 50.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(-170.0, 30.0, 50.0)
	event.set_camera_position(-70.0, 35.0, 50.0)
	event.reset_follow_camera(0)
	event.delete_character_extension_packs(0)
	if arg0 ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	end
	event.delete_event_image(0)
	event.initialize_event()
	if var6 ~= 0 then
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		if bit32.band(var6, 1) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 14
			vm.wait(14)
			at = 15
			helper_479dc9e9()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "aka_fuuin", block)
		end
		if bit32.band(var6, 2) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 16
			vm.wait(16)
			at = 17
			helper_479dc9e9()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "ao_fuuin", block)
		end
		if bit32.band(var6, 4) ~= 0 then
			event.start_background_file_loads_2("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
			at = 18
			vm.wait(18)
			at = 19
			helper_479dc9e9()
			block = event.load_event_image_4(5, "textures/dungeon/image/seal/shiro_fuuin_1.json", 0) or block
			event.set_event_sprite_texture(0, "shiro_fuuin", block)
		end
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 156)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_color(0, 128, 128, 128, 128, 30)
		var13 = event.load_sound_effect_file_3(8, "snd2/sp/sp_050.sound.json") or var13
		event.play_sound_effect(var13, 0)
		event.set_message_window_mode(0, 4)
		if bit32.band(var6, 1) ~= 0 then
			event.open_message_window_2(0, "Ce niveau a un scell[UNI00e9] rouge !")
			at = 20
			helper_75684dd8(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Tu ne peux pas devenir Max.\nl'Atlamillia rouge l'a choisi !")
			at = 21
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		if bit32.band(var6, 2) ~= 0 then
			event.open_message_window_2(0, "Ce niveau a un scell[UNI00e9] bleu !")
			at = 22
			helper_75684dd8(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Tu ne peux pas devenir Monica :\nl'Atlamillia bleue l'a choisie !")
			at = 23
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		if bit32.band(var6, 4) ~= 0 then
			event.open_message_window_2(0, "Ce niveau a un scell[UNI00e9] blanc !")
			at = 24
			helper_75684dd8(0, -1, 8, 0, 0)
			event.open_message_window_2(0, "Tu ne peux plus r[UNI00e9]cup[UNI00e9]rer de\npoints de sant[UNI00e9] ni te soigner.")
			at = 25
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		event.set_event_sprite_draw_pass(0, 0)
		event.delete_event_image(0)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

--- Helper function.
local function helper_109ac()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local var6: s32 = 0
	vm.section(function()
		event.set_save_flag(212, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
			var3 = out4 or var3
		end
		event.set_event_world_coordinate(var0, var1, var2, var3)
		event.set_dungeon_pause_flags(17, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		wait_frames(4)
		event.load_music(48)
		event.play_music(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e200/e212/")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e212_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e212_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e212_crystal.gltf", "info", 11)
		event.set_character_active(0, 11)
		block = event.load_event_image_4(5, "e212_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e21201", block)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e21202", block)
		event.set_event_sprite_color(1, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_equipment_model(5, 0, 0, "info", 8, 10)
			event.load_character_motion_pack(5, "event/e200/e212/e212_mints.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e200/e212/e212_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(0, 10)
		if active_chr_no == 0 then
			event.attach_character_to_frame(8, "item", 11)
		else
			event.attach_character_to_frame(0, "item", 11)
		end
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, 67.73, 0.0, 94.65)
		event.set_object_handle_rotation(0, 0.0, -2.74, 0.0)
		event.call_command(706, 0, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 49.9, 0.0, 78.02)
		event.set_object_handle_rotation(1, 0.0, 0.86, 0.0)
		event.call_command(706, 1, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(67.03, 24.86, 49.63)
		event.set_camera_sequence_look_at(59.75, 21.85, 81.53)
		event.fade_in_screen(30)
		wait_frames(30)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(
			0,
			"J'sais pas Max. Si t'as que [UNI00e7]a pour\nte d[UNI00e9]fendre, tu auras un mal fou [UNI00e0]\nbattre les monstres de cette for[UNI00ea]t."
		)
		helper_75684dd8(0, -1, 8, 512, 0)
		wait_objects(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "Tu crois ?")
		helper_75684dd8(0, -1, 8, 0, 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_message_window_2(0, "Ah [UNI00e7]a oui !")
		helper_75684dd8(0, -1, 8, 512, 0)
		event.set_character_active(1, 11)
		event.set_character_visible(11, 1, 1, 0.1)
		event.set_object_sequence_motion(1, "渡す", 6)
		event.queue_object_sequence_next_motion(1, "渡すL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Tiens, prends-les.")
		helper_75684dd8(0, -1, 8, 512, 0)
		wait_objects(1)
		event.set_camera_sequence_position(56.78, 23.01, 68.1)
		event.set_camera_sequence_look_at(67.82, 21.85, 95.09)
		event.detach_character_from_frame(11)
		if active_chr_no == 0 then
			event.attach_character_to_frame(0, "item", 11)
		else
			event.attach_character_to_frame(8, "item", 11)
		end
		event.set_object_sequence_motion(0, "クリスタルゲット", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "半口")
		event.open_message_window_2(0, "Qu'est-ce que c'est ?!")
		helper_75684dd8(0, -1, 8, 256, 0)
		event.set_object_sequence_motion(0, "モニカ見る", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見るL", 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"Tu as re[UNI00e7]u 2 cristaux de chasseur,\n2 cristaux destructeurs,<page>1 cristal de vent\net 1 cristal de drac."
		)
		helper_75684dd8(0, -1, 8, 0, 0)
		wait_objects(0)
		event.set_object_handle_texture_animation(0, 0, "半口")
		event.set_camera_sequence_position(97.82, 22.3, 89.1)
		event.set_camera_sequence_look_at(34.74, 20.28, 87.84)
		event.set_message_window_mode(0, 1)
		event.set_object_sequence_rotation(0, 0.0, -2.38, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "Ooh ! Tout [UNI00e7]a ?")
		helper_75684dd8(0, -1, 8, 80, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Ouep. Tu peux am[UNI00e9]liorer ta clef\nanglaise et lui donner du punch avec [UNI00e7]a.")
		helper_75684dd8(0, -1, 8, 384, 0)
		event.set_camera_sequence_position(84.11, 24.45, 108.87)
		event.set_camera_sequence_look_at(53.38, 24.14, 80.91)
		event.set_character_active(0, 11)
		if active_chr_no == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
		end
		event.set_dungeon_pause_flags(128, 1)
		event.start_crossfade(10)
		event.set_event_sprite_draw_pass(0, 2)
		event.set_object_sequence_motion(1, "指立て", 6)
		event.queue_object_sequence_next_motion(1, "指立て会話", 6)
		event.queue_object_sequence_next_motion(1, "指立てL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Choisis un cristal dans le menu\nObjets puis spectromise-le.")
		helper_75684dd8(0, -1, 8, 256, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Synth[UNI00e9]tise-le avec l'arme que\ntu veux am[UNI00e9]liorer.")
		helper_75684dd8(0, -1, 8, 256, 0)
		wait_objects(1)
		event.start_crossfade(30)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_object_sequence_motion(1, "戻り", 6)
		event.queue_object_sequence_next_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Quand ses capacit[UNI00e9]s atteindront le\nniveau suivant, utilise Transformer.")
		helper_75684dd8(0, -1, 8, 256, 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Ceci devrait faire de ta clef\nanglaise une arme puissante !")
		helper_75684dd8(0, -1, 8, 256, 0)
		wait_objects(1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_dungeon_pause_flags(128, 0)
		event.start_crossfade(10)
		event.set_camera_sequence_position(91.98, 18.44, 61.76)
		event.set_camera_sequence_look_at(51.13, 20.11, 92.81)
		if active_chr_no == 0 then
			event.set_character_active(0)
			event.set_object_handle_visible(2, 1)
		else
			event.set_character_active(8)
			event.set_character_active(9)
			event.set_character_active(10)
		end
		event.set_object_sequence_motion(0, "武器持ち立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_message_window_2(0, "[UNI00c7]a a l'air sympa.")
		helper_75684dd8(0, -1, 8, 0, 0)
		event.set_object_sequence_motion(1, "カチャカチャ", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		event.open_message_window_2(0, "Allez, essaie ! Et voici quelque\nchose en plus de ma part. [heart].")
		helper_75684dd8(0, -1, 8, 512, 0)
		wait_objects(1)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(0, "Clef anglaise : 6 points de synth[UNI00e8]se en +.")
		helper_75684dd8(0, -1, 8, 0, 0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	vm.entry(25)
	event.cancel_drama_scene_skip()
	event.set_dungeon_pause_flags(145, 0)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(2, 1)
	event.set_character_active(0)
	event.detach_character_from_frame(11)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_event_image(0)
	if active_chr_no == 0 then
		var6 = 0
	else
		var6 = 1
	end
	event.set_object_handle_motion(var6, "立ち")
	event.set_object_handle_position(var6, 50.0, 0.0, 170.0)
	event.set_object_handle_rotation(var6, 0.0, 0.0, 0.0)
	event.reset_object_handle_dynamic_animation(var6)
	event.set_camera_look_at(50.0, 30.0, 170.0)
	event.set_camera_position(50.0, 30.0, 70.0)
	event.reset_follow_camera(0)
	event.show_dungeon_status_bar(1, 1.0)
	helper_a87eb945(0)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(16)
	event.play_music(0)
	event.load_dungeon_monster(0)
	event.place_treasure_box_at_event_point(-1)
	event.place_dungeon_monster(-1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Event 1010, which map data, a script or the engine runs by number.
local function event_1010()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_4: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		helper_e91d3484()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.reset_action_character_motion(0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var1 = event.get_dungeon_floor() or var1
		var2 = event.get_dungeon_floor_info(stage_id, var1, 7) or var2
		helper_d1646134(stage_id, var1)
		event.initialize_dungeon_floor()
		if var1 == 0 then
			event.go_to_georama_edit(16)
			at = 2
			vm.wait(2)
			return
		end
		if var1 == 6 then
			event.skip_next_music_play()
			event.go_to_georama_edit(65, 100)
			at = 3
			vm.wait(3)
			return
		end
		if var1 == 12 then
			event.skip_next_music_load()
			event.load_dungeon_map("s13")
			event.load_event_script("s13/s13.stb", 100)
			return
		end
		if var1 == 15 then
			event.skip_next_music_load()
			flag = event.get_save_flag(257) or flag
			flag_2 = event.get_save_flag(260) or flag_2
			if flag ~= 0 and flag_2 == 0 then
				event.load_dungeon_map("d02b02")
				event.load_event_script("d02b02/d02b02.stb", 200)
			else
				event.load_dungeon_map("d02b01")
				event.load_event_script("d02b01/d02b01.stb", 200)
			end
			return
		end
		event.get_equipped_item(0, 0)
		event.get_save_flag(49)
		flag_4 = event.get_save_flag(212) or flag_4
		if var1 == 2 and flag_4 == 0 then
			event.skip_next_music_load()
			event.load_dungeon_map("d02f01", "d02f01", 1)
			event.add_inventory_item(178, 2)
			event.add_inventory_item(180, 2)
			event.add_inventory_item(181, 1)
			event.add_inventory_item(182, 1)
			event.add_weapon_synthesis_points(0, 0, 6)
			at = 4
			helper_109ac()
		else
			if var1 == 14 then
				event.allow_next_music_load()
				event.stop_music(0)
				at = 5
				wait_frames(6)
				event.load_music(37)
				event.skip_next_music_load()
			end
			if var1 >= 9 and var1 <= 11 then
				event.load_dungeon_map("d02f01s", "d02f01", 1)
			else
				var8 = vm.float_bits(event.get_random_number(100)) or var8
				if vm.imod(var8, 8) == 0 then
					event.load_dungeon_map("d02f01r", "d02f01", 1)
					event.set_dungeon_weather(2)
				else
					event.load_dungeon_map("d02f01", "d02f01", 1)
				end
			end
			event.load_dungeon_monster(0)
			event.place_treasure_box_at_event_point(-1)
			event.place_dungeon_monster(-1)
			event.play_music(0)
			if var1 == 100 then
				at = 6
				helper_3f104(0)
			elseif var1 == 1 and var2 <= 0 then
				at = 7
				helper_3f104(0)
			else
				var9 = event.get_dungeon_previous_floor() or var9
				if var1 == var9 then
					at = 8
					helper_3f104(0)
				else
					at = 9
					helper_3f104(1)
				end
			end
		end
		helper_ac9d5b12()
		helper_6c7de8d8()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_384e16e1(stage_id, var1)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		if at <= 9 then
			if at <= 4 then
				wait_frames_skipping(6)
			end
			if at <= 5 then
				at = 6
				helper_3f104(0)
				return vm.continue_with(function()
					helper_ac9d5b12()
					helper_6c7de8d8()
					return
				end)
			end
			if at <= 6 then
				at = 7
				helper_3f104(0)
				return vm.continue_with(function()
					helper_ac9d5b12()
					helper_6c7de8d8()
					return
				end)
			end
			if at <= 7 then
				at = 8
				helper_3f104(0)
				return vm.continue_with(function()
					helper_ac9d5b12()
					helper_6c7de8d8()
					return
				end)
			end
			if at <= 8 then
				at = 9
				helper_3f104(1)
				return vm.continue_with(function()
					helper_ac9d5b12()
					helper_6c7de8d8()
					return
				end)
			end
			helper_344d6cd8()
			helper_1ef0d4b2()
			return 0
		end
		return nil
	end)
end

--- Event 1000, which map data, a script or the engine runs by number.
local function event_1000()
	local var0: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	helper_e91d3484()
	event.fade_out_screen(0)
	var0 = event.get_active_music_number() or var0
	if var0 ~= 16 then
		event.stop_music(0)
		wait_frames(6)
		event.load_music(16)
	end
	event.play_music(0)
	event.load_map_sounds(2601)
	event.set_local_event_flag(0, 0)
	event.set_local_event_flag(1, 0)
	event.set_local_event_flag(2, 0)
	event.set_local_event_flag(3, 0)
	event.set_local_event_flag(4, 0)
	event.open_dungeon_floor_map(1)
	vm.wait(2)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		var2 = out2 or var2
		var3 = out3 or var3
	end
	event.set_dungeon_floor(var3)
	event.set_dungeon_previous_floor(var2)
	event_1010()
end

--- Helper function.
local function helper_44854(arg0: s32)
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local item: s32 = 0
	local active_chr_no: s32 = 0
	local var6: any = 0
	local var7: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local var11: s32 = 0
	local argc_2: s32 = 0
	local var14: s32 = 0
	event.initialize_event()
	helper_ce85b54c()
	argc = event.get_local_event_flag(arg0) or argc
	event.set_dungeon_pause_flags(1, 1)
	if argc == 0 then
		var2 = event.get_triggered_event_data_2(6) or var2
		if var2 == 1 then
			event.initialize_event()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			var3 = helper_c292fa16(0, 1, 5, 256, 208, var3)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if var3 == 1 then
				var2 = 2
			end
			event.finish_event()
		end
		if var2 == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait_frames(6)
			event.open_use_item_menu(339)
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 339 then
				event.set_local_event_flag(arg0, 1)
				helper_56390e5a()
			elseif item <= 0 then
				event.finish_event()
			else
				helper_5fb66cb1()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			wait_frames(6)
		end
	else
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.initialize_event()
			helper_ce85b54c()
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 0)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		var6 = helper_bac0e30d(0, 10, 8, 256, 208, 2, 1)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		if var6 == 0 then
			event.clear_event_battle_monsters(-1)
			helper_7b560508()
			helper_f4832f7a()
			var7 = event.is_trial_version() or var7
			if var7 ~= 1 then
				do
					local out1, out2 = event.get_floor_practice_result(1)
					cleared = out1 or cleared
					bonus = out2 or bonus
				end
				if cleared == 2 or cleared == 3 then
					event.reset_event_sprite(0)
					event.set_event_sprite_type(0, 0)
					event.set_event_sprite_position(0, 256, 208)
					event.set_event_sprite_size(0, 512, 416)
					event.set_event_sprite_color(0, 0, 0, 0, 128)
					event.set_event_sprite_draw_pass(0, 1)
					event.fade_in_screen(0)
					helper_f7c4a947(-1, cleared, bonus)
					vm.wait(12)
					event.fade_out_screen(0)
					event.set_event_sprite_draw_pass(0, 0)
				end
			end
			stage_id = event.get_dungeon_stage_id() or stage_id
			var11 = event.get_dungeon_floor() or var11
			argc_2 = event.get_dungeon_next_floor(var11, arg0) or argc_2
			event.set_dungeon_floor(argc_2)
			event.set_dungeon_floor_info(stage_id, var11, 5, 2)
			event.set_dungeon_floor_info(stage_id, argc_2, 5, 1)
			event.finish_dungeon_floor()
			var14 = event.is_trial_version() or var14
			if var14 == 1 then
				event.set_scene_exit_flag(1)
				return
			else
				event.finish_event()
				event_1000()
			end
		else
			event.finish_event()
		end
	end
	event.set_dungeon_pause_flags(1, 0)
end

--- Helper function.
local function helper_1487c()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local result: s32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	event.set_save_flag(290, 1)
	event.set_dungeon_pause_flags(4096, 1)
	var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_044.sound.json") or var0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("モニカ魔法－溜め")
	event.create_effect_work_buffer(5)
	do
		local out1, _ = event.get_monster_talk_data_2()
		var1 = out1 or var1
	end
	event.set_character_active(var1)
	event.attach_object_handle_to_character(1, var1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	player_chara = event.get_player_character_slot() or player_chara
	event.set_character_active(player_chara)
	event.attach_object_handle_to_character(2, player_chara)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	do
		local out1, out2, out3 = event.get_character_position(var1)
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	do
		local out1, out2, out3 = event.get_character_position(player_chara)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	helper_4e93f9fc(var1, 0, 0)
	event.set_object_sequence_motion(1, "会話")
	event.set_message_window_mode(0, 7)
	event.open_message_window_2(
		0,
		"J'ai plein de gouttes de soleil en ce moment.\nIl m'en sort m[UNI00ea]me par les oreilles.\nTu voudrais pas m'en prendre ?"
	)
	helper_0a3840c7(2900010, var1, player_chara)
	event.set_object_sequence_motion(1, "ガードin", 2)
	event.queue_object_sequence_next_motion(1, "ガード", 4)
	event.open_message_window_2(0, "Tiens.")
	helper_0a3840c7(2900020, var1, player_chara)
	event.apply_message_window_preset(0, 0)
	event.set_object_sequence_motion(1, "ガードout", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	result = event.create_effect_3("モニカ魔法－溜め", var1) or result
	vector_x = vm.f32(vm.f32(var7 + var4) / 2.0)
	vector_y = vm.f32(vm.f32(vm.f32(var8 + var5) / 2.0) + 10.0)
	vector_z = vm.f32(vm.f32(var9 + var6) / 2.0)
	event.set_effect_first_vector(vector_x, vector_y, vector_z)
	event.set_effect_second_vector(128, 64, 64)
	event.play_sound_effect(var0, 0)
	wait_frames(30)
	event.set_object_sequence_motion(2, "ガードin", 2)
	event.queue_object_sequence_next_motion(2, "ガード", 4)
	wait_frames(30)
	event.finish_effect(var1, result)
	helper_9594e622(356, 1)
	event.set_object_sequence_motion(2, "ガードout", 2)
	event.queue_object_sequence_next_motion(2, "立ち", 4)
	wait_frames(30)
	helper_a87eb945(1)
	event.finish_event()
	event.set_dungeon_pause_flags(4096, 0)
end

--- Helper function.
local function helper_2561c()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local is_play_sub_game: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_clear_most_fast_destroy: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		helper_ce85b54c()
		event.set_dungeon_pause_flags(512, 1)
		event.show_dungeon_status_bar(0, 0.16666667)
		at = 1
		wait_frames(10)
		event.set_dungeon_pause_flags(16384, 1)
		event.clear_event_battle_monsters(-1)
		if active_chr_no == 0 then
			at = 2
			helper_4c1ba28b(1)
		end
		if active_chr_no == 1 then
			at = 3
			helper_6c8af328(1)
		end
		if active_chr_no == 2 or active_chr_no == 3 then
			at = 4
			helper_fe9d3952(active_chr_no)
		end
		event.set_dungeon_pause_flags(16384, 0)
		helper_4d4dffcb()
		event.reset_action_character_motion(0, 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.show_dungeon_status_bar(1, 0.16666667)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var2 = event.get_dungeon_floor() or var2
		event.set_dungeon_floor_info(stage_id, var2, 5, 2)
		event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
		flag = event.get_save_flag(220) or flag
		flag = event.get_save_flag(317) or flag
		is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
		if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
			event.clear_random_stones()
			helper_c3f198dd(0, -1)
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_position(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_look_at(position_x, position_y, position_z)
		is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
		do
			local out1, out2 = event.get_floor_practice_result(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		at = 5
		helper_f7c4a947(is_clear_most_fast_destroy, cleared, bonus)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		var12 = event.is_trial_version() or var12
		var13 = event.get_dungeon_floor_status() or var13
		if
			(if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0 then 1 else bit32.band(var13, 4))
			~= 0
		then
			event.set_dungeon_floor_status_flags(7, 0)
			if bit32.band(var13, 1) ~= 0 then
				event.open_message_window_2(0, "Le scell[UNI00e9] rouge a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
			end
			if bit32.band(var13, 2) ~= 0 then
				event.open_message_window_2(0, "Le scell[UNI00e9] bleu a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
			end
			if bit32.band(var13, 4) ~= 0 then
				event.open_message_window_2(0, "Le scell[UNI00e9] blanc a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
			end
			at = 6
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		at = 7
		helper_75684dd8(0, 2130, 8, 0, 0)
		if var12 ~= 1 then
			if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
				at = 8
				helper_75684dd8(0, 2120, 8, 0, 0)
				at = 9
				helper_c55efd8e()
			else
				if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					at = 10
					helper_75684dd8(0, 2110, 8, 0, 0)
				end
				if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					at = 11
					helper_75684dd8(0, 2100, 8, 0, 0)
					at = 12
					helper_c55efd8e()
				end
			end
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(512, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 12 then
			if at <= 1 then
				at = 2
				helper_4c1ba28b(1)
				return vm.continue_with(function()
					if active_chr_no == 1 then
						at = 3
						helper_6c8af328(1)
					end
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 4
						helper_fe9d3952(active_chr_no)
					end
					event.set_dungeon_pause_flags(16384, 0)
					helper_4d4dffcb()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					var2 = event.get_dungeon_floor() or var2
					event.set_dungeon_floor_info(stage_id, var2, 5, 2)
					event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						helper_c3f198dd(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_position(position_x, position_y, position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_look_at(position_x, position_y, position_z)
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					helper_f7c4a947(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					var12 = event.is_trial_version() or var12
					var13 = event.get_dungeon_floor_status() or var13
					if
						(
							if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0
								then 1
								else bit32.band(var13, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(var13, 1) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] rouge a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						if bit32.band(var13, 2) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] bleu a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						if bit32.band(var13, 4) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] blanc a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						at = 6
						helper_75684dd8(0, -1, 8, 0, 0)
					end
					at = 7
					helper_75684dd8(0, 2130, 8, 0, 0)
					if var12 ~= 1 then
						if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							helper_75684dd8(0, 2120, 8, 0, 0)
							at = 9
							helper_c55efd8e()
						else
							if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								helper_75684dd8(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								helper_75684dd8(0, 2100, 8, 0, 0)
								at = 12
								helper_c55efd8e()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_6c8af328(1)
				return vm.continue_with(function()
					if active_chr_no == 2 or active_chr_no == 3 then
						at = 4
						helper_fe9d3952(active_chr_no)
					end
					event.set_dungeon_pause_flags(16384, 0)
					helper_4d4dffcb()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					var2 = event.get_dungeon_floor() or var2
					event.set_dungeon_floor_info(stage_id, var2, 5, 2)
					event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						helper_c3f198dd(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_position(position_x, position_y, position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_look_at(position_x, position_y, position_z)
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					helper_f7c4a947(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					var12 = event.is_trial_version() or var12
					var13 = event.get_dungeon_floor_status() or var13
					if
						(
							if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0
								then 1
								else bit32.band(var13, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(var13, 1) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] rouge a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						if bit32.band(var13, 2) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] bleu a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						if bit32.band(var13, 4) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] blanc a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						at = 6
						helper_75684dd8(0, -1, 8, 0, 0)
					end
					at = 7
					helper_75684dd8(0, 2130, 8, 0, 0)
					if var12 ~= 1 then
						if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							helper_75684dd8(0, 2120, 8, 0, 0)
							at = 9
							helper_c55efd8e()
						else
							if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								helper_75684dd8(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								helper_75684dd8(0, 2100, 8, 0, 0)
								at = 12
								helper_c55efd8e()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 3 then
				at = 4
				helper_fe9d3952(active_chr_no)
				return vm.continue_with(function()
					event.set_dungeon_pause_flags(16384, 0)
					helper_4d4dffcb()
					event.reset_action_character_motion(0, 4)
					event.update_character_motion(0)
					event.reset_character_cloth_and_hair(0)
					event.show_dungeon_status_bar(1, 0.16666667)
					stage_id = event.get_dungeon_stage_id() or stage_id
					var2 = event.get_dungeon_floor() or var2
					event.set_dungeon_floor_info(stage_id, var2, 5, 2)
					event.set_dungeon_floor_info(stage_id, var2, 5, 1024)
					flag = event.get_save_flag(220) or flag
					flag = event.get_save_flag(317) or flag
					is_play_sub_game = event.get_floor_sub_games() or is_play_sub_game
					if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
						event.clear_random_stones()
						helper_c3f198dd(0, -1)
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_position(position_x, position_y, position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						position_x = out1 or position_x
						position_y = out2 or position_y
						position_z = out3 or position_z
					end
					event.set_camera_look_at(position_x, position_y, position_z)
					is_clear_most_fast_destroy = event.record_floor_clear_time() or is_clear_most_fast_destroy
					do
						local out1, out2 = event.get_floor_practice_result(0)
						cleared = out1 or cleared
						bonus = out2 or bonus
					end
					at = 5
					helper_f7c4a947(is_clear_most_fast_destroy, cleared, bonus)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					var12 = event.is_trial_version() or var12
					var13 = event.get_dungeon_floor_status() or var13
					if
						(
							if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0
								then 1
								else bit32.band(var13, 4)
						) ~= 0
					then
						event.set_dungeon_floor_status_flags(7, 0)
						if bit32.band(var13, 1) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] rouge a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						if bit32.band(var13, 2) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] bleu a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						if bit32.band(var13, 4) ~= 0 then
							event.open_message_window_2(0, "Le scell[UNI00e9] blanc a [UNI00e9]t[UNI00e9] bris[UNI00e9].")
						end
						at = 6
						helper_75684dd8(0, -1, 8, 0, 0)
					end
					at = 7
					helper_75684dd8(0, 2130, 8, 0, 0)
					if var12 ~= 1 then
						if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
							at = 8
							helper_75684dd8(0, 2120, 8, 0, 0)
							at = 9
							helper_c55efd8e()
						else
							if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 10
								helper_75684dd8(0, 2110, 8, 0, 0)
							end
							if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
								at = 11
								helper_75684dd8(0, 2100, 8, 0, 0)
								at = 12
								helper_c55efd8e()
							end
						end
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.set_dungeon_pause_flags(512, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 4 then
				helper_35195a56()
				helper_a583d6cd(0, -1)
				helper_7870f366(is_clear_most_fast_destroy, cleared, bonus)
			end
			if at <= 5 then
				helper_ee1c51d0(0, -1, 8, 0, 0)
			end
			if at <= 6 then
				helper_ee1c51d0(0, 2130, 8, 0, 0)
			end
			if at <= 7 then
				helper_ee1c51d0(0, 2120, 8, 0, 0)
			end
			if at <= 8 then
				helper_74f9cdb5()
			end
			if at <= 9 then
				helper_ee1c51d0(0, 2110, 8, 0, 0)
			end
			if at <= 10 then
				helper_ee1c51d0(0, 2100, 8, 0, 0)
			end
			if at <= 11 then
				helper_74f9cdb5()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_6c8af328(0)
end

--- Event 101, which map data, a script or the engine runs by number.
function script.event_101()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		helper_e91d3484()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.load_dungeon_map("d02f01", "d02f01", 1)
		event.load_dungeon_monster(0)
		event.place_treasure_box_at_event_point(-1)
		event.place_dungeon_monster(-1)
		at = 2
		helper_3f104(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_3f104(0)
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 102, which map data, a script or the engine runs by number.
function script.event_102()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	vm.wait(1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.set_character_position(0, var0, var1, var2)
	vm.wait(2)
	event.finish_event()
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local argc: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	argc = event.get_owned_item_count(10) or argc
	if argc <= 0 then
		event.add_inventory_item(10, 1)
	end
	argc = event.get_owned_item_count(302) or argc
	if argc <= 0 then
		event.add_inventory_item(302, 1)
	end
	event.set_save_flag(220, 1)
	event.set_save_flag(317, 1)
	event.clear_event_battle_monsters(-1)
	event.finish_event()
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_44854(0)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_44854(1)
end

--- Event 320, which map data, a script or the engine runs by number.
function script.event_320()
	helper_44854(2)
end

--- Event 330, which map data, a script or the engine runs by number.
function script.event_330()
	helper_44854(3)
end

--- Event 340, which map data, a script or the engine runs by number.
script.event_340 = helper_ced7968c

--- Event 348, which map data, a script or the engine runs by number.
function script.event_348()
	local now_party_chara_id: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local item: s32 = 0
	local active_chr_no: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(1, 1)
	helper_ce85b54c()
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Tu veux juste passer ici, non ?")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.show_dungeon_status_bar(0, 0.16666667)
		event.set_dungeon_pause_flags(16, 1)
		helper_64f3e42f()
		event.set_dungeon_pause_flags(16, 0)
		event.show_dungeon_status_bar(1, 0.16666667)
		wait_frames(6)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	var1 = event.get_triggered_event_data_2(6) or var1
	if var1 == 1 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_draw_speed(0, 1)
		var2 = helper_c292fa16(0, 2501, 5, 256, 208, var2)
		event.set_message_bubble_tail(0, 1)
		event.set_message_draw_speed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait_frames(6)
		event.open_use_item_menu(340)
		vm.wait(6)
		item = vmhost.used_item() or item
		if item == 340 then
			event.set_dungeon_pause_flags(16, 1)
			active_chr_no = event.get_playable_character() or active_chr_no
			if active_chr_no == 2 or active_chr_no == 3 then
				helper_64f3e42f()
			else
				helper_09075129()
			end
			event.set_dungeon_pause_flags(16, 0)
		elseif item <= 0 then
		else
			helper_5fb66cb1()
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait_frames(6)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

script.event_1000 = event_1000

script.event_1010 = event_1010

--- The dungeon system event run when the player opens a treasure box.
script.treasure_box = helper_5b28e690

--- The dungeon system event run when the player steps into a random circle.
function script.random_circle()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local circle_id: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local var27: s32 = 0
	local angle: f32 = 0
	local var29: s32 = 0
	local var30: s32 = 0
	local bright_rate: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.get_direction_angle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.set_character_position(0, var1, var2, var3)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	helper_ce85b54c()
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	helper_479dc9e9()
	var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or var11
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	helper_479dc9e9()
	weight = event.get_random_circle_motion_frame() or weight
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, weight)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.get_random_number(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.wrap_angle(var14) or var14
	event.set_character_rotation(13, 0.0, var14, 0.0)
	event.change_directory("")
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.wrap_angle(var14) or var14
		event.set_character_rotation(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.play_sound_effect(var11, 0)
		end
		if var18 == 30 then
			helper_55646435()
		end
		if (if var18 >= 30 then helper_581cb30c(0) else 0) ~= 0 or var18 > 300 then
			event.stop_sound_effect(var11, 0)
			event.play_sound_effect(var11, 3)
			vm.wait(7)
			break
		else
			var18 = var18 + 1
			vm.wait(8)
		end
	end
	helper_3cf99f2c()
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	var27 = 0
	var27 = vm.float_bits(event.get_random_number(10)) or var27
	var27 = vm.i32(var27 + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.wrap_angle(var14) or var14
		event.set_character_rotation(13, 0.0, var14, 0.0)
		vm.wait(9)
		if var18 >= var27 then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.wrap_angle(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if var14 < angle and helper_f7fba8ce(var14, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.get_character_rotation(13)
		var14 = out2 or var14
	end
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	var26 = var14
	wait_frames(20)
	var29 = vm.float_bits(event.get_random_number(10)) or var29
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if var29 < var30 then
		var29 = vm.float_bits(event.get_random_number(10)) or var29
		if circle_id == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if var29 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.wrap_angle(var26) or var26
			event.rotate_object_sequence(5, 0.0, var26, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait_frames(10)
		else
			var29 = vm.float_bits(event.get_random_number(10)) or var29
			if var29 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.wrap_angle(var26) or var26
				event.rotate_object_sequence(5, 0.0, var26, 0.0, 3)
				wait_frames(20)
			end
		end
	end
	var26 = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.get_character_rotation(13)
		var14 = out2 or var14
	end
	if helper_f7fba8ce(var14, var26, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	var18 = 0
	var32 = event.get_random_circle_effect(circle_id) or var32
	if circle_id == 0 then
		event.play_sound_effect(var11, 1)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(13)
		end
		helper_75684dd8(0, 2310, 8, 0, 0)
		result = event.apply_random_circle_effect(var32) or result
		if var32 == 1 then
			helper_75684dd8(0, 2311, 8, 0, 0)
		end
		if var32 == 2 then
			helper_75684dd8(0, 2312, 8, 0, 0)
		end
		if var32 == 3 then
			helper_75684dd8(0, 2313, 8, 0, 0)
		end
		if var32 == 4 then
			event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_75684dd8(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(var11, 2)
		while var18 < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			var18 = var18 + 1
			vm.wait(19)
		end
		helper_75684dd8(0, 2320, 8, 0, 0)
		result = event.apply_random_circle_effect(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_75684dd8(0, 2321, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_75684dd8(0, 2322, 8, 0, 0)
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_75684dd8(0, 2323, 8, 0, 0)
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_75684dd8(0, 2324, 8, 0, 0)
			end
			if active_chr_no == 2 then
				helper_75684dd8(0, 2325, 8, 0, 0)
			end
		end
		if var32 == 8 then
			helper_75684dd8(0, 2328, 8, 0, 0)
		end
		if var32 == 9 then
			helper_75684dd8(0, 2326, 8, 0, 0)
		end
		if var32 == 10 then
			helper_75684dd8(0, 2329, 8, 0, 0)
		end
		if var32 == 11 then
			helper_75684dd8(0, 2327, 8, 0, 0)
		end
		if var32 == 12 then
			helper_75684dd8(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if var32 == 1 then
		event.spawn_pull_items(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_camera_position(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_camera_look_at(position_x, position_y, position_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- The dungeon system event run when the player uses the geostone.
function script.geostone()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		helper_ce85b54c()
		if active_chr_no == 2 then
			helper_75684dd8(0, 22, 8, 0, 0)
		else
			helper_75684dd8(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.set_dungeon_pause_flags(16, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_save_flag(31, 1)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or var4
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.copy_vector(var8, var9, var10)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	var17 = event.get_direction_angle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.wrap_angle(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.wrap_angle(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.set_character_position(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.wrap_angle(var17) or var17
	event.set_character_rotation(0, 0.0, var17, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_chr_no == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var8, var9 + 18.0, var10)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var8, var9 + 18.0, var10)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		pos_x_3 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		pos_y_3 = vm.f32(var9 + 18.0)
		pos_z_3 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.set_character_position(12, pos_x_3, pos_y_3, pos_z_3)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait_frames(16)
	event.play_sound_effect(var4, 0)
	wait_frames(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait_frames(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.get_direction_angle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.set_character_rotation(12, 0.0, var17, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait_frames(20)
	event.play_sound_effect(var4, 1)
	wait_objects(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	argc = event.get_system_sound_id() or argc
	event.play_sound_effect(argc, 18)
	helper_75684dd8(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	var23 = event.get_dungeon_floor() or var23
	event.set_dungeon_floor_info(stage_id, var23, 5, 256)
	event.start_crossfade(10)
	if active_chr_no == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, var1, var2, var3)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.set_camera_control_enabled(1)
	event.finish_event()
end

--- The dungeon system event run for a monster that can be talked to.
function script.monster_talk()
	local var0: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		helper_313d0b27()
		return
	end
	do
		local _, out2, _ = event.get_monster_talk_data_3()
		var2 = out2 or var2
	end
	flag = event.get_save_flag(290) or flag
	if flag == 0 and var2 == 52 then
		event.add_inventory_item(356)
		helper_1487c()
	else
		helper_313d0b27()
	end
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = helper_2561c

--- The dungeon system event run on the first examination of a random stone.
function script.random_stone_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.set_save_flag(50, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	helper_75684dd8(0, 2600, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Event 2510, which map data, a script or the engine runs by number.
function script.event_2510()
	local var0: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	open_message(0, 2610, 8, 0, 0)
	wait_frames(30)
	do
		local _: any
		_, var0 = wait_message_answer(0, 0, var0)
	end
	close_message(0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the player levels up.
function script.level_up_guide()
	local var0: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	open_message(0, 2620, 8, 0, 0)
	wait_frames(30)
	do
		local _: any
		_, var0 = wait_message_answer(0, 0, var0)
	end
	close_message(0)
	helper_75684dd8(0, 2621, 8, 0, 0)
	helper_75684dd8(0, 2622, 8, 0, 0)
	helper_75684dd8(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "Voir Aide (Menu principal) pour infos")
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the ridepod's wheels are used.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Conduire le Tout-terrain\n   Acc[UNI00e9]l[UNI00e8]re avec (L)↑ - Ralentis avec (L)↓.\n   Tourne avec (L) ← ou →.\n   Virages serr[UNI00e9]s : [l1] + (L) ← ou →."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- The dungeon system event run the first time the magic sword counter fills.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Tu ma[UNI00ee]trises d[UNI00e9]sormais la Lame Absomagie.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La Lame Absomagie permet d'absorber\nl'[UNI00e9]nergie des attaques [UNI00e9]l[UNI00e9]mentales\n(ex : feu) en parant. Pour renvoyer\nl'[UNI00e9]nergie, il suffit d'attaquer."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Tu peux sans cesse accumuler de\nl'[UNI00e9]nergie d'un m[UNI00ea]me type [UNI00e9]l[UNI00e9]mental.\nMais si tu absorbes un autre type\nd'[UNI00e9]nergie, ton arme se d[UNI00e9]chargera."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La quantit[UNI00e9] maximale d'[UNI00e9]nergie\n[UNI00e9]l[UNI00e9]mentale absorb[UNI00e9]e par une arme\nd[UNI00e9]pend de la solidit[UNI00e9] de celle-ci."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Pour rel[UNI00e2]cher l'[UNI00e9]nergie [UNI00e9]l[UNI00e9]mentale\naccumul[UNI00e9]e, appuie sur [l1] tout en\nparant avec [r1]."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- The Sphida event run when the player stands at the ball and presses the action button.
function script.sphida_shot()
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local level: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: s32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var51: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var57: any = 0
	vm.wait(1)
	event.initialize_event()
	helper_ce85b54c()
	event.set_character_motion(0, "立ち")
	if helper_17b6d01b() ~= 0 then
		event.finish_event()
		return
	end
	event.show_dungeon_status_bar(0, 0.1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_4(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	vm.wait(3)
	helper_479dc9e9()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.get_sphida_texture_bank() or tex_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.initialize_effect_manager(5, 1)
	event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var2, var3, var4, var6 = helper_49c6448e(var2, var3, var4, var6)
	helper_1a7fd8eb(var6)
	event.set_sphida_status_panel_visible(1)
	var11 = 12.5
	event.set_sphida_carry_angle(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12, var13, level = helper_39ab7f1f(var12, var13, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, var6, var11 = helper_86f3f24c(var6, var11, tex_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(var8, var9, var10)
			event.set_character_position(8, var8, var9, var10)
			event.set_character_position(9, var8, var9, var10)
			helper_03a1d6f1(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, var12, var6, var16, var15, level = helper_b1b0c1a6(var12, tex_bank, var6, var16, var15, var1, level)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(var2, var3, var4)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var21 = 0
	if level ~= 1 and level ~= -1 and level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, var2, var3 + 30.0, var4)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if level == 2 or level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if level == 3 or level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait_frames(10)
	end
	if var12 <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait_frames(25)
		if level ~= 4 then
			event.play_sound_effect(var1, 3)
		end
	elseif var12 <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait_frames(34)
		event.play_sound_effect(var1, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait_frames(39)
		if level == 0 then
			event.play_sound_effect(var1, 12)
		else
			event.play_sound_effect(var1, 1)
		end
	end
	if level == 4 then
		wait_frames(50)
		helper_f90045b0(var1)
		event.set_sphida_ball_position(var8, var9, var10)
		event.set_character_position(8, var8, var9, var10)
		event.set_character_position(9, var8, var9, var10)
		helper_03a1d6f1(0)
		return
	end
	if level == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	var12 = helper_dff48a5c(var12)
	var11 = vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12 = vm.f32(var12 - vm.f32(var12 * var11))
	var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(var11)))
	var23 = vm.f32(var12 * vm.sin(var11))
	var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(var11)))
	var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
	var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
	var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var29 = 0
	level = 0
	var42 = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, var2, var3 + 5.0, var4, var2, var3, var4, 0)
		var30 = out1 or var30
		var31 = out2 or var31
		var32 = out3 or var32
		var41 = out4 or var41
		var43 = out5 or var43
	end
	if var41 >= 0 and (var43 == 1 or var43 == 7) then
		print("----------------START_MIZU-------------------\n")
		var12 = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		var12 = 0.0
	end
	var46 = 0
	while true do
		if var3 >= 180.0 then
			var22 = vm.f32(var22 * vm.f32(0.999))
			var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
			var24 = vm.f32(var24 * vm.f32(0.999))
		else
			var41 = event.get_segment_collision_9(12, var2, var3, var4, var2, vm.f32(var3 - 3.0) - vm.f32(0.01), var4, 0)
				or var41
			if level == 1 and var41 >= 0 then
				var22 = vm.f32(var22 * vm.f32(0.94))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.94))
				var22 = vm.f32(var22 + var15)
				var24 = vm.f32(var24 + var17)
				var15 = vm.f32(var15 * vm.f32(0.8))
				var17 = vm.f32(var17 * vm.f32(0.8))
			else
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(var2, var3, var4, var22, var23, var24)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		if var16 ~= 0.0 then
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			var11 = vm.f32(var11 + var16)
			var11 = event.wrap_angle(var11) or var11
			var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
			var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
		end
		var40 = event.get_vector_length(var15, 0.0, var17) or var40
		if var40 > vm.f32(0.01) then
			var25 = event.get_vector_length(var15, 0.0, var17) or var25
			var11 = event.get_direction_angle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.set_character_rotation(8, var5, var11, var7)
			event.offset_character_rotation(8, var25 * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, var5, var11, var7)
			event.offset_character_rotation(9, var25 * 12.0, 0.0, 0.0)
		else
			var25 = event.get_vector_length(var22, 0.0, var24) or var25
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.set_character_rotation(8, var5, var11, var7)
			event.offset_character_rotation(8, var25 / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, var5, var11, var7)
			event.offset_character_rotation(9, var25 / 10.0, 0.0, 0.0)
		end
		var25 = event.get_vector_length(var22, var23, var24) or var25
		var39 = var25
		var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
		var36 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		var38 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			var2 - var36,
			var3,
			var4 - var38,
			vm.f32(var2 + var36) + var36,
			var3,
			vm.f32(var4 + var38) + var38
		)
		do
			local out1, out2, out3 = event.copy_vector(var22, var23, var24)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 0)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var41 = out4 or var41
			var43 = out5 or var43
		end
		if var41 >= 0 and (var43 == 1 or var43 == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(var30, var31, var32)
			if var42 <= 0 then
				event.play_sound_effect(var1, 11)
				var42 = 10
			end
			if var12 == 0.0 then
				var12 = 1.0
				var22 = vm.f32(var22 * vm.f32(0.4))
				var23 = vm.f32(var23 * vm.f32(0.4))
				var24 = vm.f32(var24 * vm.f32(0.4))
				var15 = 0.0
				var17 = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				var12 = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
		end
		if var41 < 0 then
			if var3 >= 380.0 and var23 > 0.0 then
				do
					local out1, out2, out3 = event.copy_vector(var2, var3, var4)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
				end
				do
					local out1, out2, out3 = event.copy_vector(var22, -var23, var24)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.normalize_vector(var33, var34, var35)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				var41 = 1
			end
		end
		while var41 >= 0 do
			var16 = 0.0
			if var25 > 8.0 then
				helper_79d90c82()
			end
			if var12 ~= 1.0 and var42 <= 0 then
				event.play_sound_effect(var1, 6)
				var42 = 10
			end
			do
				local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.normalize_vector(var22, var23, var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.scale_vector(var22, var23, var24, 3.0)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.add_vectors(var30, var31, var32, var22, var23, var24)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var30, var31, var32)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var40 = event.get_vector_length(var18, var19, var20) or var40
			var40 = vm.f32(var39 - var40)
			if var40 <= 0.0 then
				break
			else
				var39 = var40
				do
					local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				if var23 < 0.0 and var34 > 0.0 then
					var22 = vm.f32(var15 * 2.0)
					var23 = 0.0
					var24 = vm.f32(var17 * 2.0)
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					if
						var22 < 0.0 and var33 > 0.0
						or var22 > 0.0 and var33 < 0.0
						or var24 < 0.0 and var35 > 0.0
						or var24 > 0.0 and var35 < 0.0
					then
						var15 = 0.0
						var17 = 0.0
					end
					var22 = 0.0
					var23 = 0.0
					var24 = 0.0
				end
				if var12 == 0.0 then
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.9)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.58)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.9)) + var24)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.8)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.4)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.8)) + var24)
				end
				do
					local out1, out2, out3 = event.copy_vector(var30, var31, var32)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				do
					local out1, out2, out3 = event.copy_vector(var22, var23, var24)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.scale_vector(var33, var34, var35, var40)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.copy_vector(var30, var31, var32)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3 = event.add_vectors(var2, var3, var4, var33, var34, var35)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.get_segment_collision_16(
						12,
						var18,
						var19,
						var20,
						var2 + var36,
						var3 + var37,
						var4 + var38,
						1
					)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
					var33 = out4 or var33
					var34 = out5 or var34
					var35 = out6 or var35
					var41 = out7 or var41
					var43 = out8 or var43
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
			var43 = out8 or var43
		end
		if var41 >= 0 then
			var16 = 0.0
			var3 = vm.f32(var31 + 3.0)
			var40 = event.get_vector_length(var22, 0.0, var24) or var40
			if var40 < vm.f32(2.6) or var23 >= -1.0 and var23 <= 0.0 then
				var23 = 0.0
				level = 1
			else
				if var12 == 0.0 then
					var22 = vm.f32(var22 * vm.f32(0.9))
					var23 = -vm.f32(var23 * vm.f32(0.58))
					var24 = vm.f32(var24 * vm.f32(0.9))
					var22 = vm.f32(var22 + vm.f32(var15 * 2.0))
					var24 = vm.f32(var24 + vm.f32(var17 * 2.0))
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					var22 = vm.f32(var22 * vm.f32(0.8))
					var23 = -vm.f32(var23 * vm.f32(0.4))
					var24 = vm.f32(var24 * vm.f32(0.8))
					var15 = 0.0
					var17 = 0.0
				end
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var12 ~= 1.0 and var42 <= 0 then
					event.play_sound_effect(var1, 5)
					var42 = 10
				end
			end
			var40 = event.get_vector_length(var15, 0.0, var17) or var40
			if var23 == 0.0 and var25 < vm.f32(1.6) and var40 < vm.f32(0.4) then
				if var43 == 6 then
					var29 = 1
					break
				end
				var43 = event.get_automap_attribute_status(var2, var3, var4) or var43
				if not (var43 == 1) then
					break
				end
				var29 = 1
				break
			end
		end
		if var3 < -500.0 then
			var29 = 1
			break
		elseif var46 >= 480 then
			var29 = 1
			break
		else
			var44 = event.get_sphida_pin_color() or var44
			var45 = event.get_sphida_ball_color() or var45
			x = vm.f32(pos_x - var2)
			y = vm.f32(pos_y - var3)
			z = vm.f32(pos_z - var4)
			var47 = event.get_vector_length(x, y, z) or var47
			if var45 ~= var44 then
				var51 = event.get_point_to_segment_distance(var18, var19, var20, var2, var3, var4, pos_x, pos_y, pos_z) or var51
				if var51 >= 0.0 and var51 <= 30.0 then
					var21 = 1
					break
				end
				if var47 ~= 0.0 then
					if var47 <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var47))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.add_vectors(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				else
					var21 = 1
					break
				end
			elseif var47 ~= 0.0 then
				if var47 <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var47))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var2, var3, var4, x, y, z)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var22, var23, var24, x, y, z)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
				end
			end
			event.set_character_position(8, var2, var3, var4)
			event.set_character_position(9, var2, var3, var4)
			do
				local out1, out2, out3 = event.copy_vector(var2, var3, var4)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			if var3 <= -50.0 then
				event.set_follow_camera_following(0)
				if var29 >= 30 then
					if var29 >= 50 then
						break
					end
				else
					event.set_camera_look_at(var2, var3, var4)
				end
				var29 = var29 + 1
			elseif var46 >= 20 then
				event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
				event.set_camera_speed(8.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_target(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24
				)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.get_direction_angle(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_camera_control_rotation(yaw)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(var2, var3, var4)
			vm.wait(15)
			if var42 > 0 then
				var42 = var42 - 1
			end
			var46 = var46 + 1
		end
	end
	event.set_character_position(8, var2, var3, var4)
	event.set_character_position(9, var2, var3, var4)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if var29 == 0 then
		event.set_sphida_ball_position(var2, var3, var4)
		count = event.get_sphida_par() or count
		if var21 == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pos_x, pos_y, pos_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(var1, 17)
			var46 = 0
			while var46 < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var46 = var46 + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var46 = 0
			while var46 < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				var46 = var46 + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			var44 = event.get_dungeon_stage_id() or var44
			var45 = event.get_dungeon_floor() or var45
			var41 = event.get_dungeon_floor_info(var44, var45, 4) or var41
			do
				local out1, out2 = event.get_sphida_prize(var41)
				var42 = out1 or var42
				var43 = out2 or var43
			end
			var41 = vm.i32(var41 + 1)
			event.set_dungeon_floor_info(var44, var45, 4, var41)
			event.place_treasure_box(pos_x, pos_y - 30.0, pos_z, var11, var42, var43)
			wait_frames(54)
			wait_frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var1
			event.stop_music(0)
			event.play_sound_effect(var1, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			var42 = event.get_language() or var42
			if var42 == 0 then
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 206, 0, 306, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			end
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			wait_objects(0)
			wait_frames(90)
			vm.wait(22)
			event.play_music(0)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		elseif count >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			var57 = helper_bac0e30d(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(24)
			if var57 == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(var2, var3, var4, 100.0, "point")
					var41 = out1 or var41
					var8 = out2 or var8
					var9 = out3 or var9
					var10 = out4 or var10
				end
				if var41 == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(var2, var3, var4, 100.0)
						var8 = out1 or var8
						var9 = out2 or var9
						var10 = out3 or var10
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				var25 = event.get_distance_between(var8, var9, var10, pos_x, pos_y, pos_z) or var25
				if var25 < 40.0 then
					var11 = event.get_random_number(6.2831855) or var11
					var11 = vm.f32(var11 - vm.f32(3.1415927))
					var8 = vm.f32(var8 + vm.f32(vm.sin(var11) * 50.0))
					var10 = vm.f32(var10 + vm.f32(vm.cos(var11) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var8, var9, var10)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
						var41 = out4 or var41
					end
					var46 = 0
					while var41 >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(var8, var9, var10)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var30, var31, var32)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						var18 = vm.f32(var18 + 1.0)
						var20 = vm.f32(var20 + 1.0)
						do
							local out1, out2, out3 = event.normalize_vector(var18, var19, var20)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.scale_vector(var18, var19, var20, 30.1)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.copy_vector(var30, var31, var32)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						do
							local out1, out2, out3 = event.add_vectors(var8, var9, var10, var18, var19, var20)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						var46 = var46 + 1
						if var46 > 6 then
							break
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(var8, var9, var10)
							var30 = out1 or var30
							var31 = out2 or var31
							var32 = out3 or var32
							var41 = out4 or var41
						end
					end
				end
				var6 = event.get_direction_angle(var8, var9, var10, var2, var3, var4) or var6
				event.set_character_position(0, var8, var9, var10)
				event.set_character_rotation(0, 0.0, var6, 0.0)
				event.set_camera_look_at(var8, var9 + 30.0, var10)
				var6 = vm.f32(var6 - vm.f32(3.1415927))
				var6 = event.wrap_angle(var6) or var6
				var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
				var9 = vm.f32(var9 + 30.0)
				var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
				event.set_camera_position(var8, var9, var10)
				event.reset_follow_camera(0)
			end
		end
	else
		event.play_sound_effect(var1, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		wait_objects(0)
		wait_frames(20)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_sphida_ball_position(var8, var9, var10)
		event.set_character_position(8, var8, var9, var10)
		event.set_character_position(9, var8, var9, var10)
		event.release_camera_sequence_follow_object()
	end
	if var21 == 1 then
		helper_f90045b0(-1)
	else
		helper_f90045b0(var1)
	end
	helper_03a1d6f1(var21)
end

--- The Sphida event run when the menu button is pressed near the ball.
function script.sphida_near_ball()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	var0 = helper_bac0e30d(0, 2004, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		helper_f90045b0(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- The Sphida event run when the menu button is pressed near the ball with fewer than two shots of par left.
function script.sphida_near_ball_last()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "C'est la derni[UNI00e8]re fois que tu\npeux amener la sph[UNI00e8]re [UNI00e0] toi.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Amener la sph[UNI00e8]re jusqu'[UNI00e0] toi ?")
	var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Event 4000, which map data, a script or the engine runs by number.
function script.event_4000()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		helper_e91d3484()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.load_dungeon_map("d02f01", "d02f01", 1)
		at = 2
		helper_3f104(0)
		helper_c3f198dd(0, -1)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_3f104(0)
				return vm.continue_with(function()
					helper_c3f198dd(0, -1)
					return
				end)
			end
			helper_a583d6cd(0, -1)
			return 0
		end
		return nil
	end)
end

--- Event 12551, which map data, a script or the engine runs by number.
function script.event_12551()
	helper_b2cb6e46()
	event.load_dungeon_map("d02b01")
	vm.wait(2)
	event.load_event_script("d02b01/d02b01.stb", 12551)
end

--- Event 12552, which map data, a script or the engine runs by number.
function script.event_12552()
	helper_b2cb6e46()
	event.load_dungeon_map("d02b01")
	vm.wait(2)
	event.load_event_script("d02b01/d02b01.stb", 12552)
end

--- Event 12560, which map data, a script or the engine runs by number.
function script.event_12560()
	helper_b2cb6e46()
	event.load_dungeon_map("d02b01")
	vm.wait(2)
	event.load_event_script("d02b01/d02b01.stb", 12560)
end

--- Event 12570, which map data, a script or the engine runs by number.
function script.event_12570()
	helper_b2cb6e46()
	event.load_dungeon_map("d02b02")
	vm.wait(2)
	event.load_event_script("d02b02/d02b02.stb", 12570)
end

--- Event 12600, which map data, a script or the engine runs by number.
function script.event_12600()
	helper_b2cb6e46()
	event.load_dungeon_map("d02b02")
	vm.wait(2)
	event.load_event_script("d02b02/d02b02.stb", 12600)
end

--- Event 22030, which map data, a script or the engine runs by number.
function script.event_22030()
	event.set_character_max_hp(0, 64)
	event.set_character_max_hp(1, 64)
	event.set_character_defence(0, 16)
	event.set_character_defence(1, 16)
	event.add_inventory_item(18)
	event.equip_character_item(0, 18)
	event.add_inventory_item(25)
	event.equip_character_item(0, 25)
	event.add_inventory_item(48)
	event.equip_character_item(1, 48)
	event.add_inventory_item(92)
	event.equip_character_item(1, 92)
	event.load_dungeon_map("d02b02")
	vm.wait(1)
	event.load_event_script("d02b02/d02b02.stb", 200)
end

--- Event 26010, which map data, a script or the engine runs by number.
function script.event_26010()
	local argc: s32 = 0
	event.set_character_max_hp(0, 160)
	event.set_character_max_hp(1, 160)
	event.set_character_defence(0, 50)
	event.set_character_defence(1, 50)
	argc = event.get_item_count(270) or argc
	if argc < 20 then
		event.add_inventory_item(270, vm.i32(20 - argc))
	end
	event.add_inventory_item(16)
	event.equip_character_item(0, 16)
	event.add_inventory_item(27)
	event.equip_character_item(0, 27)
	event.add_inventory_item(71)
	event.equip_character_item(1, 71)
	event.add_inventory_item(100)
	event.equip_character_item(1, 100)
	event.load_dungeon_map("s13")
	vm.wait(1)
	event.load_event_script("s13/s13.stb", 26010)
end

return script
