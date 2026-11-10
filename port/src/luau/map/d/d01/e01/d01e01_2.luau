--!strict
-- map/d/d01/e01/d01e01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_01df4541 = require("@lib/event/helper_01df4541")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2a9040b5 = require("@lib/event/helper_2a9040b5")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_3e3b0d3f = require("@lib/event/helper_3e3b0d3f")
local helper_68ec7c8d = require("@lib/event/helper_68ec7c8d")
local helper_6955414c = require("@lib/event/helper_6955414c")
local helper_87adbdbf = require("@lib/event/helper_87adbdbf")
local helper_8ab07f4b = require("@lib/event/helper_8ab07f4b")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_aaaef248 = require("@lib/event/helper_aaaef248")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_ad047ca5 = require("@lib/event/helper_ad047ca5")
local helper_be16759c = require("@lib/event/helper_be16759c")
local helper_c0be7979 = require("@lib/event/helper_c0be7979")
local helper_d05dd9db = require("@lib/event/helper_d05dd9db")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3edc4()
	local var0: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.fade_out_screen(30)
		wait_frames(30)
		event.initialize_event()
		event.enable_drama_skip()
		set_window_mode(0, 7)
		event.set_event_projection(618.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		var0 = event.load_sound_effect_file_2(1800) or var0
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var1
		event.load_message_file(0, 5, "event/opening/p6/op6_1.txt")
		event.delete_event_image(0)
		block = event.load_event_image_4(5, "textures/event/opening/p6/op06.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "op0601", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "op0602", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_alpha_blend(1, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.attach_object_handle_to_sprite(11, 1)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "op0603", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_alpha_blend(2, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.attach_object_handle_to_sprite(12, 2)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.delete_character_extension_packs(0)
		event.load_character_motion_pack(5, "event/opening/p6/p6_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 103.83, 104.0, 195.7)
		event.set_object_sequence_rotation(0, 0.0, 0.85, 0.0)
		event.set_object_sequence_motion(0, "考えポーズL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "考える目")
		event.set_object_sequence_texture_animation(0, 1, "考える口")
		event.set_character_active(8)
		event.attach_object_handle_to_character(1, 8)
		event.set_object_handle_footstep_sound(1, 3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 124.7, 104.0, 183.68)
		event.set_object_sequence_rotation(1, 0.0, 0.85, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "口閉じ")
		event.load_item_model(5, 1, "info", 10)
		event.set_character_active(0, 10)
		event.attach_character_to_frame(0, "ef00", 10)
		event.load_item_model(5, 22, "info", 11)
		event.set_character_active(0, 11)
		event.attach_character_to_frame(8, "donnie_gun", 11)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(2, 12)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 110.0, 135.89, 193.52)
		event.set_object_sequence_rotation(2, 0.0, 0.6, 0.0)
		event.set_object_sequence_motion(2, "発動", 5)
		event.load_item_model(5, 359, "info", 13)
		event.set_character_position(13, 0.0, 0.0, 0.0)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.set_character_active(0, 13)
		event.attach_character_to_frame(8, "donnie_receiver", 13)
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		event.set_camera_sequence_position(103.9, 126.98, 225.65)
		event.set_camera_sequence_look_at(112.72, 126.94, 179.57)
		event.set_object_sequence_motion(0, "ななめ前を見る", 6)
		event.queue_object_sequence_next_motion(0, "ななめ前を見るL", 4)
		event.set_object_sequence_motion(1, "ミンツを見る", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目")
		vm.wait(3)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60210, -1, 10)
		event.reset_mouth_texture_animations()
		wait_objects(0)
		event.set_object_sequence_position(0, 103.83, -100.0, 195.7)
		event.set_camera_sequence_position(112.75, 131.05, 198.49)
		event.set_camera_sequence_look_at(163.01, 122.54, 302.27)
		event.move_camera_sequence(112.75, 131.05, 198.49, 87.37, 110.42, 341.57, 180)
		helper_1584c528(60220, 80)
		helper_1584c528(60230, 70)
		wait_camera()
		event.set_camera_sequence_position(124.82, 125.36, 251.04)
		event.set_camera_sequence_look_at(105.61, 114.01, 150.82)
		event.set_object_sequence_position(0, 103.83, 104.0, 195.7)
		event.set_object_sequence_motion(0, "考えポーズ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "考えポーズL", 4)
		wait_frames(60)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60240, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60250, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60260, -1, 10)
		event.set_object_sequence_motion(0, "ドニーを見る", 2)
		event.queue_object_sequence_next_motion(0, "ドニーを見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60270, -1, 10)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60280, -1, 10)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(0, "ドニーを見る会話", 2)
		event.queue_object_sequence_next_motion(0, "ドニーを見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60290, -1, 10)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60300, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60305, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_color(10, 128, 128, 128, 0, 30)
		event.set_object_sequence_motion(0, "考えポーズL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60310, -1, 10)
		event.set_event_sprite_draw_pass(0, 0)
		wait_objects(0)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60320, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60330, -1, 10)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60340, -1, 10)
		event.set_object_sequence_color(11, 128, 128, 128, 0, 30)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(12, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60350, -1, 10)
		event.set_object_sequence_color(12, 128, 128, 128, 0, 30)
		wait_frames(30)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_object_sequence_motion(1, "ミンツを見る戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60360, -1, 10)
		wait_objects(1)
		event.set_object_sequence_motion(0, "左を向く", 2)
		event.queue_object_sequence_next_motion(0, "左を向くL")
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60370, -1, 10)
		wait_objects(0)
		event.set_object_sequence_motion(1, "ミンツを見る", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60380, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60385, -1, 10)
		wait_objects(1)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60390, -1, 10)
		wait_objects(0)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60400, -1, 10)
		event.set_object_sequence_motion(1, "ミンツを見るL")
		event.set_object_sequence_motion(0, "工具を出す", 2)
		event.queue_object_sequence_next_motion(0, "工具を出すL", 6)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "武器おろし", 6)
		event.queue_object_sequence_next_motion(0, "武器おろしL", 4)
		event.play_object_sequence_sound(0, var0, 11)
		wait_frames(10)
		event.set_character_active(10)
		event.delay_object_sequence_texture_animation_track(1, 25)
		event.set_object_sequence_texture_animation(1, 1, "イィッ")
		event.set_object_sequence_texture_animation(0, 0, "真剣口")
		vm.wait(36)
		event.set_mouth_texture_animations(0, "通常口パク", "得意口")
		helper_0e75aa9e(60410, -1, 10)
		wait_objects(0)
		event.set_object_sequence_texture_animation(0, 0, "得意口")
		event.set_object_sequence_texture_animation(0, 1, "真剣口")
		event.set_object_sequence_texture_animation(1, 0, "イィッ")
		wait_frames(20)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60430, -1, 10)
		event.set_object_sequence_motion(1, "ミンツを見る戻り", 6)
		event.wait_object_sequence_motion_end(1)
		wait_objects(1)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, 112.5, 104.0, 138.09, 25)
		event.rotate_object_sequence(1, 0.0, -2.91, 0.0, 10)
		wait_frames(15)
		wait_objects(1)
		event.set_object_handle_footstep_sound(1, 2)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, 112.5, 104.0, 138.09)
		event.add_object_sequence_path_point(1, 101.97, 104.0, 102.83)
		event.add_object_sequence_path_point(1, 89.86, 104.0, 69.5)
		event.add_object_sequence_path_point(1, 68.34, 104.0, 21.46)
		event.add_object_sequence_path_point(1, 31.72, 104.0, -50.16)
		event.add_object_sequence_path_point(1, 5.79, 104.0, -85.32)
		event.add_object_sequence_path_point(1, -6.62, 104.0, -126.94)
		event.add_object_sequence_path_point(1, 2.98, 104.0, -174.2)
		event.add_object_sequence_path_point(1, 8.78, 104.0, -191.0)
		event.add_object_sequence_path_point(1, 10.66, 104.0, -225.67)
		event.start_object_sequence_path(1)
		event.set_object_sequence_motion(0, "後ろを向く", 2)
		wait_frames(80)
		wait_frames(20)
		wait_objects(0)
		wait_objects(1)
		event.start_crossfade(60)
		event.set_object_sequence_motion(0, "待ちくたびれ", 4, -1, 1)
		event.set_character_active(11)
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(140.01, 119.16, 248.76)
		event.set_camera_sequence_look_at(99.95, 120.89, 177.35)
		event.set_object_sequence_rotation(0, 0.0, 0.73, 0.0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, 10.66, 104.0, -225.67)
		event.add_object_sequence_path_point(1, 8.78, 104.0, -191.0)
		event.add_object_sequence_path_point(1, 2.98, 104.0, -174.2)
		event.add_object_sequence_path_point(1, -6.62, 104.0, -126.94)
		event.add_object_sequence_path_point(1, 5.79, 104.0, -85.32)
		event.add_object_sequence_path_point(1, 31.72, 104.0, -50.16)
		event.add_object_sequence_path_point(1, 68.34, 104.0, 21.46)
		event.add_object_sequence_path_point(1, 89.86, 104.0, 69.5)
		event.add_object_sequence_path_point(1, 101.97, 104.0, 102.83)
		event.add_object_sequence_path_point(1, 112.5, 104.0, 138.09)
		event.start_object_sequence_path(1)
		wait_frames(100)
		event.set_object_handle_footstep_sound(1, 3)
		wait_objects(1)
		event.move_object_sequence(1, 114.43, 104.0, 184.04, 25)
		event.rotate_object_sequence(1, 0.0, -0.78, 0.0, 25)
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち", 2)
		event.queue_object_sequence_next_motion(1, "銃を渡す", 6)
		event.wait_object_sequence_motion_end(1)
		event.delay_object_sequence_sound_track(1, 60)
		event.play_object_sequence_sound(1, var0, 12)
		event.set_object_sequence_motion(0, "右向け右", 6)
		event.queue_object_sequence_next_motion(0, "右向け右L", 4)
		wait_objects(1)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60450, -1, 10)
		wait_objects(0)
		event.set_object_sequence_motion(0, "銃を受け取る", 2)
		event.delay_object_sequence_motion_track(0, 1)
		event.queue_object_sequence_next_motion(0, "銃を受け取るL", 6)
		event.queue_object_sequence_next_motion(0, "銃を受け取るL2", 4)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, var0, 13)
		wait_frames(20)
		event.detach_character_from_frame(11)
		event.attach_character_to_frame(0, "gun_hand", 11)
		wait_frames(20)
		event.set_object_sequence_motion(1, "銃を渡す戻り", 6)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60460, -1, 10)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60470, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60475, -1, 10)
		wait_objects(0)
		event.set_object_sequence_motion(0, "すごいよ", 6)
		event.queue_object_sequence_next_motion(0, "すごいよL", 4)
		event.set_object_sequence_texture_animation(0, 0, "真剣口")
		vm.wait(60)
		event.set_mouth_texture_animations(0, "通常口パク", "得意口")
		helper_0e75aa9e(60480, -1, 10)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60490, -1, 10)
		event.set_object_sequence_motion(1, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク", "得意口")
		helper_0e75aa9e(60500, -1, 10)
		wait_camera()
		wait_objects(0)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(136.41, 122.25, 229.2)
		event.set_camera_sequence_look_at(102.5, 130.77, 197.18)
		event.move_camera_sequence(123.15, 123.01, 222.97, 110.99, 134.65, 195.81, 120)
		event.set_music_volume(0)
		event.play_sound_effect(var1, 0)
		event.set_object_sequence_motion(0, "銃を掲げる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "銃を掲げるL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.play_object_sequence_sound(0, var0, 14)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, var0, 15)
		event.set_character_active(1, 12)
		event.set_object_sequence_motion(2, "発動", 6)
		event.wait_object_sequence_motion_end(2)
		wait_objects(2)
		event.set_character_active(0, 12)
		helper_f38eabca(22, 1)
		set_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Utilise [l1] pour te pr[UNI00e9]parer, (O)\n    pour attaquer. Si tu te mets trop loin,\n    tes attaques seront moins efficaces."
		)
		show_message(0, -1, 8, 0, 0)
		set_window_mode(0, 7)
		event.set_message_draw_speed(0, 0)
		wait_objects(0)
		event.set_music_volume(-1)
		event.set_object_sequence_texture_animation(0, 1, "真剣目")
		event.set_object_sequence_texture_animation(0, 1, "真剣口")
		event.set_character_active(0, 12)
		event.set_character_active(0, 11)
		event.set_camera_sequence_position(140.01, 119.16, 248.76)
		event.set_camera_sequence_look_at(99.95, 120.89, 177.35)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(1, 114.41, 103.98, 185.73)
		event.set_object_sequence_motion(0, "右向け右L", 4)
		event.set_object_sequence_normal_drive(0)
		event.reset_object_sequence_dynamic_animation(0)
		event.play_sound_effect(var0, 18)
		event.set_object_sequence_motion(1, "レシーバーをあげる", 6)
		event.queue_object_sequence_next_motion(1, "レシーバーをあげるL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60510, -1, 10)
		wait_objects(1)
		event.set_object_sequence_motion(0, "レシーバーをもらう", 6)
		event.queue_object_sequence_next_motion(0, "レシーバーをもらうL", 4)
		wait_frames(14)
		event.play_sound_effect(var0, 19)
		wait_objects(0)
		event.detach_character_from_frame(13)
		event.attach_character_to_frame(0, "ef00", 13)
		event.set_object_sequence_motion(0, "レシーバーを下ろす", 6)
		event.queue_object_sequence_next_motion(0, "レシーバーを下ろすL", 4)
		event.set_object_sequence_motion(1, "レシーバーをあげる戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60520, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60530, -1, 10)
		helper_f38eabca(359, 1)
		event.set_character_active(0, 13)
		event.set_camera_sequence_position(0.0, 174.49, 49.35)
		event.set_camera_sequence_look_at(0.0, 126.26, 245.83)
		event.set_object_sequence_position(0, 0.0, 48.0, 267.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 24.15, 104.0, 216.41)
		event.set_object_sequence_rotation(1, 0.0, -0.2, 0.0)
		event.set_object_sequence_motion(0, "はしご上立ち", 4)
		event.set_object_sequence_normal_drive(0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60540, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60550, -1, 10)
		event.set_camera_sequence_position(-104.06, 146.74, 477.55)
		event.set_camera_sequence_look_at(16.01, 86.26, 244.13)
		event.play_object_sequence_sound(0, var0, 16)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, var0, 17)
		event.set_object_sequence_motion(0, "飛び降りる", 6)
		event.wait_object_sequence_motion_end(0)
		wait_objects(0)
		event.set_camera_sequence_position(-45.88, 52.01, 341.35)
		event.set_camera_sequence_look_at(16.98, 101.86, 233.55)
		event.set_object_sequence_position(1, 7.1, 104.0, 227.78)
		event.set_object_sequence_rotation(1, 0.0, -0.08, 0.0)
		event.set_object_sequence_motion(1, "下を見るL", 4)
		event.set_object_sequence_motion(0, "振り返る", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		helper_0e75aa9e(60560, -1, 10)
		wait_objects(0)
		event.set_object_sequence_motion(0, "振り返る戻り", 6)
		event.wait_object_sequence_motion_end(0)
		wait_objects(0)
		event.set_object_sequence_motion(0, "走り2")
		event.move_object_sequence(0, 0.0, 48.0, 600.0, 140)
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "下を見る会話")
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_1584c528(60570, 200)
		event.set_camera_sequence_position(-15.79, 151.18, 139.2)
		event.set_camera_sequence_look_at(4.88, 115.54, 302.4)
		event.set_object_sequence_position(0, 0.0, 48.0, 400.0)
		event.move_object_sequence(0, 0.0, 48.0, 600.0, 60)
		helper_1584c528(60580, 50)
		wait_objects(0)
		event.set_camera_sequence_position(0.0, 61.0, 700.0)
		event.set_camera_sequence_look_at(0.0, 29.0, 850.0)
		event.set_object_handle_footstep_sound(0, 15)
		event.set_object_sequence_position(0, 0.0, 0.0, 750.0)
		event.move_object_sequence(0, 0.0, 0.0, 830.0, 30)
		event.reset_object_sequence_dynamic_animation(0)
		wait_objects(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		wait_frames(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-2.62, 29.33, 799.72)
		event.set_camera_sequence_look_at(-2.62, 22.33, 827.0)
		event.set_object_sequence_motion(0, "心配ないさ", 2)
		event.queue_object_sequence_next_motion(0, "心配ないさL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目パチ")
		vm.wait(88)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0e75aa9e(60590, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0e75aa9e(60595, -1, 10)
		wait_objects(0)
		event.set_object_sequence_motion(0, "心配ないさ戻り", 2)
		event.queue_object_sequence_next_motion(0, "旧･立ち", 4)
		wait_objects(0)
		wait_frames(6)
		event.move_object_sequence(0, 0.0, 0.0, 1230.0, 120)
		event.set_object_sequence_motion(0, "走り2")
		event.move_camera_sequence(-2.62, 26.75, 843.0, -2.62, 24.35, 939.2, 120)
		event.set_object_handle_footstep_sound(0, 15)
		wait_frames(14)
		event.set_object_handle_footstep_sound(0, 2)
		wait_frames(76)
		event.fade_out_music(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		wait_camera()
	end)
	vm.entry(97)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	event.set_object_handle_footstep_sound(0, 0)
end

--- Helper function.
local function helper_461bc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		set_window_mode(0, 7)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			var7 = out2 or var7
		end
		do
			local out1, out2, out3 = event.get_character_position(8)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		yaw = event.get_direction_angle(var0, var1, var2, var3, var4, var5) or yaw
		yaw_2 = event.get_direction_angle(var3, var4, var5, var0, var1, var2) or yaw_2
		var11 = event.compare_angles(var7, yaw, 0.1) or var11
		if var11 ~= 0 then
			event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "立ち")
		at = 1
		wait_frames(20)
		event.open_voice_stream_wave(1, 60180)
		at = 2
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, "Alors que vas-tu faire ?")
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		at = 3
		helper_0ffc2526(0, -1, 8, 0, 0)
		event.close_voice_stream(1)
		set_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.open_message_window_2(0, "Je vais rester cach[UNI00e9] un peu ici.\nLe Canal souterrain...")
		at = 4
		var12 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 0)
		set_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if var12 == 1 then
			event.close_voice_stream(1)
			at = 5
			helper_3edc4()
			return 1
		else
			event.open_voice_stream_wave(1, 60190)
			at = 6
			helper_9cbdc640(1)
			event.play_voice_stream(1)
			event.open_message_window_2(0, "Je vais rester cach[UNI00e9] un peu ici.")
			at = 7
			helper_0ffc2526(0, -1, 0, 8, 0)
			event.close_voice_stream(1)
			event.open_voice_stream_wave(1, 60200)
			at = 8
			helper_9cbdc640(1)
			event.play_voice_stream(1)
			event.open_message_window_2(0, "Restes-y tant que tu veux.")
			at = 9
			helper_0ffc2526(0, -1, 8, 0, 0)
			event.close_voice_stream(1)
		end
		event.rotate_object_sequence(1, 0.0, 0.85, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "立ち")
		at = 10
		wait_frames(11)
		return 0
	end, function(received: { any })
		if at <= 5 then
			if at == 4 then
				var12 = received[1] :: number
			end
			if at <= 1 then
				helper_238b5abc(1)
			end
			if at <= 2 then
				helper_be16759c(0, -1, 8, 0, 0)
			end
			if at <= 3 then
				helper_8ab07f4b(0, 1)
				var12 = helper_f8bbcc57(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 4 then
				helper_8ab07f4b(0, 7)
				at = 5
				helper_3edc4()
				return vm.continue_with(function()
					return 1
				end)
			end
			return 1
		end
		if at <= 10 then
			if at <= 6 then
				helper_be16759c(0, -1, 0, 8, 0)
			end
			if at <= 7 then
				helper_238b5abc(1)
			end
			if at <= 8 then
				helper_be16759c(0, -1, 8, 0, 0)
			end
			if at <= 9 then
				wait_frames_skipping(11)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_3bc74()
	local var0: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		set_window_mode(0, 7)
		event.set_event_projection(618.0)
		event.load_map_sounds(1800)
		event.stop_music(0)
		wait_frames(6)
		event.load_music(108)
		event.play_music(0)
		event.enable_drama_skip()
		var0 = event.load_sound_effect_file_2(1800) or var0
		helper_01df4541()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p6/op6_1.txt")
		event.delete_character_extension_packs(0)
		event.load_character_motion_pack(5, "event/opening/p6/p6_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 12)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -464.39, 100.52, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "はあはあ目")
		event.set_object_sequence_texture_animation(0, 1, "はあはあ口")
		event.set_character_active(8)
		event.attach_object_handle_to_character(1, 8)
		event.set_object_handle_footstep_sound(1, -1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, -443.0, 100.52, 8.0)
		event.set_object_sequence_rotation(1, 0.0, -1.57, 0.0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "口閉じ")
		event.open_voice_stream_wave(1, 60005)
		helper_9cbdc640(1)
		event.set_object_sequence_motion(0, "はしご降り", 6)
		event.set_object_sequence_motion(1, "はしご降り", 6)
		event.play_object_sequence_sound(1, var0, 8)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-173.98, 180.32, 173.33)
		event.set_camera_sequence_look_at(-478.87, 162.2, -4.22)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		wait_camera()
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, var0, 9)
		wait_frames(16)
		event.play_voice_stream(1)
		wait_frames(100)
		event.close_voice_stream(1)
		event.start_crossfade(60)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_camera_sequence_position(-383.51, 121.05, 34.45)
		event.set_camera_sequence_look_at(-455.56, 111.89, -1.44)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "はあはあL", 4, -1, 1)
		event.set_object_sequence_position(0, -447.2, 100.52, -9.2)
		event.set_object_sequence_rotation(0, 0.0, 0.47, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(1, -434.79, 100.52, 18.22)
		event.set_object_sequence_rotation(1, 0.0, -2.89, 0.0)
		wait_frames(20)
		helper_0e75aa9e(60010, -1, 10)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60020, -1, 10)
		event.set_object_sequence_motion(1, "立ち")
		helper_0e75aa9e(60030, -1, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "深呼吸目")
		event.set_object_sequence_texture_animation(0, 1, "深呼吸口")
		event.set_object_sequence_motion(0, "深呼吸", 6)
		event.queue_object_sequence_next_motion(0, "立ち2", 4)
		wait_frames(50)
		event.set_object_sequence_texture_animation(0, 0, "深呼吸口")
		event.set_mouth_texture_animations(0, "通常口パク", "デフォルト口")
		helper_0e75aa9e(60040, -1, 10)
		wait_objects(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目パチ")
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60050, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60055, -1, 10)
		event.set_object_sequence_motion(0, "会話2", 2)
		event.queue_object_sequence_next_motion(0, "立ち2", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "デフォルト口")
		helper_0e75aa9e(60060, -1, 10)
		event.set_camera_sequence_position(-416.96, 123.15, -56.77)
		event.set_camera_sequence_look_at(-445.66, 113.41, 7.28)
		event.set_object_sequence_motion(1, "指差し会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60070, -1, 10)
		wait_objects(1)
		event.set_object_sequence_motion(0, "会話2", 2)
		event.queue_object_sequence_next_motion(0, "立ち2", 4)
		helper_0e75aa9e(60080, -1, 10)
		helper_0e75aa9e(60090, -1, 10)
		helper_0e75aa9e(60095, -1, 10)
		event.set_object_sequence_motion(0, "立ち2")
		event.set_object_sequence_motion(1, "腰に手", 2)
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(1, "腰に手L", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		helper_0e75aa9e(60100, -1, 10)
		wait_objects(1)
		event.set_camera_sequence_position(-306.09, 121.28, -6.32)
		event.set_camera_sequence_look_at(-334.81, 124.2, -6.72)
		event.move_object_sequence(0, -334.72, 100.52, -7.62, 140)
		event.rotate_object_sequence(0, 0.0, 1.57, 0.0, 10)
		event.set_object_sequence_motion(0, "きょろきょろ歩き", 2)
		event.queue_object_sequence_next_motion(0, "きょろきょろ歩き・上")
		event.set_object_sequence_motion(1, "振り返る", 6)
		event.queue_object_sequence_next_motion(1, "振り返るL", 4)
		event.rotate_object_sequence(1, 0.0, -1.21, 0.0, 30)
		event.delay_object_sequence_texture_animation_track(0, 100)
		event.set_object_sequence_texture_animation(0, 0, "目パチ")
		event.set_object_sequence_texture_animation(0, 1, "上目")
		event.set_mouth_texture_animations(0, "通常口パク", "ポカーン")
		helper_0e75aa9e(60110, -1, 10)
		wait_objects(0)
		event.set_object_sequence_motion(0, "旧・立ち", 4)
		event.set_camera_sequence_position(-82.68, 160.58, 85.07)
		event.set_camera_sequence_look_at(-54.97, 205.76, 261.35)
		event.move_camera_sequence(-82.68, 160.58, 85.07, 60.21, 145.99, 192.66, 300)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		helper_1584c528(60120, 150)
		helper_1584c528(60130, 100)
		wait_camera()
		event.set_camera_sequence_position(393.03, 191.08, 62.48)
		event.set_camera_sequence_look_at(89.13, 151.44, 51.64)
		event.move_camera_sequence(393.03, 191.08, 62.48, 125.13, 148.6, -81.82, 300)
		helper_1584c528(60140, 140)
		helper_1584c528(60150, 120)
		wait_camera()
		event.set_camera_sequence_position(-316.41, 284.74, -17.35)
		event.set_camera_sequence_look_at(-8.6, 159.57, 242.62)
		event.move_camera_sequence(4.84, 184.71, 131.56, 106.14, 116.67, 193.96, 300)
		event.slow_down_camera_sequence_position(0.96, 60)
		event.delay_camera_sequence_position_track(15)
		event.set_object_sequence_position(0, -16.51, 104.0, 94.06)
		event.set_object_sequence_rotation(0, 0.0, 0.85, 0.0)
		event.move_object_sequence(0, 103.83, 104.0, 195.7, 200)
		event.set_object_sequence_motion(0, "歩き", 4, -1, 1)
		event.delay_object_sequence_motion_track(0, 200)
		event.set_object_sequence_motion(0, "旧・立ち")
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_object_sequence_position(1, -19.11, 104.0, 62.23)
		event.set_object_sequence_rotation(1, 0.0, 0.85, 0.0)
		event.move_object_sequence(1, 124.7, 104.0, 183.68, 230)
		event.delay_object_sequence_motion_track(1, 230)
		event.set_object_sequence_motion(1, "立ち")
		event.open_voice_stream_wave(1, 60160)
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 60160)
		open_message(0, -1, 8, 0, 0)
		wait_frames(80)
		event.set_object_handle_footstep_sound(0, 3)
		wait_frames(30)
		event.set_object_handle_footstep_sound(1, 3)
		wait_frames(90)
		close_message(0)
		event.close_voice_stream(1)
		wait_frames(30)
		helper_1584c528(60170, 40)
		wait_camera()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		wait_camera()
	end)
	vm.entry(40)
	event.cancel_drama_scene_skip()
	event.close_voice_stream(1)
	event.delete_character_extension_packs(0)
	event.set_character_active(0)
	event.set_object_handle_footstep_sound(0, -1)
	event.set_object_handle_footstep_sound(1, 3)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.set_character_position(0, 103.83, 104.0, 195.7)
	event.set_character_rotation(0, 0.0, 0.85, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(8, 124.7, 104.0, 183.68)
	event.set_character_rotation(8, 0.0, 0.85, 0.0)
	event.set_character_motion(8, "立ち", 4)
	event.clear_camera_sequence()
	event.set_camera_position(22.1, 160.44, 138.08)
	event.set_camera_look_at(103.83, 133.97, 195.7)
	event.reset_follow_camera(0)
	event.set_event_projection(524.9)
	event.fade_in_screen(30)
	wait_frames(30)
	event.apply_message_window_preset(0, 4)
	set_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Parle [UNI00e0] Donny pour continuer.\n   Avant, tu peux sauvegarder ta partie\n   [UNI00e0] un point de sauvegarde."
	)
	show_message(0, -1, 8, 0, 0)
	event.load_message_file(0, -1)
	set_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
