--!strict
-- map/i/i02/h01/i02h01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_18d9c3c9 = require("@lib/event/helper_18d9c3c9")
local helper_2a6b1824 = require("@lib/event/helper_2a6b1824")
local helper_4919d694 = require("@lib/event/helper_4919d694")
local helper_6cc2fba1 = require("@lib/event/helper_6cc2fba1")
local helper_718a1dd5 = require("@lib/event/helper_718a1dd5")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7e7c045c = require("@lib/event/helper_7e7c045c")
local helper_84a2c453 = require("@lib/event/helper_84a2c453")
local helper_874b82cd = require("@lib/event/helper_874b82cd")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_b7fd5700 = require("@lib/event/helper_b7fd5700")
local helper_c0e39287 = require("@lib/event/helper_c0e39287")
local helper_c53220da = require("@lib/event/helper_c53220da")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_cce8673f = require("@lib/event/helper_cce8673f")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_e72cbda6 = require("@lib/event/helper_e72cbda6")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f3a279da = require("@lib/event/helper_f3a279da")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local helper_fdefb770 = require("@lib/event/helper_fdefb770")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_1ff90()
	local var0: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 6)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 0)
	event.set_object_sequence_position(0, -150.0, 35.8, -1260.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, -119.0, 0.0, -2000.0)
	event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "train08-m0")
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "train08-m1")
	event.attach_object_handle_to_map_part_3(4, "p01_train01", "train10-m0")
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "train10-m1")
	event.attach_object_handle_to_map_part_3(6, "p01_train01", "train10-m12")
	event.attach_object_handle_to_map_part_3(7, "p01_train01", "train10-m13")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_sequence_object(7, 7)
	event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
	var0 = event.get_sound_id(2) or var0
	event.play_sound_effect(var0, 66)
	event.set_camera_sequence_position(-286.2, 99.77, -1363.38)
	event.set_camera_sequence_look_at(-195.75, 74.39, -1275.17)
	event.set_object_sequence_position(1, -119.0, 0.0, -1800.0)
	event.fade_in_screen(30)
	event.set_character_active(0)
	event.rotate_object_sequence(2, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(4, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(5, 0.0, -1.5, 0.0, 30)
	event.rotate_object_sequence(6, 0.0, 1.5, 0.0, 30)
	event.rotate_object_sequence(7, 0.0, -1.5, 0.0, 30)
	helper_888ab2a3(20)
	event.set_object_sequence_motion(0, "走り")
	event.move_object_sequence(0, -232.0, 35.8, -1260.0, 30)
	helper_888ab2a3(20)
	event.set_object_handle_footstep_sound(0, 2)
	helper_888ab2a3(10)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(10)
	event.set_character_active(0)
	event.set_character_position(0, -232.0, 35.8, -1260.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_object_handle_position(1, -119.0, 0.0, -1800.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(7, 0.0, 0.0, 0.0)
	event.set_object_handle_footstep_sound(0, 0)
	event.reset_follow_camera(1, 3.14, 28.0)
end

--- Helper function.
local function helper_1f404()
	local var0: s32 = 0
	event.initialize_event()
	event.set_character_active(0, 0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_2(1, "p01_train01")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, "p01_train01", "s3601_12-m1")
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_map_part_3(3, "p01_train01", "s3601_14-m6")
	event.set_object_sequence_object(3, 3)
	event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(1, -119.0, 0.0, -1800.0)
	event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-286.2, 99.77, -1363.38)
	event.set_camera_sequence_look_at(-195.75, 74.39, -1275.17)
	event.fade_in_screen(30)
	helper_888ab2a3(60)
	event.set_character_active(0)
	event.set_object_sequence_position(0, -150.0, 35.8, -1260.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.rotate_object_sequence(2, 0.0, 0.0, 1.5707964, 30)
	event.rotate_object_sequence(3, 0.0, 0.0, 1.5707964, 30)
	var0 = event.get_sound_id(2) or var0
	event.play_sound_effect(var0, 92)
	helper_888ab2a3(15)
	event.move_object_sequence(0, -232.0, 35.8, -1260.0, 30)
	event.set_object_sequence_motion(0, "走り", 4)
	event.set_object_handle_footstep_sound(0, 6)
	wait_objects(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(10)
	event.fade_in_screen(1)
	event.set_object_handle_position(1, -119.0, 0.0, -1800.0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
	event.set_character_active(0)
	event.set_character_position(0, -232.0, 35.8, -1260.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 28.0)
	event.fade_in_screen(15)
end

--- Helper function.
local function helper_ba60(arg0: any)
	event.start_crossfade(1, 1, 60)
	event.set_camera_sequence_position(14.46, 268.16, 737.45)
	event.set_camera_sequence_look_at(-30.4, 237.84, 510.02)
	event.move_camera_sequence_eased(-72.53, 268.16, 754.61, -117.4, 237.84, 527.18, 120, 2, 0.4)
	wait_camera()
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(193)
end

--- Helper function.
local function helper_d514(se_id: s32)
	event.set_camera_sequence_position(-130.02, 67.35, -2138.26)
	event.set_camera_sequence_look_at(-120.37, 83.46, -1843.2)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.stop_sound_effect(se_id, 6)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	event.play_sound_effect(se_id, 9)
	event.play_sound_effect(se_id, 10)
	event.set_character_active(1, 40)
	event.set_character_position(40, -116.18, 50.38, -1787.14)
	event.set_character_motion(40, "ｴﾌｪｸﾄ_列車ライトピカ！！", 6)
	helper_888ab2a3(30)
	event.set_character_active(1, 38)
	event.set_character_active(1, 39)
	event.attach_object_handle_to_map_part_2(8, "p01_train01")
	event.create_effect("列車煙")
	event.set_effect_value(0, 8)
	event.set_object_sequence_motion(6, "ぶしゅー", 6)
	event.set_object_sequence_motion(7, "ぶしゅー", 6)
	event.set_object_sequence_position(6, -114.25, 13.26, -1653.54)
	event.set_object_sequence_rotation(6, 0.0, 3.04, 0.0)
	event.set_object_sequence_position(7, -126.53, 32.32, -1662.93)
	event.set_object_sequence_rotation(7, 0.0, -3.12, 0.0)
	event.play_sound_effect(se_id, 11)
	helper_888ab2a3(45)
	event.set_character_active(0, 40)
end

--- Helper function.
local function helper_dc7c(se_id: s32)
	event.set_camera_sequence_position(-326.52, 113.91, -1579.31)
	event.set_camera_sequence_look_at(-22.58, 118.56, -2134.59)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.stop_sound_effect(se_id, 10)
	event.play_sound_effect(se_id, 12)
	event.move_object_sequence(11, -200.0, 0.0, 0.0, 285)
	event.move_object_sequence(12, 200.0, 0.0, 0.0, 285)
	wait_objects(11)
	wait_objects(12)
	helper_888ab2a3(30)
end

--- Helper function.
local function helper_dfa8(se_id: s32)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
	event.set_camera_sequence_position(-333.13, 124.81, -2141.66)
	event.set_camera_sequence_look_at(-142.51, 84.44, -1891.87)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.play_sound_effect(se_id, 13)
	event.move_object_sequence_eased(10, -120.0, 0.0, -2100.0, 60, 1, 1.0)
	helper_888ab2a3(60)
end

--- Helper function.
local function helper_e270(arg0: any)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-127.04, 86.04, -2182.12)
	event.set_camera_sequence_look_at(-120.48, 84.44, -1718.57)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
	event.move_camera_sequence_eased(-126.85, 86.09, -2262.29, -120.48, 84.44, -1718.57, 20, 2, 0.4)
	event.move_object_sequence(10, -120.0, 0.0, -2100.0, 45)
	helper_888ab2a3(45)
end

--- Helper function.
local function helper_e584(arg0: any)
	event.set_camera_sequence_position(-292.76, 173.19, -1582.23)
	event.set_camera_sequence_look_at(-228.24, 151.8, -1773.02)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
	event.move_object_sequence(10, -120.0, 0.0, -3050.0, 90)
	helper_888ab2a3(90)
end

--- Helper function.
local function helper_e7cc(se_id: s32)
	event.set_camera_sequence_position(57.23, 251.57, 242.48)
	event.set_camera_sequence_look_at(21.23, 241.82, 43.83)
	event.set_character_active(1, 36)
	event.set_character_position(36, 266.91, 197.74, 696.65)
	event.set_character_rotation(36, 0.0, -3.12, 0.0)
	event.set_object_sequence_motion(4, "前を見るL", 4)
	event.move_object_sequence(10, -120.0, 0.0, -6000.0, 120)
	helper_888ab2a3(30)
	event.move_camera_sequence_angle_height_distance_eased(-2.57, 9.27, 80.0, 120, 0, 0.4)
	wait_camera()
	event.stop_sound_effect(se_id, 9)
end

--- Helper function.
local function helper_edd0()
	local var0: s32 = 0
	vm.section(function()
		event.set_save_flag(109, 1)
		event.set_save_flag(9, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(1246)
		var0 = event.load_sound_effect_file_2(1246) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.load_character(5, "event/e100/e109/e109_starbre.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(33, -251.33, 36.72, -1629.09)
		event.set_character_rotation(33, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e109/e109_vorneo.gltf", "info", 34)
		event.set_character_active(1, 34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_character_position(34, -251.33, 36.72, -1629.09)
		event.set_character_rotation(34, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e109/e109_tom.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_character_position(35, -251.33, 36.72, -1629.09)
		event.set_character_rotation(35, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e109/e109_need.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_character_position(36, -251.33, 36.72, -1629.09)
		event.set_character_rotation(36, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e200/e202/e202_train_pika.gltf", "info", 40)
		event.set_character_active(0, 40)
		event.load_character(5, "event/train/steam/steam_l.gltf", "info", 38)
		event.set_character_active(0, 38)
		event.attach_object_handle_to_character(6, 38)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, -120.0, 0.0, -1690.0)
		event.load_character(5, "event/train/steam/steam_r.gltf", "info", 39)
		event.set_character_active(0, 39)
		event.attach_object_handle_to_character(7, 39)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, -120.0, 0.0, -1690.0)
		event.attach_object_handle_to_map_part_2(10, "p01_train01")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, -120.0, 0.0, -1690.0)
		event.attach_object_handle_to_map_part_3(11, "p41_i02h01", "i02h01_41-m")
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.set_object_sequence_position(11, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_map_part_3(12, "p42_i02h01", "i02h01_42-m")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.set_object_sequence_position(12, 0.0, 0.0, 0.0)
		event.initialize_effect_manager(5)
		event.load_effect_base("列車煙")
		event.create_effect_work_buffer(5)
		event.load_message_file(0, 5, "event/e100/e109/e109b.txt")
		event.stop_music(0)
		event.play_sound_effect(var0, 6)
		event.set_object_handle_sound_bank(1, var0)
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_handle_sound_bank(3, var0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目パチ")
		event.enable_drama_skip()
		helper_ba60(var0)
		helper_c0e39287(var0)
		helper_718a1dd5(var0)
		helper_f3a279da(var0)
		helper_2a6b1824(var0)
		helper_d514(var0)
		helper_dc7c(var0)
		helper_dfa8(var0)
		helper_e270(var0)
		helper_e584(var0)
		helper_e7cc(var0)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		helper_fdefb770(var0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_music(1)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	event.stop_sound_effect(var0, 6)
	event.stop_sound_effect(var0, 9)
	event.stop_sound_effect(var0, 10)
	event.set_character_active(1, 0)
	event.clear_effect_manager()
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1ed64()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		event.initialize_event()
		set_window_mode(0, 4)
		event.open_message_window_2(0, "中に入る\n出発する")
		at = 1
		var0 = helper_7e7c045c(0, -1, 5, 256, 208, 2, 0)
		if var0 == -1 then
			set_window_mode(0, 1)
			return 0
		end
		if var0 == 1 then
			event.fade_out_screen(15)
			at = 2
			helper_888ab2a3(15)
			event.open_event_menu(19, 0)
			at = 3
			vm.wait(3)
			event.fade_in_screen(15)
			at = 4
			helper_888ab2a3(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			helper_fbd9683d(0, 1)
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_038a2e4d(15)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_4919d694

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	event.initialize_event()
	helper_4919d694()
	print("start_event--------------------------------------------\n")
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.set_character_position(0, -240.0, 35.8, 140.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 3.14, 20.0)
	else
		old_map_no = event.get_previous_map() or old_map_no
		var2 = event.get_map_type(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 10 or old_map_no == 22 or old_map_no == 121 then
				event.set_character_position(0, 0.0, 198.8, 1450.0)
				event.set_character_rotation(0, 0.0, 3.14, 0.0)
				event.reset_follow_camera(1, 3.14)
				event.fade_in_screen(30)
			else
				var3 = event.get_save_counter(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 1 then
					helper_946c0402()
					event.fade_in_screen(15)
					event.reset_follow_camera(1, 0.0)
				else
					var4 = event.get_chapter() or var4
					if var4 ~= 6 and var4 ~= 7 then
						helper_1ff90()
					else
						helper_1f404()
					end
				end
			end
		end
		event.set_character_motion(0, "立ち")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1f404

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_edd0

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		vm.wait(1)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		print("pos[0]=", vm.float(pos_x), "-----------\n")
		print("pos[1]=", vm.float(pos_y), "-----------\n")
		print("pos[2]=", vm.float(pos_z), "-----------\n")
		event.set_object_handle_position(0, pos_x, pos_y, 0.0)
		event.set_character_active(0, 122)
		event.set_character_active(0, 123)
		event.set_character_active(0, 0)
		event.set_camera_position(-345.21, 89.08, 234.02)
		event.set_camera_look_at(-238.57, 83.73, 148.63)
		at = 2
		vm.wait(2)
		at = 3
		helper_c956b4a2(32)
		event.set_character_active(1, 122)
		event.set_character_active(1, 123)
		event.set_character_active(1, 0)
		event.set_object_handle_position(0, pos_x, pos_y, -1800.0)
		event.set_object_handle_rotation(0, 0.0, 3.1415927, 0.0)
		event.reset_follow_camera(0)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				print("pos[0]=", vm.float(pos_x), "-----------\n")
				print("pos[1]=", vm.float(pos_y), "-----------\n")
				print("pos[2]=", vm.float(pos_z), "-----------\n")
			end
			if at <= 2 then
				helper_874b82cd(32)
			end
			return 0
		end
		return nil
	end)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	vm.wait(1)
	event.jump_to_map_2(-1, "m02")
	vm.wait(2)
	event.call_command(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.call_command(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(202) or flag
		if flag == 0 then
			at = 1
			helper_18d9c3c9(0, vm.f32(1.57))
			set_window_mode(0, 1)
			event.open_message_window_2(
				0,
				"これは「列車」という機械だと\nスターブルは言ってたっけ・・・<page>今はトムとボルネオさんのお家に\nなってるけど、ボクが生まれる前は\n動いてたんだって。ホントかな？"
			)
			at = 2
			helper_75684dd8(0, -1, 5, 256, 208)
			event.open_message_window_2(0, "本当にこんな大きな物が\n動くなら、見てみたいな。")
			at = 3
			helper_75684dd8(0, -1, 5, 256, 208)
			return
		end
		at = 4
		var1 = helper_1ed64()
		if var1 ~= 1 then
			return
		end
		event.set_save_counter(1, 1)
		var2 = event.get_chapter() or var2
		var3 = event.get_triggered_event_data_2(3) or var3
		if var3 <= 1 then
			if var2 ~= 6 and var2 ~= 7 then
				at = 5
				helper_cf15df04()
				event.stop_music(0)
				at = 6
				vm.wait(6)
				event.jump_to_map_2(-1, "s08")
			else
				at = 7
				helper_cf15df04()
				event.stop_music(0)
				at = 8
				vm.wait(8)
				event.jump_to_map_2(-1, "s37")
			end
			at = 9
			vm.wait(9)
		elseif var2 ~= 6 and var2 ~= 7 then
			at = 10
			helper_cce8673f(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			at = 11
			helper_e72cbda6()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_fbd9683d(0, 1)
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			if at <= 2 then
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 4 then
				var1 = received[1] :: number
			end
			return 0
		end
		if at <= 11 then
			if at <= 6 then
				helper_6cc2fba1()
			end
			if at <= 9 then
				helper_84a2c453(0)
			end
			if at <= 10 then
				helper_b7fd5700()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	var0 = event.find_scene_character_slot(2) or var0
	event.set_character_active(0, var0)
	event.set_villager_ai_enabled(0, var0)
	helper_edd0()
	event.go_to_dungeon(0, -1, 1000)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_c53220da

return script
