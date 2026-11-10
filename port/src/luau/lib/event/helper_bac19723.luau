--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08ac1dd6 = require("@lib/event/helper_08ac1dd6")
local helper_18c31a0e = require("@lib/event/helper_18c31a0e")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_24692f72 = require("@lib/event/helper_24692f72")
local helper_28d4ec9f = require("@lib/event/helper_28d4ec9f")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_72fcbec1 = require("@lib/event/helper_72fcbec1")
local helper_86ac6534 = require("@lib/event/helper_86ac6534")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_937d87bc = require("@lib/event/helper_937d87bc")
local helper_d77001f9 = require("@lib/event/helper_d77001f9")
local helper_edf10af6 = require("@lib/event/helper_edf10af6")
local helper_fee84847 = require("@lib/event/helper_fee84847")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_bac19723()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(202, 1)
		event.initialize_event()
		var0 = event.load_sound_effect_file_2(1837) or var0
		helper_72fcbec1()
		event.set_object_handle_footstep_sound(0, 0)
		event.stop_music(0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-339.31, 136.54, 364.85)
		event.set_camera_sequence_look_at(-238.55, 35.08, 513.89)
		event.set_object_sequence_position(0, -198.33, 13.59, 420.19)
		event.set_object_sequence_rotation(0, 0.0, -0.35, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ぼうぜん顔")
		event.set_object_sequence_texture_animation(0, 1, "つうじょう目パチ")
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 160)
		event.add_object_sequence_path_point(0, -198.33, 13.59, 420.19)
		event.add_object_sequence_path_point(0, -203.12, 13.59, 502.05)
		event.add_object_sequence_path_point(0, -216.28, 13.59, 545.08)
		event.add_object_sequence_path_point(0, -238.62, 13.59, 586.39)
		event.start_object_sequence_path(0)
		event.set_object_handle_footstep_sound(0, 15)
		at = 2
		wait_frames(30)
		event.set_object_handle_footstep_sound(0, 2)
		at = 3
		wait_frames(90)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_camera_sequence_position(-157.69, 69.09, 657.85)
		event.set_camera_sequence_look_at(-309.71, 39.39, 635.31)
		event.set_object_sequence_position(0, -218.73, 13.59, 644.79)
		event.set_object_sequence_rotation(0, 0.0, -1.67, 0.0)
		event.move_object_sequence(0, -301.77, 13.77, 637.45, 60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-157.69, 69.09, 657.85, -309.71, 39.39, 635.31)
		event.add_camera_sequence_path_point(-182.29, 46.57, 654.2, -309.71, 39.39, 635.31)
		event.add_camera_sequence_path_point(-226.21, 39.3, 647.69, -309.71, 39.39, 635.31)
		event.start_camera_sequence_path()
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち", 0)
		at = 4
		wait_frames(150)
		at = 5
		helper_4116e6bb(2020010)
		event.set_camera_sequence_position(-325.02, 31.34, 616.64)
		event.set_camera_sequence_look_at(-305.34, 35.79, 635.58)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		at = 6
		helper_4116e6bb(2020020)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "機関")
		event.set_camera_sequence_position(-333.76, 40.57, 633.22)
		event.set_camera_sequence_look_at(-302.99, 37.72, 637.65)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "通常目～うれし目")
		event.set_object_sequence_texture_animation(0, 1, "半口～うれし開き")
		at = 7
		wait_frames(15)
		event.set_object_sequence_texture_animation(0, 1, "きらきら目")
		event.move_camera_sequence_eased(-326.11, 40.57, 634.32, -302.99, 37.72, 637.65, 90, 2, 0.4)
		at = 8
		helper_4116e6bb(2020030)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "まえ向き～左むき")
		event.play_sound_effect(var0, 6)
		event.set_object_sequence_motion(0, "振り返る", 6, -1.0, 1)
		at = 9
		wait_frames(10)
		event.clear_camera_sequence()
		helper_08ac1dd6(2200.0, 220)
		event.set_camera_sequence_position(-331.99, 42.11, 682.27)
		event.set_camera_sequence_look_at(-281.67, 40.37, 620.78)
		event.play_sound_effect(var0, 8)
		at = 10
		wait_frames(50)
		event.set_object_sequence_motion(0, "振り返るL", 6, -1.0, 1)
		at = 11
		wait_frames(70)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(0, "列車を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "列車を見るL", 0)
		at = 12
		wait_frames(120)
		event.set_camera_sequence_position(-704.28, 74.53, 644.02)
		event.set_camera_sequence_look_at(-229.0, 60.03, 630.45)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_handle_shadow_enabled(1, 0)
		at = 13
		wait_frames(60)
		event.set_camera_sequence_position(-272.98, 32.08, 611.38)
		event.set_camera_sequence_look_at(-292.01, 32.94, 630.57)
		event.set_object_sequence_rotation(0, 0.0, 1.93, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_motion(0, "キョロキョロ", 4, -1.0, 1)
		at = 14
		wait_frames(40)
		event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-344.7, 43.98, 674.78)
		event.set_camera_sequence_look_at(-270.62, 44.19, 558.35)
		event.set_object_sequence_rotation(0, 0.0, 1.69, 0.0)
		event.set_object_sequence_position(1, -57.93, 11.86, 130.81)
		event.set_object_sequence_rotation(1, 0.0, -1.55, 0.0)
		do
			local out1, out2, out3 = event.get_object_handle_position(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_z = vm.f32(pos_z + vm.f32(-517.642))
		event.set_object_sequence_position(4, pos_x - 50.0, pos_y, pos_z)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.08726647)
		event.play_sound_effect(var0, 9)
		event.rotate_object_sequence(8, 0.0, -1.57, 0.0, 30)
		event.rotate_object_sequence(7, 0.0, 1.57, 0.0, 30)
		event.rotate_object_sequence(24, 0.0, -1.57, 0.0, 30)
		event.rotate_object_sequence(23, 0.0, 1.57, 0.0, 30)
		event.set_object_sequence_motion(0, "左を見る", 6)
		event.queue_object_sequence_next_motion(0, "左を見るL", 0)
		at = 15
		wait_frames(30)
		at = 16
		wait_frames(30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 15)
		event.add_object_sequence_path_point(1, -58.2, 12.83, 120.56)
		event.add_object_sequence_path_point(1, -71.49, 12.83, 120.23)
		event.start_object_sequence_path(1)
		at = 17
		wait_frames(15)
		event.set_object_sequence_position(4, pos_x, pos_y, pos_z)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(24, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(23, 0.0, 0.0, 0.0)
		event.set_character_active(1, 0)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-429.29, 148.18, 653.31)
		event.set_camera_sequence_look_at(-322.93, 59.6, 619.28)
		event.set_object_sequence_rotation(0, 0.0, 2.65, 0.0)
		event.set_object_sequence_position(1, -223.19, 13.78, 510.23)
		event.set_object_sequence_rotation(1, 0.0, -0.5, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -268.59, 13.78, 585.68, 75)
		at = 18
		wait_frames(75)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_camera_sequence_position(-291.41, 39.19, 607.31)
		event.set_camera_sequence_look_at(-299.71, 35.93, 634.94)
		event.set_object_handle_shadow_enabled(0, 1)
		event.set_object_handle_shadow_enabled(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "きらきら目")
		event.set_object_sequence_motion(0, "会話", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 19
		helper_4116e6bb(2020040)
		event.reset_mouth_texture_animations()
		at = 20
		wait_objects(0)
		event.set_camera_sequence_position(-315.4, 36.86, 675.88)
		event.set_camera_sequence_look_at(-291.69, 35.93, 632.9)
		event.set_object_sequence_rotation(0, 0.0, 2.29, 0.0)
		event.set_object_sequence_position(1, -271.9, 13.78, 616.69)
		event.set_object_sequence_rotation(1, 0.0, -0.98, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "腰に手", 6)
		event.queue_object_sequence_next_motion(1, "腰に手L", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 21
		helper_4116e6bb(2020050)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "乗れ", 6)
		event.queue_object_sequence_next_motion(1, "乗れL", 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 22
		helper_4116e6bb(2020060)
		event.reset_mouth_texture_animations()
		at = 23
		wait_objects(1)
		event.set_camera_sequence_position(-264.17, 27.45, 662.14)
		event.set_camera_sequence_look_at(-203.38, 37.55, 662.68)
		event.set_object_sequence_position(0, -269.3, 13.77, 637.92)
		event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_sequence_position(1, -273.23, 13.77, 651.56)
		event.set_object_sequence_rotation(1, 0.0, 1.44, 0.0)
		at = 24
		helper_d77001f9(var0)
		event.set_character_active(0, 0)
		event.set_character_active(0, 9)
		at = 25
		helper_937d87bc(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
		helper_86ac6534(var0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_28d4ec9f()
			wait_frames_skipping(30)
		end
		if at <= 2 then
			wait_frames_skipping(90)
		end
		if at <= 3 then
			wait_frames_skipping(150)
		end
		if at <= 4 then
			helper_8cd371d7(2020010)
		end
		if at <= 5 then
			helper_8cd371d7(2020020)
		end
		if at <= 6 then
			wait_frames_skipping(15)
		end
		if at <= 7 then
			helper_8cd371d7(2020030)
		end
		if at <= 8 then
			wait_frames_skipping(10)
		end
		if at <= 9 then
			helper_24692f72(2200.0, 220)
			wait_frames_skipping(50)
		end
		if at <= 10 then
			wait_frames_skipping(70)
		end
		if at <= 11 then
			wait_frames_skipping(120)
		end
		if at <= 12 then
			wait_frames_skipping(60)
		end
		if at <= 13 then
			wait_frames_skipping(40)
		end
		if at <= 14 then
			pos_z = vm.f32(pos_z + vm.f32(-517.642))
			wait_frames_skipping(30)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			wait_frames_skipping(15)
		end
		if at <= 17 then
			wait_frames_skipping(75)
		end
		if at <= 18 then
			helper_8cd371d7(2020040)
		end
		if at <= 19 then
			helper_238b5abc(0)
		end
		if at <= 20 then
			helper_8cd371d7(2020050)
		end
		if at <= 21 then
			helper_8cd371d7(2020060)
		end
		if at <= 22 then
			helper_238b5abc(1)
		end
		if at <= 23 then
			helper_edf10af6(var0)
		end
		if at <= 24 then
			helper_fee84847(var0)
		end
		if at <= 25 then
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
			helper_86ac6534(var0)
		end
		return true
	end)
	at = 26
	vm.entry(26)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.stop_sound_effect(var0, 7)
	event.set_map_piece_character_motion("p01_train01", "kikan-m0", "停止")
	helper_18c31a0e()
	event.clear_effect_manager()
	event.reset_follow_camera(1, 0.0, 20.0)
end

return helper_bac19723
