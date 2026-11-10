--!strict
-- map/g/g02/g02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_58610e3d = require("@lib/event/helper_58610e3d")
local helper_5d4cb629 = require("@lib/event/helper_5d4cb629")
local helper_6a3c485f = require("@lib/event/helper_6a3c485f")
local helper_73eddd6a = require("@lib/event/helper_73eddd6a")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8c87ba09 = require("@lib/event/helper_8c87ba09")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_a409b6fa = require("@lib/event/helper_a409b6fa")
local helper_a57b0158 = require("@lib/event/helper_a57b0158")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bc227c8c = require("@lib/event/helper_bc227c8c")
local helper_c0869c7f = require("@lib/event/helper_c0869c7f")
local helper_d7885d22 = require("@lib/event/helper_d7885d22")
local helper_ebc222ab = require("@lib/event/helper_ebc222ab")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_2172c()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 2492.28, 5.66, 457.27)
	event.set_object_sequence_rotation(0, 0.0, -2.76, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.move_object_sequence(0, 2466.56, 6.63, 395.9, 60)
	event.set_camera_sequence_look_at(2466.56, 36.63, 395.98)
	event.set_camera_sequence_position(2513.1, 56.63, 506.94)
	event.fade_in_screen(30)
	helper_888ab2a3(60)
	event.set_object_sequence_motion(0, "立ち")
	helper_888ab2a3(2)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Helper function.
local function helper_277f4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(302, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(3203)
		var0 = event.load_sound_effect_file_2(3203) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e302/")
		event.load_message_file(0, 5, "e302.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e302_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e302_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e302/e302_mints.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e302/e302_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(0, -896.43, 0.0, -466.97)
		event.set_object_handle_rotation(0, 0.0, 1.46, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, -942.31, 0.0, -490.69)
		event.add_object_sequence_path_point(0, -900.66, 0.0, -465.41)
		event.add_object_sequence_path_point(0, -864.88, 0.0, -454.67)
		event.add_object_sequence_path_point(0, -842.75, 0.0, -451.14)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(1, -906.51, 0.0, -493.26)
		event.set_object_handle_rotation(1, 0.0, 1.46, 0.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 94)
		event.add_object_sequence_path_point(1, -936.77, 0.0, -513.55)
		event.add_object_sequence_path_point(1, -908.26, 0.0, -495.93)
		event.add_object_sequence_path_point(1, -873.95, 0.0, -481.67)
		event.add_object_sequence_path_point(1, -846.98, 0.0, -473.74)
		event.start_object_sequence_path(1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 94)
		event.set_object_sequence_motion(1, "立ち")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-628.61, 133.43, -295.88)
		event.set_camera_sequence_look_at(-904.95, 45.82, -445.11)
		event.fade_in_screen(30)
		wait_objects(1)
		helper_888ab2a3(10)
		event.set_camera_sequence_position(-788.75, 21.72, -466.41)
		event.set_camera_sequence_look_at(-845.61, 14.05, -462.57)
		event.move_camera_sequence_angle_height_distance(1.24, 7.67, 56.93, 140)
		event.set_object_sequence_motion(0, "キョロキョロ", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(3020010, 100)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_0382f327(3020020, 40)
		wait_camera()
		event.set_camera_sequence_position(-423.31, 320.91, -1037.27)
		event.set_camera_sequence_look_at(-224.16, 315.23, -1109.17)
		event.move_camera_sequence_eased(-423.31, 320.91, -1037.27, -353.89, 315.23, -1191.88, 120, 2, 0.5)
		helper_0382f327(3020025, 240)
		wait_camera()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-310.58, 2305.36, 307.51)
		event.set_camera_sequence_look_at(-285.96, 2254.59, 250.8)
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-788.75, 21.72, -466.41)
		event.set_camera_sequence_look_at(-845.61, 14.05, -462.57)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "手当てきょろきょろ", 6)
		event.queue_object_sequence_next_motion(1, "戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(0, 1, "口とじ～半口")
		helper_4116e6bb(3020030)
		event.set_object_handle_texture_animation(0, 0, "口とじ～半口")
		wait_objects(1)
		event.set_camera_sequence_position(-866.53, 35.13, -489.41)
		event.set_camera_sequence_look_at(-761.07, 14.23, -373.8)
		event.set_object_sequence_rotation(0, 0.0, 2.43, 0.0)
		event.set_object_sequence_motion(0, "指さす", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3020033)
		wait_objects(0)
		event.set_camera_sequence_position(-798.38, 18.7, -471.33)
		event.set_camera_sequence_look_at(-843.17, 20.06, -461.7)
		event.set_object_sequence_rotation(0, 0.0, 2.91, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(3020036)
		event.set_object_sequence_motion(1, "右向くうなづき", 6)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-890.1, 44.29, -500.83)
		event.set_camera_sequence_look_at(-840.33, 36.43, -459.09)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 0.87, 0.0, 10)
		event.move_object_sequence(0, -801.56, 0.0, -408.6, 60)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.rotate_object_sequence(1, 0.0, 0.87, 0.0, 20)
		event.move_object_sequence(1, -798.52, 0.0, -429.51, 60)
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(18)
	event.cancel_drama_scene_skip()
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, -484.3, 0.0, -241.8)
	event.set_character_rotation(0, 0.0, 0.63, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1fc08()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_camera_sequence_position(-1091.22, 50.0, -610.47)
	event.set_camera_sequence_look_at(-951.89, 30.0, -531.81)
	event.set_object_sequence_position(0, -996.5, 0.0, -556.99)
	event.set_object_sequence_rotation(0, 0.0, 1.06, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.move_object_sequence(0, -951.89, 0.0, -531.81, 45)
	event.fade_in_screen(30)
	helper_888ab2a3(30)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Event 210, which map data, a script or the engine runs by number.
local function event_210()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	event.initialize_event()
	helper_a57b0158()
	var0 = event.get_sound_id(2) or var0
	event.play_sound_effect(var0, 61)
	do
		local out1, out2, out3 = event.get_function_point_position("", "func3")
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var4 = event.get_function_point_rotation("", "func3") or var4
	var4 = vm.f32(var4 - vm.f32(3.1415927))
	var4 = event.wrap_angle(var4) or var4
	event.set_character_position(0, var1, var2, var3)
	event.set_character_rotation(0, 0.0, var4, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_22d00000()
	helper_038a2e4d(30)
end

--- Helper function.
local function helper_20004()
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
		event.open_message_window_2(0, "『てんびん谷停車場』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(-839.6, 49.25, -439.32)
			event.set_camera_sequence_look_at(-953.56, 30.0, -547.13)
			event.set_object_handle_footstep_sound(0, 2)
			event.set_object_sequence_position(0, -1064.31, 0.0, -610.92)
			event.set_object_sequence_rotation(0, 0.0, -2.14, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.move_object_sequence(0, -1180.4, -72.61, -684.29, 50)
			at = 2
			helper_888ab2a3(30)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			event.set_object_handle_footstep_sound(0, 0)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(0.92)) * 30.0) + var1)
			var5 = 0.0
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(0.92)) * 30.0) + var3)
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