end

--- Helper function.
local function helper_3ad30()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_message_selection_top_line(0, 0)
	set_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var0)
	var4 = 0.0
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var2)
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
	set_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Je me demande o[UNI00f9] va ce canal ?\nJe vais le demander [UNI00e0] Donny.")
	show_message(0, -1, 5, 256, 208)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_6955414c

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(103) or flag
		event.set_save_control_bits(1, if flag == 0 then 1 else 0)
		helper_6955414c()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, -112.0, 104.0, -114.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			var3 = event.get_map_type(old_map_no) or var3
			if var3 ~= -1 then
				if old_map_no == 15 or var3 == 7 or var3 == 8 then
					at = 1
					helper_3e3b0d3f()
				else
					helper_aaaef248()
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				at = 2
				helper_3e3b0d3f()
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_1ef0d4b2()
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				helper_d05dd9db()
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.set_save_flag(4, 1)
	helper_461bc()
end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	helper_68ec7c8d()
	event.set_save_counter(5, 3)
	helper_3bc74()
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local flag: s32 = 0
	flag = event.get_save_flag(4) or flag
	if flag == 1 then
		event.set_save_data_value(3, 1)
	end
	helper_f57795f8()
	if flag == 1 then
		event.set_save_data_value(3, 0)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local flag: s32 = 0
	flag = event.get_save_flag(103) or flag
	if flag == 0 then
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(
			0,
			"Flotsam me cherche peut-[UNI00ea]tre\nencore, il vaut mieux que je ne\nretourne pas [UNI00e0] Palm Brinks."
		)
		show_message(0, -1, 5, 256, 208)
	elseif helper_c0be7979() ~= 0 then
		event.jump_to_map_3(-1, "m01", 100)
	end
