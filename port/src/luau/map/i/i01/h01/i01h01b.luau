--!strict
-- map/i/i01/h01/i01h01b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0999bd0f = require("@lib/event/helper_0999bd0f")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3936899e = require("@lib/event/helper_3936899e")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_658b1052 = require("@lib/event/helper_658b1052")
local helper_662e1f81 = require("@lib/event/helper_662e1f81")
local helper_6918037c = require("@lib/event/helper_6918037c")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_86e93423 = require("@lib/event/helper_86e93423")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8e5b8087 = require("@lib/event/helper_8e5b8087")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_ddb81958 = require("@lib/event/helper_ddb81958")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_e768(arg0: any)
	local projection: f32 = 0
	event.set_camera_sequence_position(-13.56, 50.69, -99.84)
	event.set_camera_sequence_look_at(47.32, 59.3, -184.47)
	projection = event.get_event_projection() or projection
	event.set_event_projection(471.9)
	event.set_object_sequence_position(0, -17.08, -0.02, -207.87)
	event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_object_sequence_position(1, 34.05, -0.02, -143.69)
	event.set_object_sequence_rotation(1, 0.0, 2.73, 0.0)
	event.set_object_sequence_motion(1, "上を見るL", 4)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	event.move_camera_sequence_eased(-13.56, 18.54, -99.84, 47.32, 27.15, -184.47, 90, 2, 0.4)
	wait_camera()
	event.set_object_sequence_motion(0, "歩き", 0)
	event.move_object_sequence(0, 8.7, -0.02, -189.32, 45)
	event.rotate_object_sequence(0, 0.0, 0.3, 0.0, 45)
	event.move_object_sequence(0, 16.96, -0.02, -159.01, 45)
	wait_objects(0)
	event.rotate_object_sequence(0, 0.0, 1.74, 0.0, 10)
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	wait_objects(0)
	helper_888ab2a3(10)
	event.set_event_projection(projection)
end

--- Helper function.
local function helper_eea4(se_id: s32)
	event.set_camera_sequence_position(113.96, 46.95, -138.53)
	event.set_camera_sequence_look_at(50.9, 27.15, -165.35)
	event.set_object_sequence_rotation(0, 0.0, 2.34, 0.0)
	event.set_object_sequence_motion(0, "スティーブ見L", 4)
	event.set_object_sequence_motion(1, "腕組み", 4)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(1, "左を見る", 2)
	event.queue_object_sequence_next_motion(1, "左を見るL")
	helper_888ab2a3(9)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050010)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "うなづく（スティーブ）", 2)
	event.queue_object_sequence_next_motion(0, "スティーブ見L")
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1050020)
	event.reset_mouth_texture_animations()
	wait_objects(0)
	event.set_object_sequence_motion(0, "右を見る", 2)
	event.queue_object_sequence_next_motion(0, "右を見るL")
	helper_888ab2a3(9)
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1050030)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050040)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050050)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "アトラミリアをさわる", 6)
	event.queue_object_sequence_next_motion(0, "アトラミリアをさわるL")
	helper_888ab2a3(24)
	event.play_sound_effect(se_id, 2)
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1050060)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050065)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_f6d0(arg0: any)
	event.set_camera_sequence_position(-17.27, 17.65, -125.13)
	event.set_camera_sequence_look_at(49.66, 25.36, -167.46)
	event.set_object_sequence_position(0, 16.96, -0.02, -159.01)
	event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
	event.set_object_sequence_motion(0, "スティーブ見L", 4)
	event.set_object_sequence_position(1, 29.23, -0.02, -141.02)
	event.set_object_sequence_rotation(1, 0.0, 2.13, 0.0)
	event.set_object_sequence_motion(1, "腕組み", 4)
	helper_888ab2a3(9)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050070)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050071)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(0, "わらい口パク")
	helper_4116e6bb(1050080)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050090)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "右を見る", 6)
	event.queue_object_sequence_next_motion(0, "右を見るL")
	event.set_mouth_texture_animations(0, "わらい口パク")
	helper_4116e6bb(1050100)
	event.reset_mouth_texture_animations()
	wait_objects(0)
	event.set_object_sequence_motion(1, "左を見る", 2)
	event.queue_object_sequence_next_motion(1, "左を見るL")
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050110)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.set_object_sequence_motion(0, "右を見る会話", 6)
	event.queue_object_sequence_next_motion(0, "右を見るL")
	event.set_mouth_texture_animations(0, "わらい口パク")
	helper_4116e6bb(1050120)
	event.reset_mouth_texture_animations()
	wait_objects(0)