--- Helper function.
local function helper_21b28()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local flag: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + var2)
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
	flag = event.get_save_flag(304) or flag
	if flag == 0 then
		event.open_message_window_2(0, "さっきの家に誰かいるかも知れない。\n行ってみよう。")
	else
		event.open_message_window_2(0, "こんなことをしている場合じゃない！\n早くリンを助けなきゃ。")
	end
	show_message(0, -1, 5, 256, 208)
end

--- Helper function.
local function helper_20b50()
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
		event.open_message_window_2(0, "『ステラ渓谷』に移動しますか？")
		at = 1
		var0 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var0 == 0 then
			event.set_camera_sequence_position(2745.73, 115.67, 336.92)
			event.set_camera_sequence_look_at(2562.52, 160.38, 739.42)
			event.set_object_sequence_position(0, 2625.24, 0.0, 792.83)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.clear_object_sequence_path(0)
			event.set_object_sequence_path_frames(0, 60)
			event.add_object_sequence_path_point(0, 2625.24, 0.0, 792.83)
			event.add_object_sequence_path_point(0, 2608.8, 0.0, 896.1)
			event.add_object_sequence_path_point(0, 2558.92, 0.0, 1062.37)
			event.add_object_sequence_path_point(0, 2516.28, 0.0, 1156.04)
			event.start_object_sequence_path(0, 1)
			at = 2
			helper_888ab2a3(30)
			event.fade_out_screen(30)
			at = 3
			helper_888ab2a3(30)
			event.set_character_motion(0, "立ち", 4)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var4 = vm.f32(vm.f32(vm.sin(vm.f32(-2.76)) * 30.0) + var1)
			var5 = var2
			var6 = vm.f32(vm.f32(vm.cos(vm.f32(-2.76)) * 30.0) + var3)
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

