--!strict
-- map/i/i01/h01/i01h01c.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0999bd0f = require("@lib/event/helper_0999bd0f")
local helper_17069978 = require("@lib/event/helper_17069978")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_3936899e = require("@lib/event/helper_3936899e")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_658b1052 = require("@lib/event/helper_658b1052")
local helper_662e1f81 = require("@lib/event/helper_662e1f81")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_7e7c045c = require("@lib/event/helper_7e7c045c")
local helper_86e93423 = require("@lib/event/helper_86e93423")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_ce6820bc = require("@lib/event/helper_ce6820bc")
local helper_d529ed92 = require("@lib/event/helper_d529ed92")
local helper_e52544df = require("@lib/event/helper_e52544df")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_d8e8(se_id: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		at = 1
		wait_camera()
		event.set_camera_sequence_position(-26.93, 26.72, -145.82)
		event.set_camera_sequence_look_at(27.6, 22.54, -159.02)
		event.set_object_sequence_position(0, 16.25, -0.02, -166.37)
		event.set_object_sequence_rotation(0, 0.0, 1.16, 0.0)
		event.set_object_sequence_motion(0, "上見立ち", 4)
		event.set_object_sequence_position(2, 38.77, -0.02, -147.68)
		event.set_object_sequence_rotation(2, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		at = 2
		helper_888ab2a3(30)
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		at = 3
		wait_camera()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		at = 4
		helper_888ab2a3(10)
		event.set_mouth_texture_animations(2, "大口パク")
		at = 5
		helper_4116e6bb(1060010)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "ＯＫ！！\nもう少し待って。")
		at = 6
		var1 = helper_7e7c045c(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if var1 == 0 then
			at = 7
			helper_4116e6bb(1060040)
			event.play_sound_effect(se_id, 2)
			event.set_object_sequence_motion(0, "ガッツポーズ", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			event.set_object_sequence_motion(2, "ガッツポーズ", 6)
			event.queue_object_sequence_next_motion(2, "立ち", 0)
			event.set_mouth_texture_animations(2, "大口パク")
			at = 8
			helper_4116e6bb(1060050)
			event.reset_mouth_texture_animations()
			event.fade_out_music(30)
			event.fade_out_screen(30)
			at = 9
			helper_888ab2a3(30)
			return 1
		else
			event.set_object_sequence_motion(0, "上見会話", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			at = 10
			helper_888ab2a3(9)
			at = 11
			helper_4116e6bb(1060020)
			event.set_object_sequence_motion(2, "会話2", 6)
			at = 12
			helper_888ab2a3(9)
			event.set_mouth_texture_animations(2, "大口パク")
			at = 13
			helper_4116e6bb(1060030)
			event.reset_mouth_texture_animations()
			return 0
		end
	end, function(received: { any })
		if at <= 9 then
			if at == 6 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			if at <= 2 then
				helper_344d6cd8()
			end
			if at <= 3 then
				helper_038a2e4d(10)
			end
			if at <= 4 then
				helper_8cd371d7(1060010)
			end
			if at <= 5 then
				var1 = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
			end
			if at <= 6 then
				helper_8cd371d7(1060040)
			end
			if at <= 7 then
				helper_8cd371d7(1060050)
			end
			if at <= 8 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 13 then
			if at <= 10 then
				helper_8cd371d7(1060020)
			end
			if at <= 11 then
				helper_038a2e4d(9)
			end
			if at <= 12 then
				helper_8cd371d7(1060030)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_e4a8(arg0: s32, se_id: s32)
	event.set_camera_sequence_position(-98.46, 29.02, -221.77)
	event.set_camera_sequence_look_at(-133.84, 25.44, -219.86)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(0, 0.0, 1.61, 0.0)
	event.set_object_sequence_position(2, -79.25, -13.53, -223.34)
	event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
	event.set_object_sequence_position(3, -143.53, -12.49, -220.28)
	event.set_object_sequence_rotation(3, 0.0, 1.61, 0.0)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 4)
	event.fade_in_screen(30)
	helper_888ab2a3(30)
	helper_888ab2a3(45)
	event.play_sound_effect(se_id, 6)
	event.play_sound_effect(se_id, 8)
	event.set_object_handle_frame_draw_flag(3, "light", arg0)
	helper_888ab2a3(45)
end

--- Helper function.
local function helper_ea44(arg0: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-51.29, 55.13, -119.05)
	event.set_camera_sequence_look_at(-104.92, 14.85, -202.28)
	projection = event.get_event_projection() or projection
	event.set_event_projection(524.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -85.21, -13.05, -197.85)
	event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 1)
	event.set_object_sequence_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(3, "下見立ち", 4)
	event.set_object_sequence_motion(2, "上見立ち", 4)
	helper_888ab2a3(15)
	event.set_object_sequence_motion(2, "上見会話", 6)
	event.queue_object_sequence_next_motion(2, "上見立ち", 0)
	event.set_mouth_texture_animations(2, "大口パク")
	helper_4116e6bb(1060060)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(2, "大口パク")
	helper_4116e6bb(1060061)
	event.reset_mouth_texture_animations()
	event.set_event_projection(projection)
end

--- Helper function.
local function helper_f11c(arg0: any)
	event.set_camera_sequence_position(-93.2, 20.09, -139.75)
	event.set_camera_sequence_look_at(-109.87, 17.08, -226.98)
	event.reset_object_sequence_motion(1)
	event.reset_object_sequence_motion(3)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.reset_object_sequence_motion(0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -85.21, -13.05, -197.85)
	event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -119.73, -13.05, -196.93)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.reset_object_sequence_motion(3)
	event.set_object_handle_visible(11, 0)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.queue_object_sequence_next_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(2, "上見立ち", 4)
	event.set_object_sequence_motion(3, "うなづく", 6)
	event.queue_object_sequence_next_motion(3, "下見立ち", 4)
	event.set_mouth_texture_animations(0, "わらい口パク")
	helper_4116e6bb(1060070)
	event.reset_mouth_texture_animations()
	helper_888ab2a3(15)
	event.set_object_sequence_motion(2, "上見会話2", 6)
	event.queue_object_sequence_next_motion(2, "上見立ち", 0)
	event.set_mouth_texture_animations(2, "わらい口パク")
	helper_4116e6bb(1060080)
	event.reset_mouth_texture_animations()
	helper_888ab2a3(15)
	event.set_object_sequence_motion(0, "まかせて", 6)
	event.queue_object_sequence_next_motion(0, "下見立ち", 4)
	event.set_object_sequence_motion(3, "まかせて", 6)
	event.queue_object_sequence_next_motion(3, "下見立ち", 4)
	helper_888ab2a3(10)
	event.set_mouth_texture_animations(0, "わらい口パク")
	helper_4116e6bb(1060090)
	event.reset_mouth_texture_animations()
	wait_objects(0)
	wait_objects(3)
end

--- Helper function.
local function helper_fb2c(se_id: s32)
	local projection: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local projection_2: f32 = 0
	event.set_camera_sequence_position(-120.59, 12.3, -121.56)
	event.set_camera_sequence_look_at(-121.3, 14.64, -178.67)
	event.get_event_projection(projection)
	event.set_event_projection(478.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -92.88, -13.05, -212.34)
	event.set_object_sequence_rotation(2, 0.0, -1.44, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 0)
	vm.wait(1)
	event.set_object_sequence_motion(2, "歩き", 4)
	event.rotate_object_sequence(2, 0.0, -2.88, 0.0, 15)
	event.delay_object_sequence_motion_track(2, 15)
	event.set_object_sequence_motion(2, "上見立ち", 0)
	event.play_sound_effect(se_id, 4)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.rotate_object_sequence(0, 0.0, -3.11, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -3.11, 0.0, 30)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 0)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 0)
	event.play_sound_effect(se_id, 5)
	event.rotate_object_sequence(12, 0.0, -1.57, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 1.57, 0.0, 50)
	helper_888ab2a3(50)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -125.29, -12.78, -310.13, 120)
	event.move_object_sequence(3, -125.29, -12.78, -310.13, 120)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(70)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	var5 = 1.0
	var2 = vm.f32(132.00003)
	var3 = 120.0
	var4 = vm.f32(vm.fdiv(var2, var3))
	while true do
		projection_2 = vm.f32(vm.f32(478.9) + vm.f32(var4 * var5))
		event.set_event_projection(projection_2)
		vm.wait(4)
		var5 = vm.f32(var5 + 1.0)
		if var5 > var3 then
			break
		end
	end
	event.set_event_projection(projection)