end

--- Helper function.
local function helper_ff38(se_id: s32)
	event.set_camera_sequence_position(-18.7, 18.74, -162.67)
	event.set_camera_sequence_look_at(41.67, 24.32, -147.28)
	event.set_object_sequence_rotation(0, 0.0, 0.9, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_object_sequence_rotation(1, 0.0, -2.23, 0.0)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	helper_4116e6bb(1050130)
	helper_888ab2a3(50)
	event.set_object_sequence_motion(1, "腰に手会話", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050140)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(0, "ガッツポーズ", 6)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	event.delay_object_sequence_motion_track(1, 18)
	event.set_object_sequence_motion(1, "うなづく", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L")
	helper_4116e6bb(1050150)
	wait_objects(0)
	event.set_object_sequence_motion(1, "腰に手会話", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050160)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.play_sound_effect(se_id, 4)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1050170)
	event.reset_mouth_texture_animations()
	wait_objects(0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050180)
	event.reset_mouth_texture_animations()
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
end

--- Helper function.
local function helper_10830(se_id: s32)
	event.set_camera_sequence_position(-23.06, 16.81, -167.38)
	event.set_camera_sequence_look_at(22.88, 29.55, -159.05)
	event.set_object_sequence_rotation(1, 0.0, -2.35, 0.0)
	event.set_character_active(0, 0)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(3, 128.0, 128.0, 128.0, 128.0, 10)
	helper_888ab2a3(10)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050190)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050200)
	event.reset_mouth_texture_animations()
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 1)
	event.set_object_sequence_color(4, 128.0, 128.0, 128.0, 128.0, 30)
	helper_888ab2a3(10)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050210)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050211)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050212)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050213)
	event.reset_mouth_texture_animations()
	event.set_event_sprite_draw_pass(1, 0)
	event.move_camera_sequence(-2.41, 23.65, -165.23, 57.71, 27.49, -130.12, 28)
	wait_camera()
	event.set_object_sequence_motion(1, "カメラを出す", 6)
	event.queue_object_sequence_next_motion(1, "カメラを出すL")
	helper_8e5b8087(32, vm.f32(0.206), -1.0, 20)
	event.play_sound_effect(se_id, 5)
	event.set_character_active(1, 33)
	event.attach_character_to_frame(32, "camera_sta", 33)
	helper_8e5b8087(32, vm.f32(0.956), -1.0, 20)
	helper_6918037c(32)
	event.play_sound_effect(se_id, 6)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050220)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050230)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050240)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050241)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_11388(se_id: s32, se_id_2: s32)
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
		"[(!)]カメラを手に入れた。\n   アイテムメニューで「そうび」して\n   (#)ボタンで使えるぞ。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]ダンジョン内では、アクティブアイテムの\n   カーソルがカメラに合っていないと使えません。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
	event.play_music(0)
end

--- Helper function.
local function helper_119dc(arg0: any)
	event.detach_character_from_frame(33)
	event.set_character_active(0, 33)
	event.set_camera_sequence_position(-33.79, 30.18, -157.21)
	event.set_camera_sequence_look_at(24.92, 17.88, -150.76)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_object_handle_visible(1, 1)
	event.set_object_handle_visible(2, 0)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050250)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050260)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(1, "会話2", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050261)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.set_object_sequence_motion(1, "立ち")
	wait_objects(1)
	helper_888ab2a3(10)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.wait_object_sequence_motion_end(0)
	wait_objects(0)
	helper_888ab2a3(15)
end

