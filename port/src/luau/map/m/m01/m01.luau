--!strict
-- map/m/m01/m01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_09ed743f = require("@lib/event/helper_09ed743f")
local helper_0c59fe05 = require("@lib/event/helper_0c59fe05")
local helper_10625ea5 = require("@lib/event/helper_10625ea5")
local helper_14bffa77 = require("@lib/event/helper_14bffa77")
local helper_18d9c3c9 = require("@lib/event/helper_18d9c3c9")
local helper_18e90011 = require("@lib/event/helper_18e90011")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1f6d3562 = require("@lib/event/helper_1f6d3562")
local helper_207da968 = require("@lib/event/helper_207da968")
local helper_257748e5 = require("@lib/event/helper_257748e5")
local helper_264d3c04 = require("@lib/event/helper_264d3c04")
local helper_3488ae95 = require("@lib/event/helper_3488ae95")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_42250fcf = require("@lib/event/helper_42250fcf")
local helper_464b0610 = require("@lib/event/helper_464b0610")
local helper_4d7225fb = require("@lib/event/helper_4d7225fb")
local helper_4f05654d = require("@lib/event/helper_4f05654d")
local helper_52d29060 = require("@lib/event/helper_52d29060")
local helper_5cfb3070 = require("@lib/event/helper_5cfb3070")
local helper_5e014937 = require("@lib/event/helper_5e014937")
local helper_6082cadd = require("@lib/event/helper_6082cadd")
local helper_684f356d = require("@lib/event/helper_684f356d")
local helper_6b43f254 = require("@lib/event/helper_6b43f254")
local helper_76266e1e = require("@lib/event/helper_76266e1e")
local helper_7cc9b820 = require("@lib/event/helper_7cc9b820")
local helper_7d93c852 = require("@lib/event/helper_7d93c852")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8a39abce = require("@lib/event/helper_8a39abce")
local helper_8f87ca2e = require("@lib/event/helper_8f87ca2e")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_9959bbdb = require("@lib/event/helper_9959bbdb")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a3a848ae = require("@lib/event/helper_a3a848ae")
local helper_a8a46966 = require("@lib/event/helper_a8a46966")
local helper_a981053a = require("@lib/event/helper_a981053a")
local helper_aae85aa8 = require("@lib/event/helper_aae85aa8")
local helper_b221607a = require("@lib/event/helper_b221607a")
local helper_b64fcf51 = require("@lib/event/helper_b64fcf51")
local helper_b8d9d9d0 = require("@lib/event/helper_b8d9d9d0")
local helper_ba4251cf = require("@lib/event/helper_ba4251cf")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bd7a278c = require("@lib/event/helper_bd7a278c")
local helper_c319e890 = require("@lib/event/helper_c319e890")
local helper_c4aeb2aa = require("@lib/event/helper_c4aeb2aa")
local helper_c79dc3a2 = require("@lib/event/helper_c79dc3a2")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_e6998a9e = require("@lib/event/helper_e6998a9e")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_f266fe03 = require("@lib/event/helper_f266fe03")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")
local helper_f9c60bca = require("@lib/event/helper_f9c60bca")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3ca30()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_save_flag(800, 1)
		event.set_camera_position(1863.34, -57.23, -1093.45)
		event.set_camera_look_at(1673.6, -34.95, -1596.24)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(193)
		event.play_music(0)
		var0 = event.load_sound_effect_file_2(1261) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e800/e800/")
		event.load_message_file(0, 5, "e800.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e800_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.load_character(5, "e800_need.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(2, 35)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		block = event.load_event_image_4(5, "e800.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e80001", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e80002", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(4, 1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		event.set_object_handle_position(0, 1471.93, -90.0, -1214.38)
		event.set_object_handle_rotation(0, 0.0, 2.95, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, 1693.4, -48.85, -1747.04)
		event.set_object_handle_rotation(2, 0.0, -3.09, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1863.34, -57.23, -1093.45)
		event.set_camera_sequence_look_at(1673.6, -34.95, -1596.24)
		event.set_character_active(0)
		event.move_camera_sequence(1419.0, -57.23, -1121.53, 1673.6, -34.95, -1596.24, 300)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		helper_888ab2a3(180)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, 1616.06, -90.0, -1552.76, 120, 1)
		wait_camera()
		event.set_camera_sequence_position(1819.9, 101.8, -1573.08)
		event.set_camera_sequence_look_at(1698.78, -1.69, -1732.94)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 1607.13, -77.8, -1633.37)
		event.set_object_sequence_rotation(0, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 1657.71, -48.85, -1704.67, 60, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "振り向き", 6)
		event.rotate_object_sequence(2, 0.0, -0.33, 0.0, 20)
		event.delay_object_sequence_motion_track(2, 20)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		wait_objects(0)
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000010)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(8000020)
		event.set_camera_sequence_position(1680.47, -37.85, -1706.19)
		event.set_camera_sequence_look_at(1694.26, -26.32, -1748.64)
		event.set_object_handle_frame_visible(2, "te_l", 0)
		event.set_object_handle_frame_visible(2, "te_r", 0)
		event.set_object_handle_frame_visible(2, "te_gl--v0", 1)
		event.set_object_handle_frame_visible(2, "te_gr--v0", 1)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "しんけん顔")
		event.set_object_sequence_texture_animation(2, 1, "しんけん目パチ")
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_object_sequence_motion(2, "エキサイト", 6)
		event.queue_object_sequence_next_motion(2, "エキサイト戻り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000030)
		wait_objects(2)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000035)
		event.set_camera_sequence_position(1819.9, 101.8, -1573.08)
		event.set_camera_sequence_look_at(1698.78, -1.69, -1732.94)
		event.set_object_handle_frame_visible(2, "te_l", 1)
		event.set_object_handle_frame_visible(2, "te_r", 1)
		event.set_object_handle_frame_visible(2, "te_gl--v0", 0)
		event.set_object_handle_frame_visible(2, "te_gr--v0", 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000040)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(8000050)
		event.set_scene_status_flags(1, 0, 256, 0)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000060)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000065)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(8000070)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000080)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000090)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000100)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(0, "がっつ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(8000110)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000120)
		event.set_object_sequence_color(4, 128, 128, 128, 0, 30)
		event.set_camera_sequence_position(1704.99, -31.99, -1684.63)
		event.set_camera_sequence_look_at(1684.93, -26.32, -1741.26)
		event.set_object_sequence_position(0, 1678.13, -48.85, -1729.46)
		event.set_object_sequence_rotation(0, 0.0, 2.95, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_mouth_texture_animations(2, "通常口パク")
		helper_4116e6bb(8000130)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(35)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 1678.13, -48.85, -1729.46)
	event.set_character_rotation(0, 0.0, 2.95, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_3b974()
	event.initialize_event()
	event.set_character_active(0, 0)
	event.set_character_active(0, 122)
	event.set_character_active(0, 123)
	event.set_event_projection(524.9)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-2805.19, 378.19, -1591.92)
	event.set_camera_sequence_look_at(-2901.57, 398.3, -1620.79)
	helper_888ab2a3(30)
	event.move_camera_sequence(-2805.19, 378.19, -1591.92, -2902.6, 398.3, -1571.73, 300)
	vm.wait(2)
	helper_c956b4a2(32)
	event.set_character_active(1, 0)
end

--- Event 248, which map data, a script or the engine runs by number.
local function event_248()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "You can't enter here in the demo version.")
	show_message(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 1)