end

--- Helper function.
local function helper_22000000(arg0: s32)
	helper_344d6cd8()
	helper_038a2e4d(30)
	helper_344d6cd8()
	helper_038a2e4d(10)
	helper_8cd371d7(1060010)
	local _ = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
	helper_8cd371d7(1060040)
	helper_8cd371d7(1060050)
	helper_038a2e4d(30)
	return 1
end

--- Helper function.
local function helper_22100000(arg0: s32, arg1: s32)
	helper_038a2e4d(30)
	helper_038a2e4d(45)
	helper_038a2e4d(45)
end

--- Helper function.
local function helper_22200000(arg0: any)
	helper_038a2e4d(15)
	helper_8cd371d7(1060060)
	helper_8cd371d7(1060061)
end

--- Helper function.
local function helper_22300000(arg0: any)
	helper_8cd371d7(1060070)
	helper_038a2e4d(15)
	helper_8cd371d7(1060080)
	helper_038a2e4d(15)
	helper_038a2e4d(10)
	helper_8cd371d7(1060090)
	helper_238b5abc(0)
	helper_238b5abc(3)
end

--- Helper function.
local function helper_22500000(arg0: s32)
	local var5: f32 = 0
	helper_038a2e4d(30)
	helper_038a2e4d(50)
	var5 = 1.0
	var5 = vm.f32(var5 + 1.0)