--- Helper function.
local function helper_11fcc()
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
		event.load_message_file(0, 5, "event/e100/e105/e105a.txt")
		event.stop_music(0)
		helper_888ab2a3(4)
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
		helper_e768(var0)
		helper_eea4(var0)
		helper_f6d0(var0)
		helper_ff38(var0)
		helper_10830(var0)
		helper_11388(var0, var1)
		helper_119dc(var0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
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
	helper_888ab2a3(4)
	event.load_music(46)
	event.play_music(0)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.set_event_projection(projection)
	event.set_object_handle_footstep_sound(0, 0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_13634(projection: f32, se_id: s32)
	event.set_event_projection(projection)
	event.set_camera_sequence_position(-15.15, 22.51, -151.72)
	event.set_camera_sequence_look_at(32.49, 27.39, -162.95)
	event.set_character_active(0, 0)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, -2.04, 0.0)
	event.set_object_sequence_motion(1, "手に腰L", 4)
	helper_888ab2a3(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_object_sequence_texture_animation(1, 1, "目とじ")
	event.set_object_sequence_motion(1, "下を見る", 2)
	event.queue_object_sequence_next_motion(1, "下を見るL")
	helper_888ab2a3(10)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050290)
	event.reset_mouth_texture_animations()
	event.set_character_active(0, 25)
	event.start_crossfade(0, 0, 30)
	event.set_event_sprite_draw_pass(0, 2)
	event.set_object_sequence_color(2, 128.0, 128.0, 128.0, 128.0, 0)
	helper_888ab2a3(30)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050291)
	event.reset_mouth_texture_animations()
	wait_objects(1)
	event.start_crossfade(30)
	event.set_object_sequence_color(2, 0.0, 0.0, 0.0, 0.0, 30)
	event.set_event_sprite_draw_pass(1, 2)
	event.set_object_sequence_color(3, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_object_sequence_texture_animation(1, 0)
	event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
	event.set_object_sequence_texture_animation(1, 1, "目パチ")
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "上を見る", 2)
	event.queue_object_sequence_next_motion(1, "上を見るL")
	helper_888ab2a3(16)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050300)
	event.reset_mouth_texture_animations()
	event.start_crossfade(30)
	event.set_object_sequence_color(3, 0.0, 0.0, 0.0, 30)
	event.set_event_sprite_draw_pass(2, 2)
	event.set_object_sequence_color(4, 128.0, 128.0, 128.0, 128.0, 30)
	event.set_object_sequence_color(3, 0.0, 0.0, 0.0, 0.0, 30)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(1, "頭をかく", 2)
	event.queue_object_sequence_next_motion(1, "頭をかくL")
	helper_888ab2a3(28)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_ddb81958(1050310, 32, se_id, 4, vm.f32(0.15))
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_ddb81958(1050320, 32, se_id, 4, vm.f32(0.15))
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_ddb81958(1050321, 32, se_id, 4, vm.f32(0.15))
	event.reset_mouth_texture_animations()
	event.set_character_active(0, 32)
	event.start_crossfade(30)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
end

--- Helper function.
local function helper_14444(arg0: any, arg1: any)
	event.set_camera_sequence_position(-38.62, 34.71, -174.94)
	event.set_camera_sequence_look_at(37.54, 15.45, -157.32)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, 16.25, -0.02, -166.37)
	event.set_object_sequence_rotation(0, 0.0, 1.16, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_character_active(1, 32)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	event.set_character_active(1, 25)
	helper_888ab2a3(30)
	event.set_mouth_texture_animations(1, "通常口パク")
	helper_4116e6bb(1050330)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_147ac()
	local var0: s32 = 0
	local projection: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(105, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(4, 1225) or var0
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
		event.load_character_motion_pack(5, "event/e100/e105/e105_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 72.86, 57.47, 35.39)
		event.load_character(5, "event/e100/e105/e105_starbre.gltf", "info", 32)
		event.set_character_active(1, 32)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 67.74, -59.99, 63.26)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		block = event.load_event_image_4(5, "textures/event/e100/e105/e105b_2d.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e105b_2d01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_alpha_blend(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e105b_2d02", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_alpha_blend(1, 0)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e105b_2d03", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_alpha_blend(2, 0)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_message_file(0, 5, "event/e100/e105/e105b.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		helper_13634(projection, var0)
		helper_14444(projection, var0)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.set_character_active(1, 0)
	event.set_character_active(1, 25)
	event.set_event_projection(projection)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_15a7c(arg0: any)
	event.set_camera_sequence_position(-33.29, 24.37, -167.32)
	event.set_camera_sequence_look_at(40.27, 15.44, -159.28)
	event.set_object_sequence_position(0, 18.58, -1.12, -168.14)
	event.set_object_sequence_rotation(0, 0.0, 0.92, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, -2.16, 0.0)
	helper_888ab2a3(20)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	helper_888ab2a3(15)
	event.set_object_sequence_motion(1, "会話2", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 0)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050340)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050341)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050350)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_16004(se_id: s32)
	event.set_camera_sequence_position(50.99, 20.54, -99.77)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_object_sequence_position(0, 59.55, -1.12, -135.97)
	event.set_object_sequence_rotation(0, 0.0, -2.24, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, 0.72, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_position(2, 62.85, 11.43, -176.07)
	event.set_object_sequence_rotation(2, 0.0, -0.72, 0.0)
	helper_888ab2a3(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "ガッツポーズ", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050360)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_1655c(arg0: any)
	local block: s32 = 0
	event.clear_camera_sequence()
	event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_camera_sequence_position(91.52, 19.06, -115.56)
	event.set_camera_sequence_look_at(36.75, 33.39, -130.18)
	event.set_character_active(0, 0)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	block = event.load_event_image_4(5, "textures/event/e100/e105/e105c_2d.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e105c_2d01", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_alpha_blend(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	helper_888ab2a3(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 10)
	helper_888ab2a3(30)
	event.set_object_sequence_motion(1, "腰に手会話", 4)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050370)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050380)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050390)
	event.reset_mouth_texture_animations()
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

