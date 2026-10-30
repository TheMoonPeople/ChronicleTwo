--!strict
-- map/i/i01/h01/i01h01b_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_002f07c1 = require("@lib/event/helper_002f07c1")
local helper_0999bd0f = require("@lib/event/helper_0999bd0f")
local helper_113adf71 = require("@lib/event/helper_113adf71")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3d7d594a = require("@lib/event/helper_3d7d594a")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_658b1052 = require("@lib/event/helper_658b1052")
local helper_6d5ac092 = require("@lib/event/helper_6d5ac092")
local helper_788a73ff = require("@lib/event/helper_788a73ff")
local helper_8197b747 = require("@lib/event/helper_8197b747")
local helper_86e93423 = require("@lib/event/helper_86e93423")
local helper_8ff1b441 = require("@lib/event/helper_8ff1b441")
local helper_99174c56 = require("@lib/event/helper_99174c56")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_b5dc508b = require("@lib/event/helper_b5dc508b")
local helper_b7c3c21b = require("@lib/event/helper_b7c3c21b")
local helper_b9156308 = require("@lib/event/helper_b9156308")
local helper_cb2597fe = require("@lib/event/helper_cb2597fe")
local helper_ee93982c = require("@lib/event/helper_ee93982c")
local helper_f2976400 = require("@lib/event/helper_f2976400")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local helper_f488989f = require("@lib/event/helper_f488989f")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_13d2c(se_id: s32, se_id_2: s32)
	event.set_camera_sequence_position(38.3, 34.99, -138.13)
	event.set_camera_sequence_look_at(16.02, 28.99, -153.84)
	event.set_character_active(1, 0)
	event.set_object_sequence_motion(0, "カメラゲット", 4)
	event.set_object_handle_visible(1, 0)
	event.set_object_sequence_rotation(1, 0.0, -2.23, 0.0)
	event.detach_character_from_frame(33)
	event.attach_character_to_frame(0, "ef00", 33)
	event.pause_music()
	event.play_sound_effect(se_id_2, 0)
	event.play_sound_effect(se_id, 7)
	event.set_object_sequence_position(2, -10.42, 26.48, -171.78)
	event.set_object_sequence_rotation(2, 0.0, 1.02, 0.0)
	event.set_object_sequence_motion(2, "発動", 6)
	event.set_object_handle_visible(2, 1)
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]Ya tienes la C[UNI00e1]mara.\n Equ[UNI00ed]pala mediante el men[UNI00fa] Objetos.\n [UNI00da]sala pulsando el bot[UNI00f3]n (#)."
	)
	show_message(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Cuando est[UNI00e9]s en una Mazmorra, s[UNI00f3]lo podr[UNI00e1]s\nusar la C[UNI00e1]mara si est[UNI00e1]\nequipada como Objeto activo."
	)
	show_message(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
	helper_f38eabca(355, 1)
	event.play_music(0)
end

--- Helper function.
local function helper_14a00()
	local var0: s32 = 0
	local var1: s32 = 0
	local projection: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_save_flag(105, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(1222)
		var0 = event.load_sound_effect_file_2(1222) or var0
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var1
		event.load_character(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.set_character_active(1, 25)
		event.set_character_position(25, 62.85, 11.43, -176.07)
		event.set_character_rotation(25, 0.0, -0.72, 0.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_camera_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = event.get_camera_look_at()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		projection = event.get_event_projection() or projection
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-13.56, 50.69, -99.84)
		event.set_camera_sequence_look_at(47.32, 59.3, -184.47)
		event.load_character_motion_pack(5, "event/e100/e105/e105_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/e100/e105/e105_starbre.gltf", "info", 32)
		event.set_character_active(0, 24)
		event.set_character_active(1, 32)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_item_model(5, 369, "info", 33)
		event.set_character_active(0, 33)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 34)
		event.set_character_active(1, 34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_visible(2, 0)
		block = event.load_event_image_4(5, "textures/event/e100/e105/e105a_2d.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e105a_2d01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e105a_2d02", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(4, 1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_time_of_day(7)
		event.load_message_file(0, 5, "event/e100/e105/e105a_1.txt")
		event.stop_music(0)
		wait_frames(4)
		event.load_music(193)
		event.play_music(0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		helper_b9156308(var0)
		helper_6d5ac092(var0)
		helper_b5dc508b(var0)
		helper_f488989f(var0)
		helper_002f07c1(var0)
		helper_13d2c(var0, var1)
		helper_ee93982c(var0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_event_image(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_save_flag(56, 0)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(46)
	event.play_music(0)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.set_event_projection(projection)
	event.set_object_handle_footstep_sound(0, 0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1986c(se_id: s32)
	event.set_camera_sequence_position(16.09, 22.59, -109.83)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, 55.27, -1.12, -130.46)
	event.set_object_sequence_rotation(0, 0.0, -2.24, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "立ち", 4)
	wait_frames(15)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(1, "お金をやる", 6)
	event.queue_object_sequence_next_motion(1, "お金をやるL")
	wait_frames(14)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050400)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 4)
	event.set_object_sequence_motion(0, "お金をもらう", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "お金をもらうL")
	wait_frames(60)
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(0, "[UNI00a1]Has conseguido 400 Gildas!")
	show_message(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
	event.set_object_sequence_motion(1, "お金をやる戻り", 6)
	event.queue_object_sequence_next_motion(1, "立ち")
	wait_objects(1)
end

--- Helper function.
local function helper_1b810(se_id: s32, se_id_2: s32)
	local var2: s32 = 0
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_camera_sequence_position(133.98, 56.46, -175.98)
	event.set_camera_sequence_look_at(64.38, 33.46, -162.4)
	event.set_object_sequence_position(0, 50.4, -0.02, -124.87)
	event.set_object_sequence_rotation(0, 0.0, -1.94, 0.0)
	event.set_object_sequence_motion(0, "右を見るL")
	event.set_object_sequence_position(1, 26.91, -0.02, -138.97)
	event.set_object_sequence_rotation(1, 0.0, 0.93, 0.0)
	event.set_object_sequence_motion(1, "左を見るL")
	event.set_character_position(25, 62.71, 11.43, -173.15)
	event.set_character_rotation(25, 0.0, -1.52, 0.0)
	event.set_character_active(1, 36)
	event.set_object_sequence_position(4, 74.43, 34.16, -174.29)
	event.set_object_sequence_rotation(4, 0.0, -1.64, 0.0)
	event.set_object_sequence_position(5, 75.19, 35.28, -173.96)
	event.set_object_sequence_rotation(5, 0.0, -1.52, 0.0)
	event.set_object_sequence_motion(5, "発動", 6)
	event.set_object_handle_visible(5, 1)
	wait_frames(30)
	event.play_sound_effect(se_id_2, 0)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	wait_frames(15)
	event.play_sound_effect(se_id, 8)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050520)
	event.reset_mouth_texture_animations()
	var2 = event.get_message_window_frame(0) or var2
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]Puedes usar el Ridepod eligi[UNI00e9]ndolo\n en el apartado Personaje del men[UNI00fa] Principal. Para\n abreviar, tambi[UNI00e9]n puedes pulsar el bot[UNI00f3]n (R3)."
	)
	show_message(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, var2)
end

--- Helper function.
local function helper_1c5b0(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	vm.section(function()
		vm.entry(1)
		do
			local out1, out2, out3 = event.get_character_position(25)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		do
			local out1, out2, out3 = event.get_character_rotation(25)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		event.set_save_flag(105, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var1 = event.load_sound_effect_file_2(1228) or var1
		var2 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var2
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_camera_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = event.get_camera_look_at()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		event.clear_camera_sequence()
		event.load_character(5, "event/e100/e105/e105_starbre.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character_motion_pack(5, "event/e100/e105/e105_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_sound_bank(0, var1)
		event.load_character(5, "event/e100/e105/e105_back.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.load_character(5, "event/e100/e105/back01.gltf", "info", 36)
		event.set_character_active(1, 36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
		event.set_character_active(1, 37)
		event.attach_object_handle_to_character(5, 37)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_handle_visible(5, 0)
		event.load_message_file(0, 5, "event/e100/e105/e105c_1.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		if arg0 == 1 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_3d7d594a(var1)
		end
		if arg0 == 2 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_cb2597fe(var1)
			event.reset_object_sequence_dynamic_animation(0)
			helper_8197b747(var1)
			event.reset_object_sequence_dynamic_animation(0)
			helper_1986c(var1)
		end
		if arg0 == 3 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_1ef0d4b2()
		end
		if arg0 == 4 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_f2976400(var1)
		end
		if arg0 == 5 then
			event.stop_music(0)
			event.reset_object_sequence_dynamic_animation(0)
			helper_8ff1b441(var1)
			event.reset_object_sequence_dynamic_animation(0)
			helper_1b810(var1, var2)
			event.reset_object_sequence_dynamic_animation(0)
			helper_113adf71(var1)
		end
	end)
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait_frames(30)
	if arg0 == 5 then
		event.play_music(0)
	end
	event.set_character_position(25, var3, var4, var5)
	event.set_character_rotation(25, var6, var7, var8)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.set_character_active(1, 0)
	vm.wait(12)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0999bd0f

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_86e93423()
	event.set_save_flag(18, 1)
	event.set_save_flag(21, 1)
	helper_14a00()
	helper_658b1052()
	event.set_character_position(0, 16.25, -0.02, -166.37)
	event.set_character_rotation(0, 0.0, 1.16, 0.0)
	event.set_character_motion(0, "立ち")
	event.set_villager_ai_enabled(0, 24)
	event.set_character_position(24, 38.77, -0.02, -147.68)
	event.set_character_rotation(24, 0.0, -2.04, 0.0)
	event.set_character_motion(24, "立ち")
	event.set_villager_ai_enabled(1, 24)
	event.set_save_data_value(0, 3)
	event.add_inventory_item(369, 1)
	event.add_inventory_item(355, 1)
	helper_a87eb945(1)
	vm.wait(3)
	event.load_event_script("i01h01/i01h01_1.stb", -1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(10, 0.0, 0.0, 0.0)
		at = 1
		wait_frames(10)
		helper_86e93423()
		at = 2
		helper_b7c3c21b()
		helper_658b1052()
		event.set_character_position(0, 16.25, -0.02, -166.37)
		event.set_character_rotation(0, 0.0, 1.16, 0.0)
		event.set_character_motion(0, "立ち")
		event.set_villager_ai_enabled(0, 24)
		event.set_character_position(24, 38.77, -0.02, -147.68)
		event.set_character_rotation(24, 0.0, -2.04, 0.0)
		event.set_character_motion(24, "立ち")
		at = 3
		vm.wait(3)
		event.set_villager_ai_enabled(1, 24)
		at = 4
		vm.wait(4)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_b7c3c21b()
				return vm.continue_with(function()
					helper_658b1052()
					event.set_character_position(0, 16.25, -0.02, -166.37)
					event.set_character_rotation(0, 0.0, 1.16, 0.0)
					event.set_character_motion(0, "立ち")
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, -2.04, 0.0)
					event.set_character_motion(24, "立ち")
					at = 3
					vm.wait(3)
					event.set_villager_ai_enabled(1, 24)
					at = 4
					vm.wait(4)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if at <= 2 then
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local var0: s32 = 0
	local flag: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local argc_4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.set_save_flag(21, 0)
		event.fade_out_screen(30, 0.0, 0.0, 0.0)
		at = 1
		wait_frames(30)
		helper_86e93423()
		flag = event.get_save_flag(13) or flag
		if flag == 1 then
			at = 2
			helper_1c5b0(5)
			helper_658b1052()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			at = 3
			vm.wait(3)
			event.set_villager_ai_enabled(1, 24)
			event.set_save_flag(20, 1)
			event.set_character_active(1, 26)
			event.attach_character_to_frame(25, "back", 26)
			event.remove_item(165, 1)
			at = 4
			vm.wait(4)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		else
			flag = event.get_save_flag(19) or flag
			if flag == 1 then
				argc = event.get_item_count(224) or argc
				argc_2 = event.get_item_count(245) or argc_2
				argc_3 = event.get_item_count(227) or argc_3
				if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 then
					var0 = event.get_item_count(165) or var0
					print("backpack num =", var0, "---------------\n")
					if var0 == 0 then
						at = 5
						helper_1c5b0(4)
						helper_658b1052()
						event.set_character_position(0, 59.55, -1.12, -135.97)
						event.set_character_rotation(0, 0.0, -2.24, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_villager_ai_enabled(0, 24)
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, 0.72, 0.0)
						event.set_character_motion(24, "立ち")
						at = 6
						vm.wait(6)
						event.set_villager_ai_enabled(1, 24)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
						return
					end
				else
					event.fade_in_screen(0)
					event.set_villager_ai_enabled(0, 24)
					event.open_message_window_2(
						0,
						"Espabila de una vez. La Tienda de Objetos\nest[UNI00e1] justo al otro lado de la calle.\nVete corriendo para all[UNI00ed]."
					)
					at = 7
					helper_1c04a0eb(24, -1, 0, 0)
					event.set_villager_ai_enabled(1, 24)
					at = 8
					vm.wait(8)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
				end
			else
				var0 = event.has_invention_ideas(165) or var0
				if var0 == 1 then
					argc_4 = event.is_invention_created(165) or argc_4
					if argc_4 ~= -1 then
						event.set_save_flag(19, 1)
						event.add_money(400)
						at = 9
						helper_1c5b0(2)
						helper_658b1052()
						event.set_villager_ai_enabled(0, 24)
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, 0.72, 0.0)
						event.set_character_motion(24, "立ち")
						at = 10
						vm.wait(10)
						event.set_villager_ai_enabled(1, 24)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
						return
					else
						at = 11
						helper_1c5b0(1)
						helper_658b1052()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_villager_ai_enabled(0, 24)
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						at = 12
						vm.wait(12)
						event.set_villager_ai_enabled(1, 24)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
						return
					end
				else
					at = 13
					vm.wait(13)
					event.load_event_script("i01h01/i01h01c_1.stb", 500)
					return
				end
			end
		end
		event.fade_in_screen(15)
		event.open_message_window_2(0, "Max, no puedes saltarte el trabajo,\n[UNI00bf]me oyes?")
		at = 14
		helper_1c04a0eb(24, -1, 0, 0)
		at = 15
		vm.wait(15)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_1c5b0(5)
				return vm.continue_with(function()
					helper_658b1052()
					event.set_character_position(0, 16.25, -0.02, -166.37)
					event.set_character_rotation(0, 0.0, 1.16, 0.0)
					event.set_character_motion(0, "立ち")
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, -2.04, 0.0)
					event.set_character_motion(24, "立ち")
					at = 3
					vm.wait(3)
					event.set_villager_ai_enabled(1, 24)
					event.set_save_flag(20, 1)
					event.set_character_active(1, 26)
					event.attach_character_to_frame(25, "back", 26)
					event.remove_item(165, 1)
					at = 4
					vm.wait(4)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if at <= 2 then
				helper_1ef0d4b2()
			end
			return 0
		end
		if at <= 6 then
			if at <= 5 then
				helper_1ef0d4b2()
			end
			return 0
		end
		if at <= 10 then
			if at <= 8 then
				at = 9
				helper_1c5b0(2)
				return vm.continue_with(function()
					helper_658b1052()
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, 0.72, 0.0)
					event.set_character_motion(24, "立ち")
					at = 10
					vm.wait(10)
					event.set_villager_ai_enabled(1, 24)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if at <= 9 then
				helper_1ef0d4b2()
			end
			return 0
		end
		if at <= 12 then
			if at <= 11 then
				helper_1ef0d4b2()
			end
			return 0
		end
		if at <= 13 then
			return 0
		end
		if at <= 15 then
			return 0
		end
		return nil
	end)
end

--- Event 521, which map data, a script or the engine runs by number.
function script.event_521()
	event.set_character_active(0, 24)
	helper_1c5b0(2)
	vm.wait(2)
	event.load_event_script("i01h01/i01h01_1.stb", -1)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		vm.wait(1)
		at = 2
		helper_99174c56()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_788a73ff()
			end
			return 0
		end
		return nil
	end)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local argc_4: s32 = 0
	local argc_5: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.set_save_flag(21, 0)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		helper_86e93423()
		argc_2 = event.get_item_count(165) or argc_2
		if argc_2 >= 1 then
			event.remove_item(165, 1)
			at = 2
			helper_1c5b0(5)
			helper_658b1052()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			at = 3
			vm.wait(3)
			event.set_villager_ai_enabled(1, 24)
			event.set_save_flag(20, 1)
			event.set_character_active(1, 26)
			event.attach_character_to_frame(25, "back", 26)
			at = 4
			vm.wait(4)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		argc_3 = event.get_item_count(224) or argc_3
		argc_4 = event.get_item_count(245) or argc_4
		argc_5 = event.get_item_count(227) or argc_5
		if argc_3 >= 20 and argc_4 >= 1 and argc_5 >= 2 then
			at = 5
			helper_1c5b0(4)
			helper_658b1052()
			event.set_character_position(0, 59.55, -1.12, -135.97)
			event.set_character_rotation(0, 0.0, -2.24, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, 0.72, 0.0)
			event.set_character_motion(24, "立ち")
			at = 6
			vm.wait(6)
			event.set_villager_ai_enabled(1, 24)
			at = 7
			vm.wait(7)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		argc = event.is_invention_created(165) or argc
		if argc ~= -1 then
			at = 8
			helper_1c5b0(2)
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, 0.72, 0.0)
			event.set_character_motion(24, "立ち")
			at = 9
			vm.wait(9)
			event.set_villager_ai_enabled(1, 24)
			at = 10
			vm.wait(10)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		if argc == -1 then
			at = 11
			helper_1c5b0(1)
			helper_658b1052()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			at = 12
			vm.wait(12)
			event.set_villager_ai_enabled(1, 24)
			at = 13
			vm.wait(13)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
			return
		end
		event.fade_in_screen(30)
		at = 14
		vm.wait(14)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_1c5b0(5)
				return vm.continue_with(function()
					helper_658b1052()
					event.set_character_position(0, 16.25, -0.02, -166.37)
					event.set_character_rotation(0, 0.0, 1.16, 0.0)
					event.set_character_motion(0, "立ち")
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, -2.04, 0.0)
					event.set_character_motion(24, "立ち")
					at = 3
					vm.wait(3)
					event.set_villager_ai_enabled(1, 24)
					event.set_save_flag(20, 1)
					event.set_character_active(1, 26)
					event.attach_character_to_frame(25, "back", 26)
					at = 4
					vm.wait(4)
					event.load_event_script("i01h01/i01h01_1.stb", -1)
					return
				end)
			end
			if at <= 2 then
				helper_1ef0d4b2()
			end
			return 0
		end
		if at <= 7 then
			if at <= 5 then
				helper_1ef0d4b2()
			end
			return 0
		end
		if at <= 10 then
			return 0
		end
		if at <= 13 then
			if at <= 11 then
				helper_1ef0d4b2()
			end
			return 0
		end
		if at <= 14 then
			return 0
		end
		return nil
	end)
end

return script