--- Helper function.
local function helper_2a408()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.set_camera_position(-621.09, 400.73, 34.49)
		event.set_camera_look_at(-487.13, 465.9, -23.46)
		event.set_save_flag(306, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(2)
		event.play_music(0)
		var0 = event.load_sound_effect_file_2(3209) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e306/")
		event.load_message_file(0, 5, "e306.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e306_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e306_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		block = event.load_event_image_4(5, "e306b.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e30604", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e30605", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e30606", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 0)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 33)
			event.load_equipment_model(5, 0, 4, "info", 33)
			event.load_equipment_model(5, 0, 3, "info", 33)
			event.load_equipment_model(5, 0, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e306/e306_mints.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 33)
			event.attach_object_handle_to_character(0, 33)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 33)
			event.load_equipment_model(5, 1, 4, "info", 33)
			event.load_equipment_model(5, 1, 3, "info", 33)
			event.load_equipment_model(5, 1, 2, "info", 33, 34)
			event.load_character_motion_pack(5, "event/e300/e306/e306_monica.gltf", "info", 33)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(33)
		event.set_character_active(34)
		event.set_object_handle_position(0, 265.0, 0.0, -73.0)
		event.set_object_handle_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, 270.0, 0.0, -35.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		event.move_object_sequence(0, 536.0, 0.0, -76.0, 240)
		event.move_object_sequence(1, 507.0, 0.0, -48.0, 240)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-621.09, 400.73, 34.49)
		event.set_camera_sequence_look_at(-487.13, 465.9, -23.46)
		event.move_camera_sequence_eased(-621.09, 166.82, 34.49, -487.13, 143.67, -23.46, 120, 2, 1.0)
		event.fade_in_screen(30)
		wait_camera()
		wait_objects(0)
		wait_objects(1)
		event.set_camera_sequence_position(2117.25, 46.58, -164.96)
		event.set_camera_sequence_look_at(2180.0, 22.74, -75.0)
		event.set_object_sequence_position(1, 2136.0, 0.0, -151.18)
		event.set_object_sequence_rotation(1, 0.0, 0.61, 0.0)
		event.move_object_sequence(1, 2180.57, 0.0, -93.18, 60)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		helper_888ab2a3(14)
		event.set_object_sequence_position(0, 2125.64, 0.0, -140.88)
		event.set_object_sequence_rotation(0, 0.0, 0.61, 0.0)
		event.move_object_sequence(0, 2164.86, 0.0, -77.4, 60)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		wait_objects(0)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(2176.34, 42.48, -21.97)
		event.set_camera_sequence_look_at(2165.23, -0.03, -107.71)
		event.set_object_sequence_position(0, 2161.96, 0.0, -70.15)
		event.set_object_sequence_rotation(0, 0.0, 2.65, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, -0.95, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3060270)
		wait_objects(1)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_sound_track(0, 14)
		event.play_object_sequence_sound(0, var0, 13)
		wait_objects(0)
		helper_888ab2a3(20)
		event.set_camera_sequence_position(2244.92, 62.5, -22.07)
		event.set_camera_sequence_look_at(2112.09, 19.05, -129.53)
		event.set_object_sequence_rotation(0, 0.0, -2.19, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_rotation(1, 0.0, -2.27, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(1, "指差し", 6)
		event.queue_object_sequence_next_motion(1, "指差しL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3060280)
		event.set_camera_sequence_position(2121.12, 117.35, -94.66)
		event.set_camera_sequence_look_at(2199.27, 126.12, -73.41)
		event.set_event_sprite_draw_pass(0, 2)
		event.set_event_sprite_draw_pass(1, 2)
		event.set_event_sprite_draw_pass(2, 2)
		event.set_object_sequence_color(2, 128, 128, 128, 128)
		event.set_object_sequence_position(0, 2161.96, 100.0, -70.15)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3060285)
		event.set_object_sequence_motion(0, "だめだ", 6)
		event.queue_object_sequence_next_motion(0, "だめだL", 4)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3060290)
		wait_objects(3)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3060300)
		wait_objects(0)
		event.set_object_sequence_motion(0, "やった", 6)
		event.queue_object_sequence_next_motion(0, "やったL", 4)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3060305)
		wait_objects(4)
		wait_objects(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_camera_sequence_position(2211.31, 15.69, -35.88)
		event.set_camera_sequence_look_at(2160.03, 14.35, -94.15)
		event.set_object_sequence_position(0, 2161.96, 0.0, -70.15)
		event.set_object_sequence_rotation(0, 0.0, 0.97, 0.0)
		event.set_object_sequence_motion(0, "うーん", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "うーんL", 4)
		event.set_object_sequence_rotation(1, 0.0, 0.89, 0.0)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.delay_object_sequence_sound_track(1, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3060310)
		wait_objects(0)
		event.set_object_sequence_motion(1, "右向く会話", 2)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "うーん戻り", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3060320)
		wait_objects(1)
		wait_objects(0)
		event.set_object_sequence_motion(0, "左向くうなづき", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.delay_object_sequence_sound_track(0, 14)
		event.play_object_sequence_sound(0, var0, 13)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3060330)
		wait_objects(0)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_character_position(0, 1994.4, 0.0, -247.1)
	event.set_character_rotation(0, 0.0, 0.65, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.1415927, 10.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_233a0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.get_save_flag(57) or flag
			if flag == 0 then
				event.set_save_flag(57, 1)
				event.open_message_window_2(
					arg0,
					"わしはここに住む事になったが\nバース壱号の事も心配じゃ。<page>今まで通り、列車は\nわしが動かすからな。<page>ボルネオはちと荒っぽいし、\nトムはまだ若造じゃからの。<page>これからは、この家と列車を\n行き来する事になるのう。<page>大変じゃ・・・"
				)
			else
				event.open_message_window_2(arg0, "スティーブの調子はどうじゃな？")
			end
		end
		if arg1 == 2 then
			event.open_message_window_2(arg0, "部屋でおとなしくしてるなんて、\nがまんできないぞ。")
		end
		if arg1 == 3 then
			event.open_message_window_2(
				arg0,
				"草木や花は世話した分だけ\nキッチリ育ちます。手を抜くなんて\nできませんぜ。"
			)
		end
		if arg1 == 4 then
			event.open_message_window_2(
				arg0,
				"秘密基地は大丈夫かな？\n誰かに確かめて来て欲しいけど、\n秘密だから頼めないよなぁ・・・"
			)
		end
		if arg1 == 5 then
			event.open_message_window_2(
				arg0,
				"むらさき色って素晴らしい色だよ。\n暖かいようで冷たくて、\n明るいようで暗くてさ。"
			)
		end
		if arg1 == 6 then
			event.open_message_window_2(arg0, "病に苦しむ人がいるなら、\nどこへでも行くつもりだよ。")
		end
		if arg1 == 7 then
			event.open_message_window_2(arg0, "どこに行っても美味い物を作るのが\nプロの料理人です。")
		end
		if arg1 == 8 then
			event.open_message_window_2(arg0, "やっぱりお家はがんじょうな方が\n良いじゃない？")
		end
		if arg1 == 9 then
			event.open_message_window_2(
				arg0,
				"木の実も美味いけど、やっぱ\nあの赤いのが最高だ。\nまた、持ってきてくれよな。"
			)
		end
		if arg1 == 10 then
			event.open_message_window_2(
				arg0,
				"書物にとって湿気は大敵です。\n水の近くに住むなんてとんでもない。"
			)
		end
		if arg1 == 11 then
			event.open_message_window_2(
				arg0,
				"おしゃれでも可愛くもないけど、\n私にしか作れない服を作っていきます。"
			)
		end
		if arg1 == 12 then
			event.open_message_window_2(arg0, "新しい場所で心機一転だ。\n初心に戻ってパンを焼くよ。")
		end
		if arg1 == 13 then
			event.open_message_window_2(arg0, "何でも良いから\n派手にぶっ壊したいぜ。")
		end
		if arg1 == 14 then
			event.open_message_window_2(arg0, "未知のモンスターを発見したら、\nただちに報告するように。")
		end
		if arg1 == 15 then
			event.open_message_window_2(
				arg0,
				"まだ男だ女だと区別する奴がいるけど、\n剣の道は剣の道だ。強い奴が正しいのさ。"
			)
		end
		if arg1 == 16 then
			event.open_message_window_2(arg0, "こんな小さな家に、家族だけで住むのも\n悪くないかもな。")
		end
		if arg1 == 17 then
			event.open_message_window_2(arg0, "モートンはちゃんとやっているかな。\n心配だ・・・")
		end
		if arg1 == 18 then
			event.open_message_window_2(arg0, "まだ教会のない町があるのなら、\n私がそこに赴きましょう。")
		end
		if arg1 == 19 then
			event.open_message_window_2(
				arg0,
				"最近はあまり月の事を考えなくなったよ。\nトモダチがたくさん出来たからかな？"
			)
		end
		if arg1 == 20 then
			event.open_message_window_2(arg0, "土地が違えば魚も変わる。\n釣りの仕方も工夫しないとな。")
		end
		if arg1 == 21 then
			event.open_message_window_2(arg0, "ここの水は魚が良く育ちそうだわ。")
		end
		if arg1 == 22 then
			event.open_message_window_2(
				arg0,
				"パトリったら、また女の人の絵を\n描き始めたの。私以上の美人に\nするんですって。"
			)
		end
		if arg1 == 23 then
			event.open_message_window_2(
				arg0,
				"虫ってどうしてあんな気味の悪い形を\nしているのかしら・・・"
			)
		end
		if arg1 == 24 then
			event.open_message_window_2(
				arg0,
				"もっとかわいいお家にしてちょうだい。\nかわいさに限界なんてないのよ！"
			)
		end
		if arg1 == 25 then
			event.open_message_window_2(arg0, "まさかこの歳になって引っ越すとは\n思わなかったよ。")
		end
	else
		helper_6a3c485f(arg0, arg1)
	end
end

--- Helper function.
local function helper_246b8()
	local var1: s32 = 0
	local var2: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	helper_233a0(0, var2)
	helper_1c04a0eb(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

--- Helper function.
local function helper_24b84()
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.set_character_motion(0, "立ち")
	event.set_character_motion(var1, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	var4 = 0
	if var2 == 10 or var2 == 18 then
		var4 = 8
	end
	if var2 == 1 or var2 == 6 or var2 == 17 then
		var4 = 16
	end
	if var2 == 2 or var2 == 15 or var2 == 16 or var2 == 19 or var2 == 20 or var2 == 21 or var2 == 22 then
		var4 = 24
	end
	if var2 == 3 or var2 == 4 or var2 == 5 or var2 == 7 or var2 == 8 or var2 == 23 or var2 == 24 then
		var4 = 32
	end
	if var2 == 9 or var2 == 11 or var2 == 13 then
		var4 = 40
	end
	event.set_message_window_option(1, 4, 30, 60, 144, -1)
	event.set_message_window_option(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.get_character_position(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.get_character_rotation(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.get_character_position(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.get_character_rotation(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.get_look_angle(var5 - var11, var7 - var13) or var17
	event.set_character_rotation(0, var14, var17, var16)
	var18 = event.get_look_angle(var11 - var5, var13 - var7) or var18
	event.set_character_rotation(var1, var8, var18, var10)
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.get_function_point_position("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.set_camera_position(var20, var21, var22)
		event.set_camera_look_at(var5, var6 + 30.0, var7)
		var18 = event.get_look_angle(var20 - var5, var22 - var7) or var18
		event.set_character_rotation(var1, var8, var18, var10)
	else
		pos_x = vm.f32(vm.sin(var18) * 30.0)
		pos_x = vm.f32(pos_x + var5)
		pos_y = vm.f32(var6 + 33.0)
		pos_z = vm.f32(vm.cos(var18) * 30.0)
		pos_z = vm.f32(pos_z + var7)
		event.set_camera_position(pos_x, pos_y, pos_z)
		pos_x_2 = var5
		pos_y_2 = vm.f32(var6 + 30.0)
		pos_z_2 = var7
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	end
	event.set_character_active(0, 0)
	vm.wait(1)
	event.start_crossfade(10)
	var29 = 0
	while true do
		set_window_mode(3, 1)
		helper_233a0(3, var2)
		var30 = -1
		event.set_message_draw_speed(3, 0, 0)
		set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		var31 = event.get_npc_message_number_3(var2, 0) or var31
		event.set_message_item_system_message(1, 1, var31)
		open_message(1, 1, 1, 0, 0)
		set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.set_message_item_system_message(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.set_message_item_system_message(2, 1, var30)
			event.set_message_item_system_message(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_bac0e30d(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_d7885d22()
				event.start_crossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.fade_out_screen(25)
				helper_888ab2a3(30)
				event.set_npc_party_status(var2, 1)
				event.open_party_select_menu()
				vm.wait(4)
				helper_d7885d22()
				event.fade_in_screen(30)
				return
			end
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			show_message(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if var29 == 1 then
			set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			var30 = event.get_npc_message_number_3(var2, 3) or var30
			show_message(3, var30, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "よし、これで\n修理完了じゃ！")
						show_message(3, -1, 3, 256, 208)
						helper_d7885d22()
						event.start_crossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_bc227c8c(6)
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_bc227c8c(23)
						return
					end
					if var2 == 4 then
						if helper_73eddd6a() ~= 0 then
							helper_bc227c8c(33)
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_bc227c8c(0)
					end
					if var2 == 12 then
						helper_bc227c8c(1)
					end
					if var2 == 6 then
						helper_bc227c8c(2)
					end
					if var2 == 7 then
						helper_bc227c8c(3)
					end
					if var2 == 2 then
						helper_bc227c8c(7)
					end
					if var2 == 3 then
						helper_bc227c8c(8)
					end
					if var2 == 5 then
						helper_bc227c8c(9)
					end
					if var2 == 8 then
						helper_bc227c8c(10)
					end
					if var2 == 10 then
						helper_bc227c8c(11)
					end
					if var2 == 11 then
						helper_bc227c8c(12)
					end
					if var2 == 13 then
						helper_bc227c8c(13)
					end
					if var2 == 16 then
						helper_bc227c8c(14)
					end
					if var2 == 18 then
						helper_bc227c8c(15)
					end
					if var2 == 19 then
						helper_bc227c8c(16)
					end
					if var2 == 20 then
						helper_bc227c8c(17)
					end
					if var2 == 21 then
						helper_bc227c8c(18)
					end
					if var2 == 22 then
						helper_bc227c8c(19)
					end
					if var2 == 23 then
						helper_bc227c8c(20)
					end
					if var2 == 24 then
						helper_bc227c8c(21)
					end
					if var2 == 25 then
						helper_bc227c8c(22)
					end
					if var2 == 17 then
						helper_bc227c8c(32)
					end
					if var2 == 9 then
						helper_c0869c7f()
						show_message(3, -1, 3, 256, 208)
						helper_d7885d22()
						event.start_crossfade(10)
					end
					if var2 == 14 then
						event.fade_out_screen(25)
						helper_888ab2a3(30)
						event.open_event_menu(25)
						vm.wait(35)
						helper_d7885d22()
						event.fade_in_screen(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_d7885d22()
	event.start_crossfade(10)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_a57b0158

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local old_sub_map_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_a57b0158()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, 1989.0, 0.0, -198.0)
			event.set_character_rotation(0, 0.0, -1.21, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var2 = event.get_map_type(old_map_no) or var2
			print("--- OLD MAP NO = ", old_map_no, "\n")
			if var2 ~= -1 then
				if var2 == 7 or var2 == 8 then
					at = 1
					helper_2172c()
				elseif old_map_no == 26 then
					event.set_camera_position(-741.9, 50.0, -592.0)
					event.set_camera_look_at(-741.9, 30.0, -712.0)
					event.set_character_position(0, -741.9, 0.0, -712.0)
					event.set_character_rotation(0, 0.0, 0.0, 0.0)
					event.fade_in_screen(30)
				else
					flag = event.get_save_flag(300) or flag
					flag_2 = event.get_save_flag(302) or flag_2
					if flag == 1 and flag_2 == 0 then
						at = 2
						helper_277f4()
					else
						at = 3
						helper_1fc08()
					end
				end
			else
				old_sub_map_no = event.get_previous_submap() or old_sub_map_no
				if old_sub_map_no == 100 then
					event_210()
				end
				if old_sub_map_no == -1 then
					event_210()
				end
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", old_sub_map_no, "\n")
			end
		end
		at = 4
		helper_5d4cb629(1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				at = 2
				helper_277f4()
				return vm.continue_with(function()
					at = 4
					helper_5d4cb629(1)
					return
				end)
			end
			if at <= 2 then
				helper_22d00000()
			end
			if at <= 3 then
				helper_a409b6fa()
				helper_a409b6fa()
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				print("--- OLD SUBMAP NO = ", old_sub_map_no, "\n")
				helper_ebc222ab(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local now_party_chara_id: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		flag = event.get_save_flag(300) or flag
		flag_2 = event.get_save_flag(304) or flag_2
		flag_3 = event.get_save_flag(306) or flag_3
		flag_4 = event.get_save_flag(324) or flag_4
		flag_5 = event.get_save_flag(328) or flag_5
		flag_6 = event.get_save_flag(330) or flag_6
		if flag == 1 then
			now_party_chara_id = event.get_party_npc() or now_party_chara_id
			if
				flag_2 == 0
				or flag_3 == 0 and now_party_chara_id == 6
				or flag_4 == 1 and flag_5 == 0
				or flag_4 == 1 and flag_6 == 0
			then
				if not (flag_4 == 1 and flag_5 == 0) then
					event.skip_next_music_load()
				end
				event.jump_to_map_3(-1, "g02i02", 100)
				at = 1
				vm.wait(1)
				print("--- MAP_JUMP(g02i02) ---\n")
				return
			end
		end
		event.go_to_interior_map(-1, "g02i02", 100)
		at = 2
		vm.wait(2)
		print("--- GOTO_INTERIOR(g02i02) ---\n")
		return
	end, function(received: { any })
		if at <= 1 then
			print("--- MAP_JUMP(g02i02) ---\n")
			return 0
		end
		if at <= 2 then
			print("--- GOTO_INTERIOR(g02i02) ---\n")
			return 0
		end
		return nil
	end)
end

script.event_210 = event_210

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_8c87ba09(vm.f32(-743.2), 0.0, vm.f32(-708.9), vm.f32(-0.64))
	event.jump_to_map_2(-1, "f02")
	vm.wait(2)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_5d4cb629(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	if helper_20004() ~= 0 then
		event.jump_to_map_2(-1, "s04")
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local flag: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(306) or flag
	if flag == 0 then
		helper_21b28()
	elseif helper_20b50() ~= 0 then
		event.set_dungeon_stage_id(2)
		event.open_event_menu(3, 2)
		vm.wait(3)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			helper_2172c()
		else
			flag_2 = event.get_save_flag(307) or flag_2
			flag_3 = event.get_save_flag(344) or flag_3
			if var3 == 2 and flag_2 == 0 or var3 == 21 and flag_3 == 0 or var3 == 22 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(2, var3, 1010)
		end
	end
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_a57b0158()
	helper_58610e3d()
	helper_5d4cb629(1)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	helper_a57b0158()
	helper_2a408()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	helper_246b8()
	helper_24b84()
end

--- Event 13020, which map data, a script or the engine runs by number.
script.event_13020 = helper_277f4

return script