--- Helper function.
local function helper_16dcc(se_id: s32)
	event.set_camera_sequence_position(16.09, 22.59, -109.83)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, 55.27, -1.12, -130.46)
	event.set_object_sequence_rotation(0, 0.0, -2.24, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "立ち", 4)
	helper_888ab2a3(15)
	event.play_sound_effect(se_id, 3)
	event.set_object_sequence_motion(1, "お金をやる", 6)
	event.queue_object_sequence_next_motion(1, "お金をやるL")
	helper_888ab2a3(14)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050400)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 4)
	event.set_object_sequence_motion(0, "お金をもらう", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "お金をもらうL")
	helper_888ab2a3(60)
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(0, "４００ギルダを手に入れた。")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
	event.set_object_sequence_motion(1, "お金をやる戻り", 6)
	event.queue_object_sequence_next_motion(1, "立ち")
	wait_objects(1)
end

--- Helper function.
local function helper_17520(se_id: s32)
	event.set_camera_sequence_position(35.49, 25.34, -101.59)
	event.set_camera_sequence_look_at(50.2, 23.69, -140.94)
	event.set_object_sequence_position(0, 59.55, -1.12, -135.97)
	event.set_object_sequence_rotation(0, 0.0, -2.0, 0.0)
	event.set_object_sequence_motion(0, "スターブル見L", 4)
	event.set_object_sequence_position(1, 38.77, -0.02, -147.68)
	event.set_object_sequence_rotation(1, 0.0, 0.96, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4)
	event.set_object_sequence_position(2, 62.85, 11.43, -176.07)
	event.set_object_sequence_rotation(2, 0.0, -0.72, 0.0)
	helper_888ab2a3(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	helper_888ab2a3(10)
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "ガッツポーズ", 6)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050420)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050421)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050430)
	event.reset_mouth_texture_animations()
	event.reset_object_sequence_motion(1)
end

