--!strict
-- map/s/s56.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_08ff853b = require("@lib/event/helper_08ff853b")
local helper_161be1ae = require("@lib/event/helper_161be1ae")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_57c93eff = require("@lib/event/helper_57c93eff")
local helper_76929aca = require("@lib/event/helper_76929aca")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_df618068 = require("@lib/event/helper_df618068")
local helper_e4e2e66b = require("@lib/event/helper_e4e2e66b")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f2c09b51 = require("@lib/event/helper_f2c09b51")
local open_message = require("@lib/event/open_message")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_message = require("@lib/event/wait_message")

--- Helper function.
local function helper_11630()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(
			0,
			"ここから過去に戻れば、クレストを助けられるはず！\n（(#)ボタンでメニューを開く）"
		)
		at = 1
		var0 = helper_c292fa16(0, -1, 5, 256, 208, var0)
		if var0 == 1 then
			return 1
		else
			return 0
		end
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[2] :: number
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_11434()
	event.initialize_event()
	event.set_save_flag(352, 1)
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.open_message_window_2(0, "Ｅ３５２　～星の砂時計を使う～")
	show_message(0, -1, 5, 0, 0)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.finish_event()
end

--- Helper function.
local function helper_2570(arg0: s32, arg1: any)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local loud: s32 = 0
	local var8: s32 = 0
	event.set_message_button_prompt(arg0, 0)
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	var5 = 0
	argc_2 = event.get_voice_stream_state(1) or argc_2
	loud = 0
	var8 = 1
	while var8 ~= 0 do
		argc_2 = argc
		argc = event.get_voice_stream_state(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.trigger_mouth_motion(2)
			if arg1 == -1 then
				var8 = 0
			end
		end
		var6 = loud
		loud = event.is_voice_stream_audible(1) or loud
		if var6 == 0 and loud == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if var6 == 1 and loud == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		vm.wait(1)
		var5 = vm.i32(var5 + 1)
		if arg1 ~= -1 then
			if arg1 <= var5 then
				var8 = 0
			end
		end
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.stop_voice_stream(1)
	event.set_message_button_prompt(arg0, 1)
end

--- Helper function.
local function helper_4560(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, arg0)
	while true do
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, arg0)
	open_message(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	helper_2570(0, arg1)
	close_message(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

--- Helper function.
local function helper_2c14(arg0: s32)
	local var1: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local loud: s32 = 0
	event.trigger_mouth_texture_animation(1)
	event.trigger_mouth_motion(0)
	var1 = 0
	var5 = 0
	argc_2 = event.get_voice_stream_state(1) or argc_2
	loud = 0
	while true do
		argc_2 = argc
		argc = event.get_voice_stream_state(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.trigger_mouth_motion(2)
			var1 = 2
		end
		var6 = loud
		loud = event.is_voice_stream_audible(1) or loud
		if var6 == 0 and loud == 1 then
			event.trigger_mouth_texture_animation(1)
		end
		if var6 == 1 and loud == 0 then
			event.trigger_mouth_texture_animation(0)
		end
		local t0: s32
		t0, var1 = helper_57c93eff(arg0, var1)
		var4 = t0
		if var4 ~= 0 then
			var5 = vm.i32(var5 + 1)
			break
		else
			vm.wait(1)
			var5 = vm.i32(var5 + 1)
		end
	end
	if var1 == 0 then
		event.trigger_mouth_motion(2)
	end
	event.reset_mouth_motions()
	event.trigger_mouth_texture_animation(0)
	event.reset_mouth_texture_animations()
	event.stop_voice_stream(1)
end

--- Helper function.
local function helper_48bc(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, arg0)
	while true do
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, arg0)
	open_message(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	helper_2c14(0)
	close_message(0)
	event.close_voice_stream(1)
end

--- Helper function.
local function helper_21800000(arg0: s32, arg1: s32)
	local var5: s32 = 0
	local var8: s32 = 0
	var5 = 0
	var8 = 1
	local _ = var8
	var8 = 0
	var5 = var5 + 1
	var8 = 0
end

--- Helper function.
local function helper_21700000(arg0: s32, arg1: s32)
	helper_f018b3c0(0, -1, 8, 0, 0)
	helper_21800000(0, arg1)
	helper_d16eef1e(0)
end

--- Helper function.
local function helper_21b00000(arg0: s32)
	local var1: s32 = 0
	local var5: s32 = 0
	var1 = 0
	var5 = 0
	var1 = 2
	do
		local _: any
		_, var1 = helper_f2c09b51(arg0, var1)
	end
	var5 = var5 + 1
	var5 = var5 + 1
end

--- Helper function.
local function helper_21a00000(arg0: s32)
	helper_f018b3c0(0, -1, 8, 0, 0)
	helper_21b00000(0)
	helper_d16eef1e(0)
end

--- Helper function.
local function helper_ee14()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(348, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		var0 = event.load_sound_effect_file_2(3829) or var0
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 or active_chr_no ~= 1 then
			event.switch_dungeon_main_character(0)
			event.set_playable_character(0)
			active_chr_no = 0
		end
		event.change_directory("event/e300/e348/")
		event.load_message_file(0, 5, "e348.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e348_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e348_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e348_lin.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_mints.gltf", "info", 10)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 9)
			event.attach_object_handle_to_character(0, 9)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 9)
			event.load_equipment_model(5, 1, 4, "info", 9)
			event.load_equipment_model(5, 1, 3, "info", 9)
			event.load_equipment_model(5, 1, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.attach_object_handle_to_character(3, 1)
		event.set_object_handle_visible(3, 0)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 1521.47, -107.28, 771.74)
		event.set_object_handle_rotation(0, 0.0, -2.88, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 1505.66, -106.53, 783.49)
		event.set_object_handle_rotation(1, 0.0, 3.04, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 1506.3, -108.37, 803.96)
		event.set_object_handle_rotation(2, 0.0, -3.12, 0.0)
		event.set_object_handle_motion(2, "歩き", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "無表情")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_texture_animation(2, 1, "半口")
		event.move_object_sequence(0, 1521.47, -107.28, 731.74, 80)
		event.move_object_sequence(1, 1505.66, -106.53, 743.49, 80)
		event.move_object_sequence(2, 1506.3, -108.37, 763.96, 80)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1478.0, -94.44, 748.45)
		event.set_camera_sequence_look_at(1526.09, -83.38, 795.48)
		event.move_camera_sequence(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
		event.fade_in_screen(30)
		at = 2
		helper_888ab2a3(80)
		event.set_camera_sequence_position(1635.22, -45.35, 898.95)
		event.set_camera_sequence_look_at(1509.85, -91.47, 744.47)
		event.move_camera_sequence_eased(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
		event.set_object_sequence_position(0, 1522.58, -104.86, 733.22)
		event.set_object_sequence_rotation(0, 0.0, -2.52, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 1508.09, -104.9, 755.07)
		event.set_object_sequence_rotation(1, 0.0, -2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 1536.72, -109.15, 777.79)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.move_object_sequence(0, 1491.96, -99.81, 672.57, 90)
		event.move_object_sequence(1, 1473.85, -100.1, 691.32, 90)
		event.move_object_sequence(2, 1493.11, -100.84, 700.12, 90)
		at = 3
		helper_4560(3480010, 120)
		at = 4
		wait_camera()
		at = 5
		helper_888ab2a3(10)
		event.set_camera_sequence_position(1459.8, -32.33, 632.79)
		event.set_camera_sequence_look_at(1494.99, -96.61, 704.05)
		event.move_camera_sequence_eased(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "上見立ち", 4)
		at = 6
		wait_camera()
		at = 7
		helper_888ab2a3(10)
		event.set_camera_sequence_position(1518.17, -76.49, 671.12)
		event.set_camera_sequence_look_at(1493.05, -78.0, 693.7)
		event.set_object_sequence_position(2, 1501.04, -100.84, 688.87)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.play_sound_effect(var0, 6)
		event.set_object_sequence_motion(1, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		at = 8
		helper_48bc(3480020)
		event.fade_out_screen(30)
		at = 9
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no ~= 0
			local _ = active_chr_no ~= 1
			active_chr_no = 0
			helper_038a2e4d(80)
		end
		if at <= 2 then
			helper_21700000(3480010, 120)
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			helper_038a2e4d(10)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_038a2e4d(10)
		end
		if at <= 7 then
			helper_21a00000(3480020)
		end
		if at <= 8 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.attach_object_handle_to_character(0, 1)
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_position(0, 1390.73, -76.07, 523.09)
	event.set_character_rotation(0, 0.0, -2.28, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_55fc(arg0: s32, arg1: any, arg2: any, arg3: s32)
	local var4: s32 = 0
	local get_pad_down: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local var11: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var4 = event.get_message_selection_top_line(arg0) or var4
		event.set_message_draw_speed(arg0, 0.0)
		var8 = 0
		var7 = 0
		var6 = 0
		event.set_message_selection(arg0, -1)
		event.set_message_selection(arg0, arg2)
		at = 1
		wait_message(arg0)
		while true do
			var8 = 0
			var7 = helper_08ff853b(arg0)
			if var6 == 0 and var7 == -1 then
				event.play_message_sound(2)
				var8 = -1
			end
			if var6 == 0 and var7 == 1 then
				event.play_message_sound(2)
				var8 = 1
			end
			var6 = var7
			pressed = event.is_event_button_pressed(0) or pressed
			pressed_2 = event.is_event_button_pressed(1) or pressed_2
			get_pad_down = event.get_buttons_pressed() or get_pad_down
			var11 = event.get_message_window_frame(arg0) or var11
			if var11 == 5 then
				if bit32.band(get_pad_down, 32768) ~= 0 then
					event.play_message_sound(2)
					var8 = -1
				end
				if bit32.band(get_pad_down, 8192) ~= 0 then
					event.play_message_sound(2)
					var8 = 1
				end
			else
				if bit32.band(get_pad_down, 4096) ~= 0 then
					event.play_message_sound(2)
					var8 = -1
				end
				if bit32.band(get_pad_down, 16384) ~= 0 then
					event.play_message_sound(2)
					var8 = 1
				end
			end
			if pressed_2 ~= 0 then
				event.play_message_sound(0)
				at = 2
				vm.wait(2)
				break
			else
				if pressed ~= 0 then
					event.play_message_sound(1)
					at = 3
					vm.wait(3)
					if arg3 == 0 then
						close_message(arg0)
						return -1
					end
				end
				if var8 == 1 then
					if arg2 < vm.wrap(vm.wrap(arg1 - 1) + var4) then
						arg2 = vm.wrap(arg2 + 1)
					else
						arg2 = vm.wrap(vm.wrap(arg1 - 1) + var4)
					end
				end
				if var8 == -1 then
					if var4 < arg2 then
						arg2 = arg2 - 1
					else
						arg2 = var4
					end
				end
				event.set_message_selection(arg0, arg2)
				at = 4
				vm.wait(4)
			end
		end
		close_message(arg0)
		return arg2
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				var8 = 0
				var7 = helper_76929aca(arg0)
				var8 = -1
				var8 = 1
				local _ = var6 == 0
				local _ = var6 == 0
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_d16eef1e(arg0)
			return -1
		end
		if at <= 4 then
			helper_d16eef1e(arg0)
			return arg2
		end
		return nil
	end)
end

--- Helper function.
local function helper_6314(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: any)
	local var8: any = 0
	local at: number = 0
	return vm.guard(function()
		local _ = open_message(arg0, arg1, arg2, arg3, arg4)
		at = 1
		var8 = helper_55fc(arg0, arg5, arg6, 0)
		event.set_message_bubble_screen_slot(arg0, 0)
		return var8
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var8 = received[1] :: number
			end
			return var8
		end
		return nil
	end)
end

--- Helper function.
local function helper_11ed8()
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
		event.open_message_window_2(0, "「岬の灯台」を出ますか？")
		at = 1
		var0 = helper_6314(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(1776.49, -106.69, 1400.79)
			event.set_camera_sequence_look_at(1951.33, -163.61, 1351.42)
			event.set_object_sequence_position(0, 1943.88, -189.72, 1357.17)
			event.set_object_sequence_rotation(0, 0.0, 1.21, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, 1943.88, -189.72, 1357.17)
			event.add_object_sequence_path_point(0, 2022.78, -189.88, 1386.95)
			event.add_object_sequence_path_point(0, 2104.45, -195.47, 1399.2)
			event.add_object_sequence_path_point(0, 2155.72, -202.4, 1401.26)
			event.start_object_sequence_path(0)
			at = 2
			helper_888ab2a3(30)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			event.set_character_motion(0, "立ち", 4)
			event.set_object_handle_footstep_sound(0, -1)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + var1)
			var5 = var2
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + var3)
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
			event.set_object_handle_footstep_sound(0, -1)
			event.reset_follow_camera(0)
			event.finish_event()
		end
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
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

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_161be1ae

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_161be1ae()
	helper_e4e2e66b()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	var0 = event.get_triggered_event_data_2(6) or var0
	if var0 == 1 then
		if helper_11630() ~= 0 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		helper_888ab2a3(6)
		event.open_use_item_menu(371)
		vm.wait(3)
		item = vmhost.used_item() or item
		if item == 371 then
			event.set_function_point_enabled("", "event", 0)
			helper_11434()
			event.load_dungeon_map("d03b02")
			event.load_event_script("d03b02/d03b02.stb", 500)
			return
		elseif item > 0 then
			helper_df618068()
		end
	end
	event.show_dungeon_status_bar(1, 0.16666667)
	helper_888ab2a3(6)
	event.finish_event()
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_function_point_enabled("", "e348", 0)
		helper_52115bbf()
		event.fade_out_screen(30)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_ee14()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_ee14()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	if helper_11ed8() ~= 0 then
		event.load_event_script("d03/d03.stb", 1000)
	end
end

return script