end

--- Helper function.
local function helper_424a8()
	local var0: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local at: number = 0
	return vm.guard(function()
		print("00000000000000000000000000\n")
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		event.set_message_window_mode(0, 5)
		var0 = event.get_menu_value_2(1) or var0
		if var0 == 1 then
			event.open_message_window_2(0, "『釣り大会会場前』に移動しますか？")
		else
			event.open_message_window_2(0, "『ギョレース会場前』に移動しますか？")
		end
		print("11111111111111111111111111111111\n")
		at = 1
		var1 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		if var1 == 0 then
			event.set_camera_sequence_position(1332.56, 67.86, 1494.1)
			event.set_camera_sequence_look_at(1508.0, 12.6, 1425.04)
			event.move_camera_sequence_eased(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			do
				local out1, out2, _ = event.get_character_position(0)
				var2 = out1 or var2
				var3 = out2 or var3
			end
			event.set_object_sequence_position(0, var2, var3, 1415.0)
			event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
			event.move_object_sequence(0, 1800.0, var3, 1415.0, 90)
			at = 2
			helper_888ab2a3(15)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		end
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 15)
		at = 4
		helper_888ab2a3(15)
		do
			local _, out2, out3 = event.get_character_position(0)
			var6 = out2 or var6
			var7 = out3 or var7
		end
		event.move_object_sequence(0, 1480.0, var6, var7, 45)
		at = 5
		helper_888ab2a3(45)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(15)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 5 then
			if at <= 4 then
				helper_038a2e4d(45)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_216ec()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = event.get_quest_request_status(0, 8) or var0
	if var0 == 1 then
		var1 = event.get_save_counter(12) or var1
		if 0 < var1 then
			if var1 == 1 then
				event.set_save_counter(12, 2)
			end
			helper_18d9c3c9(0, vm.f32(-1.57))
			set_window_mode(0, 1)
			event.open_message_window_2(
				0,
				"ドアに手紙がはさんである。<page>「今日のパーティーは、とろりんチーズが\n　いまいちとろりんとしないので、中止に\n　します。　　　　　　　　　　　ポーク」"
			)
			show_message(0, -1, 5, 256, 208)
			event.request_town_edit_event(1)
			vm.wait(3)
		end
	end
end

--- Helper function.
local function helper_40bc4()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		var0 = helper_ed4dc120(5, 160)
		if var0 == 0 then
			event.fade_out_screen(30)
			at = 2
			helper_888ab2a3(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_403e8()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		vm.wait(1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『地下水道入り口』に移動しますか？")
		at = 2
		var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
		event.set_message_window_mode(0, 1)
		if var0 == 0 then
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				var0 = helper_f8bbcc57(0, -1, 8, 0, 0, 2, 1)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Event 530, which map data, a script or the engine runs by number.
local function event_530()
	event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	helper_a3a848ae()
	event.set_camera_position(345.12, 84.74, -31.95)
	event.set_camera_look_at(351.66, 70.52, 137.18)
	event.set_character_position(0, 350.13, 52.0, 148.02)
	event.set_character_rotation(0, 0.0, -3.12, 0.0)
	event.skip_next_music_play()
	vm.wait(2)
	event.go_to_interior_map(-1, "i01h01", 500, 1)
	vm.wait(3)
end

--- Helper function.
local function helper_3397c(chara_no: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: any = 0
	local var16: s32 = 0
	local active_chr_no: s32 = 0
	local var18: any = 0
	local at: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 1)
		var2 = event.get_chapter() or var2
		var3 = event.get_triggered_event_data_2(14) or var3
		event.get_current_map()
		now_sub_map_no = event.get_current_submap() or now_sub_map_no
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, chara_no)
		if var3 == 3 then
			at = 1
			helper_4d7225fb(chara_no, arg1)
		end
		if var3 == 5 then
			at = 2
			helper_14bffa77(chara_no, arg1)
		end
		if var3 == 4 then
			flag = event.get_save_flag(104) or flag
			if flag == 0 then
				at = 3
				helper_52d29060()
			else
				at = 4
				helper_bd7a278c(chara_no, arg1)
			end
		end
		if var3 == 7 then
			at = 5
			helper_b221607a(chara_no, arg1)
		end
		if var3 == 8 then
			at = 6
			helper_aae85aa8(chara_no, arg1)
		end
		if var3 == 10 then
			at = 7
			helper_a8a46966(chara_no, arg1)
		end
		if var3 == 11 then
			at = 8
			helper_b64fcf51(chara_no, arg1)
		end
		if var3 == 12 then
			var7 = event.get_quest_request_status(0, 0) or var7
			var8 = event.get_quest_request_status(0, 8) or var8
			if var7 == 2 and var8 ~= 2 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 9
				var9 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var9 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var9 == 1 then
					at = 10
					helper_8f87ca2e(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			if now_sub_map_no == 28 then
				at = 11
				helper_52d29060()
			else
				at = 12
				helper_8f87ca2e(chara_no, arg1)
			end
		end
		if var3 == 14 then
			at = 13
			helper_264d3c04(chara_no, arg1)
		end
		if var3 == 15 then
			var10 = event.get_quest_request_status(0, 0) or var10
			var11 = event.get_quest_request_status(0, 10) or var11
			if var10 == 2 and var11 ~= 2 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 14
				var12 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var12 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var12 == 1 then
					at = 15
					helper_257748e5(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			if now_sub_map_no == 30 then
				at = 16
				helper_52d29060()
			else
				at = 17
				helper_257748e5(chara_no, arg1)
			end
		end
		if var3 == 16 then
			at = 18
			helper_f9c60bca(chara_no, arg1)
		end
		if var3 == 17 then
			at = 19
			helper_9959bbdb(chara_no, arg1)
		end
		if var3 == 18 then
			var13 = event.get_quest_request_status(0, 0) or var13
			var14 = event.get_quest_request_status(0, 13) or var14
			if var13 == 2 and var14 ~= 2 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				at = 20
				var15 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var15 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var15 == 1 then
					at = 21
					helper_7d93c852(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			if now_sub_map_no == 33 then
				at = 22
				helper_52d29060()
			else
				at = 23
				helper_7d93c852(chara_no, arg1)
			end
		end
		if var3 == 19 then
			at = 24
			helper_207da968(chara_no, arg1)
		end
		if var3 == 20 then
			at = 25
			helper_76266e1e(chara_no, arg1)
		end
		if var3 == 21 then
			at = 26
			helper_1f6d3562(chara_no, arg1)
		end
		if var3 == 23 then
			at = 27
			helper_09ed743f(chara_no, arg1)
		end
		if var3 == 24 then
			at = 28
			helper_4f05654d(chara_no, arg1)
		end
		if var3 == 25 then
			at = 29
			helper_18e90011(chara_no, arg1)
		end
		if var3 == 33 then
			var16 = event.get_quest_request_status(0, 8) or var16
			active_chr_no = event.get_playable_character() or active_chr_no
			if var16 == 1 and active_chr_no == 0 then
				event.set_character_motion(arg1, "立ち")
				event.open_message_window_2(0, "買い物させて\nこんにちは")
				at = 30
				var18 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var18 < 0 then
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
				if var18 == 1 then
					at = 31
					helper_8a39abce(chara_no, arg1)
					event.set_villager_ai_enabled(1, chara_no)
					return
				end
			end
			at = 32
			helper_52d29060()
		end
		if var3 == 1 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(
					0,
					"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
				)
			else
				event.open_message_window_2(
					0,
					"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
				)
			end
			at = 33
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 2 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
				)
			end
			at = 34
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 6 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。"
				)
			end
			at = 35
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 13 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(
					0,
					"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
				)
			else
				event.open_message_window_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
			end
			at = 36
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		if var3 == 22 then
			event.apply_message_window_preset(0, 0)
			if var2 ~= 8 then
				event.open_message_window_2(
					0,
					"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
				)
			else
				event.open_message_window_2(
					0,
					"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
				)
			end
			at = 37
			helper_1c04a0eb(chara_no, -1, 0, 0)
		end
		event.set_villager_ai_enabled(1, chara_no)
		return
	end, function(received: { any })
		if at <= 9 then
			if at == 9 then
				var9 = received[1] :: number
			end
			if at <= 1 then
				helper_6b43f254(chara_no, arg1)
			end
			if at <= 2 then
				helper_c4aeb2aa()
			end
			if at <= 3 then
				helper_0c59fe05(chara_no, arg1)
			end
			if at <= 4 then
				helper_7cc9b820(chara_no, arg1)
			end
			if at <= 5 then
				helper_5e014937(chara_no, arg1)
			end
			if at <= 6 then
				helper_10625ea5(chara_no, arg1)
			end
			if at <= 7 then
				helper_5cfb3070(chara_no, arg1)
			end
			if at <= 8 then
				var9 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 10 then
			return 0
		end
		if at <= 14 then
			if at == 14 then
				var12 = received[1] :: number
			end
			if at <= 11 then
				helper_7cc9b820(chara_no, arg1)
			end
			if at <= 12 then
				helper_464b0610(chara_no, arg1)
			end
			if at <= 13 then
				var12 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 15 then
			return 0
		end
		if at <= 20 then
			if at == 20 then
				var15 = received[1] :: number
			end
			if at <= 16 then
				helper_10625ea5(chara_no, arg1)
			end
			if at <= 17 then
				helper_10625ea5(chara_no, arg1)
			end
			if at <= 18 then
				helper_c79dc3a2(chara_no, arg1)
			end
			if at <= 19 then
				var15 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 21 then
			return 0
		end
		if at <= 30 then
			if at == 30 then
				var18 = received[1] :: number
			end
			if at <= 22 then
				helper_ba4251cf(chara_no, arg1)
			end
			if at <= 23 then
				helper_0c59fe05(chara_no, arg1)
			end
			if at <= 24 then
				helper_0c59fe05(chara_no, arg1)
			end
			if at <= 25 then
				helper_c319e890(chara_no, arg1)
			end
			if at <= 26 then
				helper_f266fe03(chara_no, arg1)
			end
			if at <= 27 then
				helper_6b43f254(chara_no, arg1)
			end
			if at <= 28 then
				helper_0c59fe05(chara_no, arg1)
			end
			if at <= 29 then
				var18 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if at <= 31 then
			return 0
		end
		if at <= 37 then
			if at <= 32 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 33 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 34 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 35 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			if at <= 36 then
				helper_684f356d(chara_no, -1, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_35d2c()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(14) or var0
		var1 = event.get_triggered_event_data_2(13) or var1
		player_chara = event.get_player_character_slot() or player_chara
		if var0 <= 34 then
			at = 1
			helper_3397c(var1, player_chara)
		else
			at = 2
			helper_42250fcf()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_3488ae95()
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
script.event_99 = helper_b8d9d9d0

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var8: s32 = 0
	local old_map_no: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local flag_6: s32 = 0
	local get_old_interior_map_no: s32 = 0
	helper_b8d9d9d0()
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		flag = event.get_save_flag(736) or flag
		flag_2 = event.get_save_flag(800) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.fade_out_screen(0)
			helper_3ca30()
			event.set_save_data_value(0, 10)
			event.stop_all_sounds()
			event.set_sound_reverb_enabled(0)
			event.show_chapter_title(8)
			vm.wait(2)
			event.set_sound_reverb_enabled(1)
			event.load_map_sounds(1000)
			var3 = event.get_default_music_number(10) or var3
			event.load_music(var3)
			event.play_music(0)
			event.set_music_volume_follows_time_of_day(1)
			event.set_character_position(0, 1640.0, -48.8, -1700.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(30)
			return
		end
		var4 = event.get_save_counter(4) or var4
		if var4 == 0 then
			event.set_character_position(0, 560.0, 4.1, 120.0)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
		end
		if var4 == 1 then
			event.set_character_position(0, 2095.0, 0.0, 2100.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
		end
		if var4 == 2 then
			event.set_character_position(0, -4260.0, 350.0, 2810.0)
			event.set_character_rotation(0, 0.0, 2.86, 0.0)
		end
		if var4 == 3 then
			event.set_character_position(0, -3770.0, 359.4, -1640.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0, 20.0)
	else
		flag_3 = event.get_save_flag(105) or flag_3
		flag_4 = event.get_save_flag(109) or flag_4
		flag_5 = event.get_save_flag(56) or flag_5
		if flag_3 ~= 0 and flag_4 == 0 and flag_5 == 0 then
			event.get_active_music_number(var8)
			event.get_music_master_volume()
			if var8 ~= 10 then
				event.fade_out_screen(0)
				event.load_map_sounds(1000)
				var8 = event.get_default_music_number(10) or var8
				event.stop_music(0)
				helper_888ab2a3(4)
				event.load_music(var8)
				event.play_music(0)
				event.set_save_flag(56, 1)
				event.set_music_volume_follows_time_of_day(1)
				event.fade_in_screen(30)
			end
		end
		old_map_no = event.get_previous_map() or old_map_no
		var11 = event.get_map_type(old_map_no) or var11
		if var11 ~= -1 then
			if var11 == 7 or var11 == 8 then
				helper_9dafbc83(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.reset_follow_camera(1, 0.0, 10.0)
			else
				var12 = 1
				flag_6 = event.get_save_flag(40) or flag_6
				if flag_6 == 1 then
					if old_map_no == 34 then
						var12 = 0
						event.set_character_position(0, 1645.1, -41.3, -1812.6)
						event.set_character_rotation(0, 0.0, -0.09, 0.0)
						event.reset_follow_camera(1)
					end
					if old_map_no == 22 then
						var12 = 0
						helper_6082cadd()
					end
				end
				get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
					var12 = 0
				elseif old_map_no == 121 then
					var12 = 0
					event.set_character_position(0, 1450.0, 0.0, 1420.0)
					event.set_character_rotation(0, 0.0, -1.57, 0.0)
					event.reset_follow_camera(1, 3.1415927)
				end
				if var12 ~= 0 then
					helper_e6998a9e()
				end
			end
		end
	end
	event.set_save_flag(40, 0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_3b974

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(3)
	event.go_to_interior_map(-1, "i01h01", 100, 1)
	vm.wait(4)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local at: number = 0
	return vm.guard(function()
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
		at = 1
		if helper_424a8() ~= 0 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			event.fade_out_screen(0)
			at = 2
			vm.wait(2)
			event.jump_to_map_2(-1, "s45")
			return
		end
		print("ccccccccccccccccccccccccccc\n")
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			end
			return 0
		end
		return nil
	end)
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.jump_to_map_2(-1, "i02h01")
	vm.wait(3)
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 211, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_211() end

--- Event 212, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_212() end

--- Event 213, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_213() end

--- Event 214, which map data, a script or the engine runs by number.
function script.event_214()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 215, which map data, a script or the engine runs by number.
function script.event_215()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 216, which map data, a script or the engine runs by number.
function script.event_216()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 217, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_217() end

--- Event 218, which map data, a script or the engine runs by number.
function script.event_218()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 219, which map data, a script or the engine runs by number.
function script.event_219()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 220, which map data, a script or the engine runs by number.
function script.event_220()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 221, which map data, a script or the engine runs by number.
function script.event_221()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end

--- Event 222, which map data, a script or the engine runs by number.
function script.event_222()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	else
		helper_216ec()
	end
end

--- Event 223, which map data, a script or the engine runs by number.
function script.event_223()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		event_248()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
	flag = event.get_save_flag(304) or flag
	flag_2 = event.get_save_flag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.skip_next_music_load()
	end
end

script.event_248 = event_248

--- Event 290, which map data, a script or the engine runs by number.
function script.event_290()
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(800) or flag
	if flag == 0 then
		return
	end
	if helper_40bc4() ~= 0 then
		event.set_dungeon_stage_id(6)
		event.open_event_menu(3, 6)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			event.fade_in_screen(30)
			return
		else
			if var3 == 37 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(6, var3, 1010)
		end
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(15) or var0
	event.set_save_counter(4, var0)
	helper_93cb8168()
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	var1 = event.get_save_counter(7) or var1
	if active_chr_no == 0 and var1 == 1 then
		event.set_save_counter(7, 2)
		event.open_message_window_2(0, "よし！急いでパッカーの所に戻らなきゃ。")
	else
		event.open_message_window_2(0, "だまって乗ったら怒られるかな？")
	end
	show_message(0, -1, 5, 256, 208)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	if helper_403e8() ~= 0 then
		event.jump_to_map_3(-1, "d01e01", 100)
	end
end

script.event_530 = event_530

--- Event 531, which map data, a script or the engine runs by number.
function script.event_531()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.set_camera_position(345.12, 84.74, -31.95)
		event.set_camera_look_at(351.66, 70.52, 137.18)
		event.set_character_position(0, 350.13, 52.0, 148.02)
		event.set_character_rotation(0, 0.0, -3.12, 0.0)
		print("ぞうにまけた---------------------\n")
		at = 1
		vm.wait(1)
		event.go_to_interior_map(-1, "i01h01", 510, 1)
		at = 2
		vm.wait(2)
		print("じゃんぷ------------------\n")
		return
	end, function(received: { any })
		if at <= 2 then
			print("じゃんぷ------------------\n")
			return 0
		end
		return nil
	end)
end

--- Event 540, which map data, a script or the engine runs by number.
function script.event_540()
	helper_a981053a()
	event.skip_villager_loading()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local var0: s32 = 0
	local var1: s32 = 0
	local chara_no: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		return
	end
	event.set_camera_position(1300.0, 50.0, 763.0)
	event.set_camera_look_at(1300.0, 30.0, 968.18)
	event.set_character_motion(0, "立ち")
	var1 = event.find_scene_character_slot(50) or var1
	chara_no = vm.i32(var1 + 1)
	event.set_villager_ai_enabled(0, chara_no)
	event.set_villager_ai_enabled(0, var1)
	event.open_message_window_2(0, "おい、この先は\n立ち入り禁止だ。")
	helper_1c04a0eb(var1, -1, 0, 0)
	event.open_message_window_2(0, "おとなしく引き返した方が\n身のためだぜ。")
	helper_1c04a0eb(chara_no, -1, 0, 0)
	event.fade_out_screen(20)
	helper_888ab2a3(20)
	event.set_character_position(0, 1302, 0, 951)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.set_villager_ai_enabled(1, chara_no)
	event.set_villager_ai_enabled(1, var1)
	event.fade_in_screen(20)
end

--- Event 560, which map data, a script or the engine runs by number.
script.event_560 = helper_b8d9d9d0

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		return
	end
	helper_35d2c()
end

--- Event 11051, which map data, a script or the engine runs by number.
script.event_11051 = event_530

--- Event 11052, which map data, a script or the engine runs by number.
function script.event_11052()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11052, 1)
	vm.wait(2)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11053, 1)
	vm.wait(2)
end

--- Event 11060, which map data, a script or the engine runs by number.
function script.event_11060()
	event.set_save_flag(103, 1)
	event.set_save_flag(106, 0)
	event.set_save_flag(107, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11060, 1)
	vm.wait(2)
end

--- Event 11091, which map data, a script or the engine runs by number.
function script.event_11091()
	helper_a981053a()
	event.skip_villager_loading()
	vm.wait(2)
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(3)
end

--- Event 18000, which map data, a script or the engine runs by number.
function script.event_18000()
	helper_3ca30()
	event.set_save_data_value(0, 10)
	event.stop_all_sounds()
	event.set_sound_reverb_enabled(0)
	event.show_chapter_title(8)
	vm.wait(2)
	event.set_sound_reverb_enabled(1)
	event.load_music(0)
	event.load_map_sounds(1000)
	event.play_music(0)
	event.set_character_position(0, 1640.0, -48.8, -1700.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

return script
