--!strict
-- map/s/s46/s46.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_2b01dbd7 = require("@lib/event/helper_2b01dbd7")
local helper_2e67f92b = require("@lib/event/helper_2e67f92b")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_57c93eff = require("@lib/event/helper_57c93eff")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_afed7092 = require("@lib/event/helper_afed7092")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0

--- Helper function.
local function helper_1156c()
	local var0: s32 = 0
	local time: f32 = 0
	vm.section(function()
		event.set_save_flag(406, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_all_sounds()
		event.load_music(58)
		event.play_music(0)
		event.load_map_sounds(4801)
		var0 = event.load_sound_effect_file_2(4801) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e400/e406/")
		event.load_message_file(0, 5, "e406.txt")
		event.load_character(5, "e406_minchu.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e406_eina.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e406_bed.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.set_object_handle_position(0, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "寝てる", 4)
		event.attach_character_to_frame(10, "minchu", 8)
		event.set_object_handle_sound_bank(0, var0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 64.33, 13.21, 70.24)
		event.set_object_handle_rotation(1, 0.0, -1.48, 0.0)
		event.set_object_handle_motion(1, "本読む", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目パチ")
		event.set_character_position(10, 58.0, 13.0, 108.0)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.set_character_motion(10, "寝てる", 4)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(22.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-25.28, 87.45, 28.6)
		event.set_camera_sequence_look_at(68.06, 28.91, 95.45)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "口パク")
		helper_4116e6bb(4060020)
		event.set_object_sequence_motion(1, "本閉じる", 2)
		event.queue_object_sequence_next_motion(1, "ユリス見るL", 4)
		helper_888ab2a3(14)
		event.play_sound_effect(var0, 0)
		wait_objects(1)
		event.set_camera_sequence_position(62.04, 40.15, 70.68)
		event.set_camera_sequence_look_at(59.03, 34.16, 100.4)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		helper_4116e6bb(4060030)
		event.set_object_sequence_motion(0, "エイナを見る", 6)
		event.queue_object_sequence_next_motion(0, "エイナを見るL", 4)
		event.set_object_sequence_motion(2, "エイナを見る", 6)
		event.queue_object_sequence_next_motion(2, "エイナを見るL", 4)
		event.play_sound_effect(var0, 1)
		wait_objects(0)
		wait_objects(2)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		helper_4116e6bb(4060035)
		wait_objects(0)
		wait_objects(2)
		event.set_camera_sequence_position(43.31, 40.29, 81.27)
		event.set_camera_sequence_look_at(72.59, 39.24, 71.2)
		event.set_mouth_texture_animations(1, "口パク")
		helper_4116e6bb(4060040)
		event.set_camera_sequence_position(3.77, 60.04, 42.87)
		event.set_camera_sequence_look_at(71.41, 28.24, 86.89)
		event.set_object_sequence_motion(1, "上を見る", 6)
		event.queue_object_sequence_next_motion(1, "上を見るL", 4)
		event.set_mouth_texture_animations(1, "口パク")
		helper_4116e6bb(4060044)
		event.set_mouth_texture_animations(1, "口パク")
		helper_4116e6bb(4060048)
		wait_objects(1)
		event.set_camera_sequence_position(62.04, 40.15, 70.68)
		event.set_camera_sequence_look_at(59.03, 35.79, 100.4)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		helper_4116e6bb(4060050)
		event.set_object_sequence_motion(0, "起きる", 6)
		event.queue_object_sequence_next_motion(0, "起きるL", 4)
		event.set_object_sequence_motion(2, "起きる", 6)
		event.queue_object_sequence_next_motion(2, "起きるL", 4)
		event.play_sound_effect(var0, 2)
		wait_objects(0)
		wait_objects(2)
		event.set_mouth_texture_animations(0, "しんけん口パク")
		helper_4116e6bb(4060055)
		event.set_camera_sequence_position(48.78, 37.2, 87.09)
		event.set_camera_sequence_look_at(65.24, 40.1, 73.06)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "わらい目")
		event.set_object_sequence_motion(1, "ユリス見るL", 4)
		event.set_mouth_texture_animations(1, "口パク")
		helper_4116e6bb(4060060)
		event.set_camera_sequence_position(61.65, 38.17, 78.76)
		event.set_camera_sequence_look_at(58.54, 38.63, 100.33)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "起きる会話", 6)
		event.queue_object_sequence_next_motion(0, "起きるL", 4)
		event.set_object_sequence_motion(2, "起きる会話", 6)
		event.queue_object_sequence_next_motion(2, "起きるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(4060070)
		wait_objects(0)
		wait_objects(2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目あき～目とじ")
		event.move_camera_sequence_eased(60.7, 40.1, 85.35, 58.54, 40.56, 100.33, 40, 0, 0.2)
		wait_camera()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_time_of_day_advancing(1)
	event.set_time_of_day(time)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.stop_music(0)
	vm.wait(24)
end

--- Helper function.
local function helper_db20(arg0: s32)
	local get_now_frame_wait: f32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		var2 = 0
		var6 = 0
		argc_2 = event.get_voice_stream_state(1) or argc_2
		loud = 0
		while true do
			get_now_frame_wait = event.get_character_motion_wait(32) or get_now_frame_wait
			if get_now_frame_wait < vm.f32(0.01) then
				event.set_object_sequence_texture_animation(0, 0, "パクパク")
				event.set_object_sequence_texture_animation(0, 1, "パクパク")
			end
			argc_2 = argc
			argc = event.get_voice_stream_state(1) or argc
			if argc_2 ~= 0 and argc == 0 then
				event.trigger_mouth_motion(2)
				var2 = 2
			end
			var7 = loud
			loud = event.is_voice_stream_audible(1) or loud
			if var7 == 0 and loud == 1 then
				event.trigger_mouth_texture_animation(1)
			end
			if var7 == 1 and loud == 0 then
				event.trigger_mouth_texture_animation(0)
			end
			local t0: s32
			t0, var2 = helper_57c93eff(arg0, var2)
			var5 = t0
			if var5 ~= 0 then
				var6 = vm.i32(var6 + 1)
				break
			else
				if global0 == 137 then
					event.set_object_sequence_texture_animation(0, 0)
					event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
					event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
				end
				at = 1
				vm.wait(1)
				var6 = vm.i32(var6 + 1)
				global0 = vm.i32(global0 + 1)
			end
		end
		if var2 == 0 then
			event.trigger_mouth_motion(2)
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		event.stop_voice_stream(1)
		return
	end, function(received: { any })
		if at <= 1 then
			var6 = var6 + 1
			local _ = global0 == 137
			global0 = vm.i32(global0 + 1)
			return var6
		end
		return nil
	end)
end

--- Helper function.
local function helper_21900000(arg0: s32)
	local var2: s32 = 0
	local var6: s32 = 0
	var2 = 0
	var6 = 0
	var2 = 2
	do
		local _: any
		_, var2 = helper_afed7092(arg0, var2)
	end
	var6 = var6 + 1
	var6 = var6 + 1
	local _ = global0 == 137
	global0 = vm.i32(global0 + 1)
end

--- Helper function.
local function helper_e3c8(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.open_voice_stream_wave(1, arg0)
		while true do
			stream_open_state = event.get_voice_stream_open_state() or stream_open_state
			if stream_open_state == 0 then
				break
			else
				at = 1
				vm.wait(1)
			end
		end
		event.ready_voice_stream(1)
		while true do
			stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
			if stream_open_state_2 == 0 then
				break
			else
				at = 2
				vm.wait(2)
			end
		end
		event.open_message_window_2(0, arg0)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 3
		helper_db20(0)
		close_message(0)
		event.close_voice_stream(1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 2 then
				helper_f018b3c0(0, -1, 8, 0, 0)
				helper_21900000(0)
			end
			helper_d16eef1e(0)
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_21d00000(arg0: s32)
	helper_f018b3c0(0, -1, 8, 0, 0)
	helper_21900000(0)
	helper_d16eef1e(0)
end

--- Helper function.
local function helper_ef44()
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		helper_2b01dbd7()
		global0 = 0
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(58)
		event.play_music(0)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "目パチ")
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.attach_character_to_frame(33, "pie", 34)
		event.attach_character_to_frame(33, "pie", 35)
		event.set_camera_sequence_position(-22.48, 31.6, -71.45)
		event.set_camera_sequence_look_at(74.99, 21.39, -133.6)
		event.set_object_sequence_position(0, 71.93, 0.0, -137.17)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(1, -32.7, 0.0, -81.53)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.set_object_sequence_motion(0, "座り", 4)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "左を見る", 6)
		event.queue_object_sequence_next_motion(0, "左を見るL", 0)
		event.set_object_sequence_motion(1, "ポテトパイ歩き", 4)
		event.move_object_sequence(1, 29.44, 0.0, -115.61, 120)
		at = 2
		helper_888ab2a3(120)
		event.detach_character_from_frame(34)
		event.detach_character_from_frame(35)
		event.set_character_active(0, 33)
		event.set_character_active(1, 36)
		event.attach_character_to_frame(32, "pie", 36)
		event.set_camera_sequence_position(15.46, 33.35, -97.19)
		event.set_camera_sequence_look_at(39.19, 15.77, -110.22)
		event.set_object_sequence_position(0, 45.12, 0.0, -113.39)
		event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
		event.set_object_sequence_motion(0, "喜ぶ", 6)
		event.queue_object_sequence_next_motion(0, "喜ぶL", 0)
		at = 3
		helper_888ab2a3(60)
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(25.57, 23.79, -65.13)
		event.set_camera_sequence_look_at(36.95, 20.17, -110.66)
		event.set_object_sequence_position(0, 45.12, 0.0, -113.39)
		event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
		event.set_object_sequence_position(1, 28.93, 0.0, -101.8)
		event.set_object_sequence_rotation(1, 0.0, 2.04, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "パクパク")
		event.set_object_sequence_motion(0, "食べる", 6)
		event.queue_object_sequence_next_motion(0, "エイナ見立ち", 6)
		event.queue_object_sequence_next_motion(0, "食べる", 6)
		event.queue_object_sequence_next_motion(0, "エイナ見立ち", 4)
		event.set_object_sequence_motion(1, "ユリス見立ち", 4)
		at = 4
		helper_e3c8(2090590)
		at = 5
		helper_e3c8(2090593)
		at = 6
		helper_e3c8(2090595)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 7
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(120)
		end
		if at <= 2 then
			helper_038a2e4d(60)
		end
		if at <= 3 then
			helper_21d00000(2090590)
		end
		if at <= 4 then
			helper_21d00000(2090593)
		end
		if at <= 5 then
			helper_21d00000(2090595)
		end
		if at <= 6 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	helper_2e67f92b()
	event.stop_music(0)
	event.set_time_of_day_advancing(1)
	event.set_time_of_day(time)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_fff4()
	local time: f32 = 0
	vm.section(function()
		event.set_save_flag(307, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_all_sounds()
		event.load_music(58)
		event.play_music(0)
		event.load_map_sounds(3801)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e300/e307/")
		event.load_message_file(0, 5, "e307.txt")
		event.load_character(5, "e307_minchu.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e307_eina.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "e307_bed.gltf", "info", 10)
		event.set_character_active(10)
		event.load_character(5, "e307_senmen.gltf", "info", 11)
		event.set_character_active(11)
		event.change_directory("")
		event.set_object_handle_position(0, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "寝てる", 4)
		event.attach_character_to_frame(10, "minchu", 8)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "苦しい顔")
		event.set_object_handle_texture_animation(0, 1, "苦しい目パチ")
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "座り", 4)
		event.attach_character_to_frame(10, "eina", 9)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "わらい顔")
		event.set_object_handle_texture_animation(1, 1, "目パチ")
		event.set_character_position(10, 58.0, 13.0, 108.0)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.set_character_motion(10, "寝てる", 4)
		event.set_character_position(11, 56.65, 13.0, 71.33)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(12.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-25.28, 87.45, 28.6)
		event.set_camera_sequence_look_at(68.06, 28.91, 95.45)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_object_sequence_motion(1, "頭を冷やす", 6)
		event.queue_object_sequence_next_motion(1, "座り", 4)
		wait_objects(1)
		event.set_camera_sequence_position(51.94, 47.84, 90.03)
		event.set_camera_sequence_look_at(64.5, 32.42, 98.98)
		event.set_mouth_texture_animations(0, "苦しい口パク")
		helper_4116e6bb(3070030)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3070040)
		event.delay_object_sequence_texture_animation_track(0, 180)
		event.set_object_sequence_texture_animation(0, 1, "目あき～とじ")
		event.delay_object_sequence_texture_animation_track(0, 90)
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(0, 30)
		event.set_object_sequence_texture_animation(0, 0, "目あき～とじ")
		event.set_object_sequence_texture_animation(0, 0, "目とじ～目あき")
		event.set_mouth_texture_animations(0, "苦しい口パク")
		helper_4116e6bb(3070050)
		event.set_object_sequence_motion(1, "頭をなでる", 2)
		event.queue_object_sequence_next_motion(1, "頭をなでるL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3070060)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3070070)
		event.set_camera_sequence_position(35.28, 48.46, 114.2)
		event.set_camera_sequence_look_at(66.59, 39.0, 88.86)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3070075)
		event.set_mouth_texture_animations(0, "苦しい口パク")
		helper_4116e6bb(3070080)
		event.set_camera_sequence_position(50.56, 35.76, 96.14)
		event.set_camera_sequence_look_at(69.63, 43.83, 87.3)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3070090)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.stop_music(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	vm.wait(11)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1156c

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_ef44()
	event.skip_next_music_play()
	event.jump_to_map_3(-1, "g01i07", 502)
	vm.wait(2)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_fff4()
	event.load_dungeon_map("d03f01", "d03f01", 6)
	event.load_event_script("d03/d03.stb", 500)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_1156c()
	event.load_dungeon_map("d04f02", "d04f02", 40)
	event.load_event_script("d04/d04.stb", 500)
end

--- Event 600, which map data, a script or the engine runs by number.
script.event_600 = helper_ef44

return script