end

--- Event 530, which map data, a script or the engine runs by number.
function script.event_530()
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local var6: s32 = 0
	flag = event.get_save_flag(4) or flag
	if flag == 1 then
		helper_3ad30()
	elseif helper_87adbdbf() ~= 0 then
		event.set_dungeon_stage_id(0)
		event.open_event_menu(3, 0)
		vm.wait(3)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			var2 = out2 or var2
			var3 = out3 or var3
		end
		if var3 == 0 then
			helper_3e3b0d3f()
		else
			flag_2 = event.get_save_flag(102) or flag_2
			if var3 == 3 and flag_2 == 0 then
				var2 = 0
				var6 = event.get_dungeon_floor_info(var2, var3, 7) or var6
				var6 = vm.i32(var6 + 1)
				event.set_dungeon_floor_info(var2, var3, 7, var6)
				event.stop_music(0)
				event.skip_next_music_play()
				event.go_to_georama_edit(41, 500)
				return
			end
			if var3 == 6 then
				event.skip_next_music_load()
			end
			event.set_save_control_bits(1, 0)
			event.go_to_dungeon(0, var3, 1010)
		end
	end
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	event.set_function_point_enabled("", "memo", 0)
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, var0, var1, var2, 10)
	wait_frames(10)
	event.attach_object_handle_to_map_part_2(1, "memo")
	event.set_object_handle_visible(1, 0)
	event.add_inventory_item(386)
	helper_f38eabca(386, 1)
	helper_a87eb945(1)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(4) or flag
		if flag == 1 then
			at = 1
			if helper_461bc() ~= 0 then
				event.set_save_flag(4, 0)
				event.set_save_data_value(0, 2)
				event.add_inventory_item(22)
				event.equip_character_item(0, 22)
				event.add_inventory_item(359)
				event.set_time_of_day_advancing(1)
				event.stop_all_sounds()
				event.set_sound_reverb_enabled(0)
				event.show_chapter_title(1)
				at = 2
				vm.wait(2)
				event.set_sound_reverb_enabled(1)
				event.set_save_control_bits(1, 0)
				event.go_to_dungeon(0, -1, 1000)
				at = 3
				vm.wait(3)
			end
		else
			at = 4
			helper_2a9040b5()
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				local _ = received[1] :: number
			end
			if at <= 3 then
				helper_ad047ca5()
			end
			return 0
		end
		return nil
	end)
end

--- Event 10070, which map data, a script or the engine runs by number.
function script.event_10070()
	local at: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.stop_environment_music()
		at = 1
		wait_frames(6)
		helper_68ec7c8d()
		event.set_save_flag(4, 1)
		at = 2
		helper_3bc74()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_344d6cd8()
				at = 2
				helper_3bc74()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