--- Helper function.
local function helper_17b9c(se_id: s32)
	event.set_camera_sequence_position(-13.13, 19.21, -128.25)
	event.set_camera_sequence_look_at(60.53, 17.71, -147.9)
	event.set_object_sequence_position(0, 77.34, -0.02, -128.37)
	event.set_object_sequence_rotation(0, 0.0, -1.94, 0.0)
	event.set_object_sequence_motion(0, "バックパック歩き", 4, -1.0, 1)
	event.set_object_sequence_position(1, 24.24, -0.02, -152.65)
	event.set_object_sequence_rotation(1, 0.0, 0.93, 0.0)
	event.set_object_sequence_position(2, 62.85, 11.43, -176.07)
	event.set_object_sequence_rotation(2, 0.0, -0.72, 0.0)
	event.attach_character_to_frame(0, "ef00", 35)
	event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(4, 0.0, 1.12, 0.0)
	event.set_character_active(0, 24)
	event.fade_in_screen(15)
	event.move_object_sequence(0, 58.55, -0.02, -130.49, 35)
	wait_objects(0)
	event.set_object_sequence_motion(0, "バックパック持ち")
	helper_888ab2a3(15)
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1050440)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(1, "ガッツポーズ", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050450)
	event.reset_mouth_texture_animations()
	event.set_object_sequence_motion(0, "バックパックを置く", 2)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	for var1 = 0, 41 do
		if var1 == 12 then
			event.play_sound_effect(se_id, 5)
			event.detach_character_from_frame(35)
			event.set_object_sequence_position(4, 44.54, 6.47, -135.54)
		end
		helper_888ab2a3(1)
	end
	event.set_object_sequence_texture_animation(0, 1, "ためいき")
	helper_888ab2a3(70)
	event.set_object_sequence_texture_animation(0, 0)
	event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
	event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
	event.set_object_sequence_motion(1, "腰に手", 2)
	event.queue_object_sequence_next_motion(1, "腰に手L")
	helper_888ab2a3(14)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050460)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(0, "うなづく", 6)
	event.reset_object_sequence_dynamic_animation(0)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	helper_888ab2a3(10)
	event.set_mouth_texture_animations(0, "通常口パク")
	helper_4116e6bb(1050470)
	event.reset_mouth_texture_animations()
	helper_888ab2a3(10)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050480)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050490)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050491)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 7)
	event.set_object_sequence_motion(0, "ガッツポーズ", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(0, "スターブル見L")
	event.set_mouth_texture_animations(0, "わらい口パク")
	helper_4116e6bb(1050500)
	event.reset_mouth_texture_animations()
	event.play_sound_effect(se_id, 6)
	event.set_object_sequence_motion(1, "うなづく", 6)
	event.queue_object_sequence_next_motion(1, "腰に手L")
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050510)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_18d28(se_id: s32, se_id_2: s32)
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
	helper_888ab2a3(30)
	event.play_sound_effect(se_id_2, 0)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	helper_888ab2a3(15)
	event.play_sound_effect(se_id, 8)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050520)
	event.reset_mouth_texture_animations()
	var2 = event.get_message_window_frame(0) or var2
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]メインメニューの『キャラクター』でライドポッドを\n   選択すれば、乗り込むことができるぞ。\n   また、(R)を押し込むことでもチェンジできる。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, var2)
end

--- Helper function.
local function helper_19648(arg0: any)
	event.set_camera_sequence_position(51.28, 21.78, -97.62)
	event.set_camera_sequence_look_at(50.16, 19.92, -141.52)
	event.set_object_sequence_position(0, 58.4, -0.02, -135.54)
	event.set_object_sequence_rotation(0, 0.0, -2.3, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_object_sequence_position(1, 36.44, -0.02, -151.98)
	event.set_object_sequence_rotation(1, 0.0, 0.69, 0.0)
	event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
	event.set_character_position(25, 62.85, 11.43, -176.07)
	event.set_character_rotation(25, 0.0, -0.72, 0.0)
	helper_888ab2a3(15)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050530)
	event.reset_mouth_texture_animations()
end