end

--- Helper function.
local function helper_108e0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local projection: f32 = 0
	local at: number = 0
	return vm.guard(function()
		vm.section(function()
			at = 1
			vm.entry(1)
			event.set_save_flag(106, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			var2 = event.load_sound_effect_file_2(1231) or var2
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
			event.load_character_motion_pack(5, "event/e100/e106/e106_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character(5, "event/e100/e106/e106_starbre.gltf", "info", 34)
			event.attach_object_handle_to_character(2, 34)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_character_active(1, 34)
			event.load_character(5, "event/e100/e106/e106_steve.gltf", "info", 35)
			event.set_character_active(1, 35)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_handle_sound_bank(3, var2)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.load_message_file(0, 5, "event/e100/e106/e106.txt")
			event.stop_music(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
			at = 2
			var0 = helper_d8e8(var2)
			if var0 == 1 then
				event.delete_character_extension_packs(0)
				event.load_character_motion_pack(5, "event/e100/e106/e106_mints2.gltf", "info", 0)
				var1 = event.is_object_handle_frame_visible(3, "light") or var1
				event.set_object_handle_frame_visible(3, "light", 0)
				projection = event.get_event_projection() or projection
				event.enable_drama_skip()
				at = 3
				helper_e4a8(var1, var2)
				at = 4
				helper_ea44(var2)
				at = 5
				helper_f11c(var2)
				event.set_object_handle_sound_bank(3, var2)
				at = 6
				helper_fb2c(var2)
			end
			event.fade_out_screen(30)
			at = 7
			helper_888ab2a3(30)
		end, function(received: { any }): boolean
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				var0 = helper_22000000(var2)
			end
			if at <= 2 then
				helper_22100000(var1, var2)
			end
			if at <= 3 then
				helper_22200000(var2)
			end
			if at <= 4 then
				helper_22300000(var2)
			end
			if at <= 5 then
				helper_22500000(var2)
			end
			if at <= 6 then
				helper_038a2e4d(30)
			end
			return true
		end)
		at = 8
		vm.entry(8)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(var2, 6)
		event.set_event_projection(projection)
		event.set_camera_position(pos_x, pos_y, pos_z)
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_character_motion(0, "立ち", 4)
		event.set_character_active(1, 0)
		event.delete_character_extension_packs(0)
		event.delete_character(34)
		event.delete_character(35)
		if var0 ~= 1 then
			event.play_music(0)
		end
		event.fade_in_screen(30)
		return var0
	end, function(received: { any })
		if at <= 8 then
			return var0
		end
		return nil
	end)
end

--- Helper function.
local function helper_117e0(se_id: s32)
	local projection: f32 = 0
	event.set_camera_sequence_position(-84.68, 6.96, -155.87)
	event.set_camera_sequence_look_at(-202.81, 27.8, -509.36)
	event.get_event_projection(projection)
	event.set_event_projection(468.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(1, -121.68, -12.53, -351.93)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_visible(10, 0)
	event.set_object_handle_visible(11, 0)
	event.set_object_sequence_rotation(12, 0.0, -1.57, 0.0)
	event.set_object_sequence_rotation(13, 0.0, 1.57, 0.0)
	event.set_object_handle_visible(14, 0)
	event.set_object_handle_visible(15, 0)
	event.fade_out_screen(0)
	wait_objects(12)
	wait_objects(13)
	event.play_sound_effect(se_id, 0)
	event.fade_in_screen(30)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -119.53, -12.53, -218.69, 100)
	event.move_object_sequence(1, -119.53, -12.53, -218.69, 100)
	helper_888ab2a3(80)
	event.play_sound_effect(se_id, 4)
	event.rotate_object_sequence(12, 0.0, 0.0, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 0.0, 0.0, 50)
	wait_objects(0)
	wait_objects(1)
	wait_camera()
	event.set_event_projection(projection)
end

--- Helper function.
local function helper_12088(se_id: s32)
	event.set_camera_sequence_position(-119.36, 26.55, -129.41)
	event.set_camera_sequence_look_at(-121.06, 12.13, -226.83)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	helper_888ab2a3(50)
	event.stop_sound_effect(se_id, 0)
	event.play_sound_effect(se_id, 5)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	helper_888ab2a3(30)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_camera_sequence_position(-107.26, 10.75, -131.0)
	event.set_camera_sequence_look_at(-110.45, 11.92, -193.48)
	event.set_character_position(0, -91.97, -12.53, -211.57)
	event.set_character_rotation(0, 0.0, -2.4, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_character_position(33, -119.53, -12.53, -229.18)
	event.set_character_rotation(33, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_handle_frame_visible(1, "light--c0appz0n1", 0)
	wait_objects(0)
	wait_objects(1)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(100, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]ポルカスに再挑戦するなら\n   スティーブに(O)ボタンで\n   アクセスしてください。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
end

--- Helper function.
local function helper_129e4()
	local var0: s32 = 0
	local var1: s32 = 0
	local projection: f32 = 0
	vm.section(function()
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_2(1822) or var0
		var1 = event.load_sound_effect_file_3(7, "snd2/chara/ch_040.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		projection = event.get_event_projection() or projection
		event.get_camera_position()
		event.get_camera_look_at()
		event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 0.0, 50.0, 0.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(33, 0.0, 50.0, 0.0)
		event.set_character_rotation(33, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(1, var1)
		event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
		event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
		event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		helper_117e0(var0)
		helper_12088(var0)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(12)
	event.clear_object_sequence(13)
	event.set_save_flag(56, 0)
	event.set_event_projection(projection)
	event.set_camera_position(-119.36, 26.55, -129.41)
	event.set_camera_look_at(-121.06, 12.13, -226.83)
	event.set_character_position(0, -98.38, -12.53, -200.14)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_object_handle_rotation(12, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(13, 0.0, 0.0, 0.0)
	vm.wait(4)
	event.set_object_handle_visible(10, 1)
	event.set_object_handle_visible(11, 1)
	event.set_object_handle_visible(14, 1)
	event.set_object_handle_visible(15, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_13918(arg0: any)
	local var1: any = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_camera_sequence_position(-138.16, 13.17, -131.29)
		event.set_camera_sequence_look_at(-115.98, 11.22, -208.05)
		event.set_character_active(1, 0)
		event.set_object_sequence_position(0, -98.38, -12.53, -200.14)
		event.set_object_sequence_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_motion(1)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		var2 = event.get_message_window_frame(0) or var2
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "よし！ポルカスに再挑戦だ。\nもう少し準備がたりない。")
		at = 1
		var1 = helper_7e7c045c(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, var2)
		if var1 == 0 then
			event.mark_camera_sequence_fade_track()
			event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
			at = 2
			helper_888ab2a3(30)
			at = 3
			wait_camera()
			at = 4
			vm.wait(4)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			if at <= 2 then
				helper_344d6cd8()
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_13f90(se_id: s32)
	event.set_camera_sequence_position(-120.34, 23.49, -175.84)
	event.set_camera_sequence_look_at(-120.44, 21.93, -203.94)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	wait_objects(0)
	wait_objects(1)
	event.play_sound_effect(se_id, 1)
	helper_888ab2a3(50)
end

--- Helper function.
local function helper_22a00000(arg0: s32)
	helper_344d6cd8()
	helper_238b5abc(0)
	helper_238b5abc(1)
	helper_038a2e4d(50)
end

--- Helper function.
local function helper_15078()
	local var0: s32 = 0
	local projection: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var8: s32 = 0
	local at: number = 0
	return vm.guard(function()
		vm.section(function()
			event.set_character_active(0, 24)
			event.set_save_flag(108, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			event.load_map_sounds(1237)
			var0 = event.load_sound_effect_file_2(1237) or var0
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			projection = event.get_event_projection() or projection
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
			event.set_camera_position(6.02, 94.24, 399.23)
			event.set_camera_look_at(-4.96, 118.28, 117.71)
			event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_character_position(0, 0.0, 50.0, 0.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
			event.set_character_active(1, 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_character_position(33, 0.0, 50.0, 0.0)
			event.set_character_rotation(33, 0.0, 0.0, 0.0)
			event.set_object_handle_sound_bank(1, var0)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.set_object_sequence_rotation(13, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
			event.clear_object_sequence(14)
			event.set_object_sequence_object(14, 14)
			event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
			event.clear_object_sequence(15)
			event.set_object_sequence_object(15, 15)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "おこり顔")
			event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
			at = 1
			var8 = helper_13918(var0)
			if var8 == 1 then
				event.enable_drama_skip()
				at = 2
				helper_13f90(var0)
				at = 3
				helper_ce6820bc(var0)
				event.set_save_flag(56, 1)
			else
				event.set_save_flag(56, 0)
			end
			event.fade_out_screen(30)
			at = 4
			helper_888ab2a3(30)
		end, function(received: { any }): boolean
			if at == 1 then
				var8 = received[1] :: number
			end
			if at <= 1 then
				helper_22a00000(var0)
			end
			if at <= 2 then
				helper_17069978(var0)
			end
			if at <= 3 then
				helper_038a2e4d(30)
			end
			return true
		end)
		at = 5
		vm.entry(5)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(var0, 1)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.get_event_projection(projection)
		event.get_camera_position(pos_x, pos_y, pos_z)
		event.get_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
		at = 6
		vm.wait(6)
		event.delete_character_extension_packs(0)
		event.delete_character(33)
		event.fade_in_screen(30)
		return var8
	end, function(received: { any })
		if at <= 6 then
			return var8
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	local var0: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		at = 1
		helper_888ab2a3(10)
		helper_86e93423()
		at = 2
		var0 = helper_108e0()
		if var0 == 1 then
			event.add_inventory_item(135, 1)
			event.add_inventory_item(145, 1)
			event.add_inventory_item(155, 1)
			event.add_inventory_item(165, 1)
			at = 3
			vm.wait(3)
			argc = event.get_item_count(246) or argc
			if argc == 0 then
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			at = 4
			helper_888ab2a3(30)
			event.fade_in_screen(30)
		else
			helper_658b1052()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			at = 5
			vm.wait(5)
			event.load_event_script("i01h01/i01h01.stb", -1)
		end
		return
	end, function(received: { any })
		if at <= 5 then
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				var0 = helper_108e0()
				return vm.continue_with(function()
					if var0 == 1 then
						event.add_inventory_item(135, 1)
						event.add_inventory_item(145, 1)
						event.add_inventory_item(155, 1)
						event.add_inventory_item(165, 1)
						at = 3
						vm.wait(3)
						argc = event.get_item_count(246) or argc
						if argc == 0 then
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						at = 4
						helper_888ab2a3(30)
						event.fade_in_screen(30)
					else
						helper_658b1052()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						at = 5
						vm.wait(5)
						event.load_event_script("i01h01/i01h01.stb", -1)
					end
					return
				end)
			end
			if at <= 3 then
				helper_038a2e4d(30)
			end
			if at <= 4 then
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0999bd0f

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		at = 1
		helper_888ab2a3(10)
		helper_86e93423()
		at = 2
		var0 = helper_108e0()
		if var0 == 1 then
			argc = event.get_item_count(246) or argc
			if argc <= 0 then
				event.add_inventory_item(135, 1)
				event.add_inventory_item(145, 1)
				event.add_inventory_item(155, 1)
				event.add_inventory_item(165, 1)
				at = 3
				vm.wait(3)
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			at = 4
			helper_888ab2a3(30)
			at = 5
			helper_d529ed92()
			event.skip_next_music_load()
			event.go_to_dungeon(0, 4, 520)
			at = 6
			vm.wait(6)
			return
		else
			helper_658b1052()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			at = 7
			vm.wait(7)
			event.load_event_script("i01h01/i01h01.stb", -1)
		end
		return
	end, function(received: { any })
		if at <= 6 then
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				var0 = helper_108e0()
				return vm.continue_with(function()
					if var0 == 1 then
						argc = event.get_item_count(246) or argc
						if argc <= 0 then
							event.add_inventory_item(135, 1)
							event.add_inventory_item(145, 1)
							event.add_inventory_item(155, 1)
							event.add_inventory_item(165, 1)
							at = 3
							vm.wait(3)
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						at = 4
						helper_888ab2a3(30)
						at = 5
						helper_d529ed92()
						event.skip_next_music_load()
						event.go_to_dungeon(0, 4, 520)
						at = 6
						vm.wait(6)
						return
					else
						helper_658b1052()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						at = 7
						vm.wait(7)
						event.load_event_script("i01h01/i01h01.stb", -1)
					end
					return
				end)
			end
			if at <= 3 then
				helper_038a2e4d(30)
			end
			if at <= 4 then
				helper_e52544df()
			end
			return 0
		end
		if at <= 7 then
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_86e93423()
	event.set_character_active(0, 26)
	event.set_character_active(0, 25)
	helper_129e4()
	event.set_character_active(1, 25)
	event.initialize_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.set_character_active(1, 25)
	event.set_character_active(1, 26)
	event.attach_character_to_frame(25, "back", 26)
	event.set_party_member(2, 0)
	event.set_function_point_enabled("", "fc_event_e108c", 1)
	helper_888ab2a3(30)
	vm.wait(3)
	event.load_event_script("i01h01/i01h01.stb", -1)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local var0: s32 = 0
	helper_86e93423()
	event.set_character_active(0, 25)
	event.set_character_active(0, 26)
	var0 = helper_15078()
	if var0 == 1 then
		event.set_save_flag(25, 1)
		event.set_party_member(2, 1)
		event.skip_next_music_load()
		event.go_to_dungeon(0, 4, 520)
	else
		event.set_save_flag(29, 1)
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
		event.set_function_point_enabled("", "fc_event_e108c", 1)
		vm.wait(2)
		event.load_event_script("i01h01/i01h01.stb", -1)
		return
	end
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		vm.wait(1)
		at = 2
		helper_662e1f81()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_3936899e()
			end
			return 0
		end
		return nil
	end)
end

return script
