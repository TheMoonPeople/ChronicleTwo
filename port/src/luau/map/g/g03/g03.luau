--!strict
-- map/g/g03/g03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0855dba8 = require("@lib/event/helper_0855dba8")
local helper_2348941a = require("@lib/event/helper_2348941a")
local helper_379e93c0 = require("@lib/event/helper_379e93c0")
local helper_3e566142 = require("@lib/event/helper_3e566142")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_5bdac642 = require("@lib/event/helper_5bdac642")
local helper_6be25ed2 = require("@lib/event/helper_6be25ed2")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8c87ba09 = require("@lib/event/helper_8c87ba09")
local helper_915f68a8 = require("@lib/event/helper_915f68a8")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b2a07125 = require("@lib/event/helper_b2a07125")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_ebc222ab = require("@lib/event/helper_ebc222ab")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_1be54()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(402, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_2(4203) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e402/")
		event.load_message_file(0, 5, "e402.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e402_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e402_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e402/e402_mints.gltf", "info", 32)
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
			event.load_character_motion_pack(5, "event/e400/e402/e402_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 471.25, 20.66, 1748.34)
		event.set_object_handle_rotation(0, 0.0, 2.42, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_position(1, 465.2, 21.66, 1714.07)
		event.set_object_handle_rotation(1, 0.0, 2.06, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(626.04, 342.91, 851.54, 601.54, 423.33, 982.17)
		event.add_camera_sequence_path_point(626.04, 302.51, 851.54, 601.54, 268.91, 982.17)
		event.add_camera_sequence_path_point(626.04, 292.84, 851.54, 631.34, 235.24, 1036.0)
		event.start_camera_sequence_path()
		event.move_object_sequence(0, 658.38, 0.0, 1645.68, 200, 1)
		event.move_object_sequence(1, 634.81, 0.0, 1650.64, 200, 1)
		event.fade_in_screen(30)
		helper_888ab2a3(120)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_footstep_sound(1, 14)
		wait_camera()
		event.set_camera_sequence_position(715.95, 6.25, 1348.09)
		event.set_camera_sequence_look_at(737.6, 21.29, 1394.21)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "ぼうぜん顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(0, 742.24, 0.0, 1390.21)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, 726.5, 0.0, 1393.6)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4020010)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "ぼうぜん顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～うれし目")
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 698.97, -14.0, 868.0, 180)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_0382f327(4020015, 40)
		event.move_camera_sequence_angle_height_distance_eased(0.07, 6.33, 54.89, 40, 0, 1.0)
		wait_objects(0)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(0, "はしゃぐ", 2)
		event.queue_object_sequence_next_motion(0, "はしゃぐL", 4)
		helper_4116e6bb(4020020)
		event.set_camera_sequence_position(713.67, 19.27, 1363.81)
		event.set_camera_sequence_look_at(727.45, 21.29, 1389.89)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "うれし顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(4020030)
		event.set_camera_sequence_position(677.49, 2.27, 847.33)
		event.set_camera_sequence_look_at(696.2, 6.92, 872.39)
		event.stop_sound_effect(var0, 0)
		event.play_sound_effect(var0, 1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "うれし顔")
		event.set_object_handle_texture_animation(0, 1, "うれし目パチ")
		event.set_object_sequence_motion(0, "うん！", 6)
		event.queue_object_sequence_next_motion(0, "うん！L", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(4020040)
		event.set_camera_sequence_position(713.67, 19.27, 1363.81)
		event.set_camera_sequence_look_at(727.45, 21.29, 1389.89)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4020050)
		event.set_camera_sequence_position(758.44, 28.22, 1458.62)
		event.set_camera_sequence_look_at(743.05, 21.29, 1388.25)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "手をふる", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, 716.1, 0.0, 1297.83, 90)
		event.open_voice_stream_wave(1, 4020055)
		helper_9cbdc640(1)
		wait_objects(1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_voice_stream(1)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_object_sequence_motion(1, "はっ？！", 6)
		event.queue_object_sequence_next_motion(1, "はっ？！Ｌ", 4)
		helper_888ab2a3(40)
		event.close_voice_stream(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4020060)
		event.set_camera_sequence_follow_object(0, 4.0, 22.0, 0.0, -2.2, 0.5, 50.0)
		event.set_object_sequence_position(0, 561.8, -14.0, 1018.56)
		event.set_object_sequence_rotation(0, 0.0, 0.48, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "指差し", 6)
		event.queue_object_sequence_next_motion(1, "指差しＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4020070)
		wait_objects(1)
		event.fade_out_music(30)
		event.set_object_handle_footstep_sound(0, -1)
		event.set_object_handle_footstep_sound(1, -1)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.delay_object_sequence_position_track(0, 60)
		event.move_object_sequence(0, 1065.83, 0.0, 1080.26, 230, 1)
		event.delay_object_sequence_rotation_track(0, 60)
		event.rotate_object_sequence(0, 0.0, 1.44, 0.0, 10)
		event.delay_object_sequence_motion_track(0, 59)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 230)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(1, 60)
		event.move_object_sequence(1, 903.05, 0.0, 1267.1, 180)
		event.delay_object_sequence_rotation_track(1, 60)
		event.rotate_object_sequence(1, 0.0, 2.06, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 180)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_camera_sequence_angle_track(60)
		event.move_camera_sequence_angle_height_distance_eased(0.76, -1.0, 32.0, 30, 0, 1.0)
		helper_0382f327(4020080, 200)
		event.release_camera_sequence_follow_object()
		event.move_camera_sequence_eased(898.96, 88.81, 1079.93, 876.98, 128.35, 1056.64, 360, 1, 1.0)
		helper_0382f327(4020090, 160)
		helper_0382f327(4020100, 120)
		helper_0382f327(4020110, 240)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(22)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.clear_camera_sequence()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.load_message_file(0, -1)
	event.set_save_data_value(0, 6)
	event.stop_all_sounds()
	event.set_sound_reverb_enabled(0)
	event.show_chapter_title(4)
	vm.wait(23)
	event.set_sound_reverb_enabled(1)
	event.load_map_sounds(4000)
	event.load_music(3)
	event.play_music(0)
	event.set_character_active(0)
	event.set_character_motion(0, "立ち")
	event.set_character_position(0, 1333.8, 0.0, 1013.9)
	event.set_character_rotation(0, 0.0, 1.02, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1a648()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + var2)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, var3, var4, var5, 30, 1)
	event.turn_object_sequence_toward(0, var3, var4, var5, 10)
	event.set_object_sequence_motion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.set_camera_look_at(var0, var1, var2)
		var6 = var6 + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(
		0,
		"さっきの鳴き声は、なんだったんだろう？\n先にあの洞窟から行ってみよう。"
	)
	show_message(0, -1, 5, 256, 208)
end

--- Helper function.
local function helper_19ba8()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『潮騒の洞窟』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(1800.16, 21.11, -758.98)
			event.set_camera_sequence_look_at(1958.18, 16.39, -784.17)
			event.set_object_sequence_motion(0, "走り", 4)
			event.set_object_sequence_position(0, 1899.56, -14.0, -773.11)
			event.set_object_sequence_rotation(0, 0.0, 1.73, 0.0)
			event.move_object_sequence(0, 2107.33, -14.0, -805.09, 40)
			at = 2
			helper_888ab2a3(10)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(-1.39)) * 30.0) + var1)
			var5 = var2
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(-1.39)) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(10)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_185f8()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『パウの家』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(1635.73, 32.56, 1292.96)
			event.set_camera_sequence_look_at(1754.78, 30.0, 1358.67)
			event.set_object_sequence_position(0, 1782.12, 0.0, 1373.78)
			event.set_object_sequence_rotation(0, 0.0, 1.0, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 50)
			event.add_object_sequence_path_point(0, 1782.12, 0.0, 1373.78)
			event.add_object_sequence_path_point(0, 1825.81, 0.0, 1397.9)
			event.add_object_sequence_path_point(0, 1906.73, 0.0, 1437.54)
			event.add_object_sequence_path_point(0, 1986.2, 0.0, 1465.28)
			event.start_object_sequence_path(0)
			at = 2
			helper_888ab2a3(20)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(-2.15)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(-2.15)) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(20)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_1765c()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『ベニーティオ停車場』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(-454.66, 376.79, 2105.55)
			event.set_camera_sequence_look_at(-706.43, 390.04, 2258.31)
			event.set_object_sequence_position(0, -667.76, 328.93, 2241.58)
			event.set_object_sequence_rotation(0, 0.0, -1.25, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1, 1)
			event.move_object_sequence(0, -838.07, 378.91, 2297.28, 50)
			at = 2
			helper_888ab2a3(20)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(1.88)) * 30.0) + var1)
			var5 = 326.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(1.88)) * 30.0) + var3)
			event.move_object_sequence(0, var4, var5, var6, 30, 1)
			event.turn_object_sequence_toward(0, var4, var5, var6, 10)
			event.set_object_sequence_motion(0, "歩き")
			var7 = 0
			while var7 < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				var2 = vm.f32(var2 + 30.0)
				event.set_camera_look_at(var1, var2, var3)
				var7 = var7 + 1
				at = 4
				vm.wait(4)
			end
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(20)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_1f100()
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_save_flag(404, 1)
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e400/e404/")
		event.load_message_file(0, 5, "e404.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e404_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e404_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e404_shigu.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e404/e404_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e400/e404/e404_monica.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 1580.54, 0.0, 1092.15)
		event.set_object_handle_rotation(0, 0.0, -2.4, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 1501.84, 0.0, 1069.09)
		event.set_object_handle_rotation(1, 0.0, -2.64, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 1891.0, -14.0, -716.0)
		event.set_object_handle_rotation(2, 0.0, 2.16, 0.0)
		event.move_object_sequence(0, 1424.62, 0.0, 938.48, 46)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 46)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, 1401.25, 0.0, 947.01, 36)
		event.set_object_sequence_motion(1, "走り", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 36)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, -0.96, 0.0, 8)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(846.73, 268.48, 883.94)
		event.set_camera_sequence_look_at(1289.42, 146.71, 951.29)
		event.fade_in_screen(30)
		wait_objects(0)
		wait_objects(1)
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "指さす", 2)
		event.queue_object_sequence_next_motion(0, "指さすL", 6)
		event.delay_object_sequence_rotation_track(1, 4)
		event.rotate_object_sequence(1, 0.0, 2.2, 0.0, 10)
		event.move_camera_sequence_eased(1059.22, 268.48, 1339.51, 1289.42, 146.71, 951.29, 30, 0, 1.0)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.delay_object_sequence_motion_track(2, 90)
		event.set_object_sequence_motion(2, "立ち")
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 90)
		event.add_object_sequence_path_point(2, 1787.63, -14.0, -561.29)
		event.add_object_sequence_path_point(2, 1891.0, -14.0, -716.0)
		event.add_object_sequence_path_point(2, 2049.12, -14.0, -873.59)
		event.add_object_sequence_path_point(2, 2149.2, -14.0, -954.9)
		event.add_object_sequence_path_point(2, 2250.94, -14.0, -1018.67)
		event.start_object_sequence_path(2)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4040350)
		wait_camera()
		event.set_camera_sequence_position(1404.09, 22.36, 896.46)
		event.set_camera_sequence_look_at(1422.53, 17.33, 974.51)
		event.set_object_sequence_rotation(0, 0.0, 2.8, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(4040360)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4040370)
		event.move_object_sequence(0, 1530.85, 0.0, 826.72, 60)
		event.set_object_sequence_motion(0, "走り")
		helper_888ab2a3(10)
		event.move_object_sequence(1, 1507.06, 0.0, 850.62, 70)
		event.set_object_sequence_motion(1, "走り")
		helper_888ab2a3(20)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.load_map_sounds(4000)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(3)
	event.play_music(0)
	event.set_character_active(0)
	event.set_character_motion(0, "立ち")
	event.set_character_position(0, 1733.3, 0.0, -301.5)
	event.set_character_rotation(0, 0.0, 2.76, 0.0)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_3e566142

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local old_sub_map_no: s32 = 0
	local var5: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_3e566142()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			helper_9dafbc83(vm.f32(1832.4), vm.f32(-5.2), vm.f32(-406.6), vm.f32(-1.16))
			event.reset_follow_camera(1, 0.0, 10.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type(old_map_no) or var2
			print("old_map = ", old_map_no, "\n")
			print("old_map_type = ", var2, "\n")
			if var2 ~= -1 then
				if var2 == 7 or var2 == 8 or old_map_no == 84 then
					at = 1
					helper_2348941a()
				else
					var3 = 0
					if old_map_no == 82 then
						helper_9dafbc83(-140.0, 165.0, 1865.0, vm.f32(2.28))
						event.reset_follow_camera(1, 0.0, 10.0)
						event.fade_in_screen(30)
						var3 = 1
					end
					if old_map_no == 75 then
						at = 2
						helper_379e93c0()
						var3 = 1
					end
					old_sub_map_no = event.get_previous_submap() or old_sub_map_no
					var5 = event.get_map_type(old_sub_map_no) or var5
					if var3 == 0 and not (old_map_no == 2 and var5 == 2) then
						flag = event.get_save_flag(402) or flag
						flag_2 = event.get_save_flag(360) or flag_2
						if flag == 0 and flag_2 == 1 then
							at = 3
							helper_1be54()
						else
							at = 4
							helper_915f68a8()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
				else
					at = 5
					helper_915f68a8()
				end
			end
		end
		at = 6
		helper_5bdac642(1)
		return
	end, function(received: { any })
		if at <= 6 then
			if at <= 1 then
				var3 = 0
				helper_43f02c95(-140.0, 165.0, 1865.0, vm.f32(2.28))
				var3 = 1
				helper_0855dba8()
			end
			if at <= 2 then
				var3 = 1
				at = 3
				helper_1be54()
				return vm.continue_with(function()
					at = 6
					helper_5bdac642(1)
					return
				end)
			end
			if at <= 3 then
				helper_b2a07125()
			end
			if at <= 4 then
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				helper_b2a07125()
			end
			if at <= 5 then
				helper_ebc222ab(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_915f68a8

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var7: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	flag = event.get_save_flag(404) or flag
	if flag == 0 then
		helper_1a648()
	elseif helper_19ba8() ~= 0 then
		event.set_dungeon_stage_id(3)
		event.open_event_menu(3, 3)
		vm.wait(3)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			var2 = out2 or var2
			var3 = out3 or var3
		end
		if var3 == 0 then
			helper_2348941a()
			return
		end
		if var3 == 20 then
			flag_2 = event.get_save_flag(438) or flag_2
			flag_3 = event.get_save_flag(444) or flag_3
			if flag_2 == 1 and flag_3 == 0 then
				event.go_to_dungeon(3, var3, 1010)
			else
				var2 = 3
				var3 = 20
				var7 = event.get_dungeon_floor_info(var2, var3, 7) or var7
				var7 = vm.i32(var7 + 1)
				event.set_dungeon_floor_info(var2, var3, 7, var7)
				event.jump_to_map_3(-1, "d04b01", 100)
			end
		else
			flag_4 = event.get_save_flag(406) or flag_4
			flag_5 = event.get_save_flag(424) or flag_5
			if var3 == 2 and flag_4 == 0 or var3 == 17 and flag_5 == 0 or var3 == 19 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(3, var3, 1010)
		end
	end
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local flag: s32 = 0
	if helper_185f8() ~= 0 then
		flag = event.get_save_flag(404) or flag
		if flag == 0 then
			event.skip_next_music_load()
		end
		event.jump_to_map_2(-1, "s27")
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	if helper_1765c() ~= 0 then
		event.jump_to_map_2(-1, "s09")
	end
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_8c87ba09(vm.f32(-136.7), 165.0, vm.f32(1866.8), 0.0)
	event.jump_to_map_2(-1, "f03")
	vm.wait(2)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_5bdac642(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_3e566142()
	helper_1f100()
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_3e566142()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, 1425.7, 0.0, 1034.8)
	event.set_character_rotation(0, 0.0, -2.37, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local var0: s32 = 0
	helper_3e566142()
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, -140.0, 165.0, 1800.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	var0 = helper_6be25ed2()
	if var0 == 0 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]ジオラマの条件を満たして、ルナ研の\n   センターラボを復活させると、物語が\n   進行します。"
		)
		show_message(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
	end
	helper_5bdac642(1)
end

--- Event 14020, which map data, a script or the engine runs by number.
function script.event_14020()
	helper_3e566142()
	helper_1be54()
end

return script