--- Helper function.
local function helper_19aa8(arg0: s32)
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
		event.load_message_file(0, 5, "event/e100/e105/e105c.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.enable_drama_skip()
		if arg0 == 1 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_15a7c(var1)
		end
		if arg0 == 2 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_16004(var1)
			event.reset_object_sequence_dynamic_animation(0)
			helper_1655c(var1)
			event.reset_object_sequence_dynamic_animation(0)
			helper_16dcc(var1)
		end
		if arg0 == 3 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_1ef0d4b2()
		end
		if arg0 == 4 then
			event.reset_object_sequence_dynamic_animation(0)
			helper_17520(var1)
		end
		if arg0 == 5 then
			event.stop_music(0)
			event.reset_object_sequence_dynamic_animation(0)
			helper_17b9c(var1)
			event.reset_object_sequence_dynamic_animation(0)
			helper_18d28(var1, var2)
			event.reset_object_sequence_dynamic_animation(0)
			helper_19648(var1)
		end
	end)
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	helper_888ab2a3(30)
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
	helper_11fcc()
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
	helper_d61bc810(1)
	vm.wait(3)
	event.load_event_script("i01h01/i01h01.stb", -1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(10, 0.0, 0.0, 0.0)
		at = 1
		helper_888ab2a3(10)
		helper_86e93423()
		at = 2
		helper_147ac()
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
		event.load_event_script("i01h01/i01h01.stb", -1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_147ac()
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
					event.load_event_script("i01h01/i01h01.stb", -1)
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
		helper_888ab2a3(30)
		helper_86e93423()
		flag = event.get_save_flag(13) or flag
		if flag == 1 then
			at = 2
			helper_19aa8(5)
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
			event.load_event_script("i01h01/i01h01.stb", -1)
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
						helper_19aa8(4)
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
						event.load_event_script("i01h01/i01h01.stb", -1)
						return
					end
				else
					event.fade_in_screen(0)
					event.set_villager_ai_enabled(0, 24)
					event.open_message_window_2(
						0,
						"何をしておる。\nアイテム屋は、うちの目の前じゃ。\n早く買ってくるのじゃ。"
					)
					at = 7
					helper_1c04a0eb(24, -1, 0, 0)
					event.set_villager_ai_enabled(1, 24)
					at = 8
					vm.wait(8)
					event.load_event_script("i01h01/i01h01.stb", -1)
				end
			else
				var0 = event.has_invention_ideas(165) or var0
				if var0 == 1 then
					argc_4 = event.is_invention_created(165) or argc_4
					if argc_4 ~= -1 then
						event.set_save_flag(19, 1)
						event.add_money(400)
						at = 9
						helper_19aa8(2)
						helper_658b1052()
						event.set_villager_ai_enabled(0, 24)
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, 0.72, 0.0)
						event.set_character_motion(24, "立ち")
						at = 10
						vm.wait(10)
						event.set_villager_ai_enabled(1, 24)
						event.load_event_script("i01h01/i01h01.stb", -1)
						return
					else
						at = 11
						helper_19aa8(1)
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
						event.load_event_script("i01h01/i01h01.stb", -1)
						return
					end
				else
					at = 13
					vm.wait(13)
					event.load_event_script("i01h01/i01h01c.stb", 500)
					return
				end
			end
		end
		event.fade_in_screen(15)
		event.open_message_window_2(0, "ユリス、バイトをサボるんじゃないぞ。\nわかったな！")
		at = 14
		helper_1c04a0eb(24, -1, 0, 0)
		at = 15
		vm.wait(15)
		event.load_event_script("i01h01/i01h01.stb", -1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_19aa8(5)
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
					event.load_event_script("i01h01/i01h01.stb", -1)
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
				helper_19aa8(2)
				return vm.continue_with(function()
					helper_658b1052()
					event.set_villager_ai_enabled(0, 24)
					event.set_character_position(24, 38.77, -0.02, -147.68)
					event.set_character_rotation(24, 0.0, 0.72, 0.0)
					event.set_character_motion(24, "立ち")
					at = 10
					vm.wait(10)
					event.set_villager_ai_enabled(1, 24)
					event.load_event_script("i01h01/i01h01.stb", -1)
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
	helper_19aa8(2)
	vm.wait(2)
	event.load_event_script("i01h01/i01h01.stb", -1)
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
		helper_888ab2a3(30)
		helper_86e93423()
		argc_2 = event.get_item_count(165) or argc_2
		if argc_2 >= 1 then
			at = 2
			helper_19aa8(5)
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
			event.load_event_script("i01h01/i01h01.stb", -1)
			return
		end
		argc_3 = event.get_item_count(224) or argc_3
		argc_4 = event.get_item_count(245) or argc_4
		argc_5 = event.get_item_count(227) or argc_5
		if argc_3 >= 20 and argc_4 >= 1 and argc_5 >= 2 then
			at = 5
			helper_19aa8(4)
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
			event.load_event_script("i01h01/i01h01.stb", -1)
			return
		end
		argc = event.is_invention_created(165) or argc
		if argc ~= -1 then
			at = 8
			helper_19aa8(2)
			event.set_villager_ai_enabled(0, 24)
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, 0.72, 0.0)
			event.set_character_motion(24, "立ち")
			at = 9
			vm.wait(9)
			event.set_villager_ai_enabled(1, 24)
			at = 10
			vm.wait(10)
			event.load_event_script("i01h01/i01h01.stb", -1)
			return
		end
		if argc == -1 then
			at = 11
			helper_19aa8(1)
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
			event.load_event_script("i01h01/i01h01.stb", -1)
			return
		end
		event.fade_in_screen(30)
		at = 14
		vm.wait(14)
		event.load_event_script("i01h01/i01h01.stb", -1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				helper_19aa8(5)
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
					event.load_event_script("i01h01/i01h01.stb", -1)
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
