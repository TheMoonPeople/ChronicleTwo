--!strict
--- Runs the underground water channel hideout where Donnie gives Max his gun, the arrival cutscene, the exit to Palm Brinks and the dungeon entrance.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local underground_water_channel_event = require("@lib/event/underground_water_channel_event")
local villager_dialogue = require("@lib/event/german/villager_dialogue")
local wait = require("@lib/event/wait")

--- Plays the cutscene in which Donnie explains the channel, hands Max the gun and receiver, and Max runs off.
local function cutscene_donnie_gives_gun()
	local map_sound: s32 = 0
	local gun_sound: s32 = 0
	local image_block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.initialize_event()
		event.enable_drama_skip()
		message.set_window_mode(0, 7)
		event.set_event_projection(618.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		map_sound = event.load_sound_effect_file_2(1800) or map_sound
		gun_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or gun_sound
		event.load_message_file(0, 5, "event/opening/p6/op6_1.txt")
		event.delete_event_image(0)
		image_block = event.load_event_image_4(5, "textures/event/opening/p6/op06.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "op0601", image_block)
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
		event.set_event_sprite_texture(1, "op0602", image_block)
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
		event.set_event_sprite_texture(2, "op0603", image_block)
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
		message.show_voiced_with_button_prompt(60210, -1, 10)
		event.reset_mouth_texture_animations()
		object.wait_until_done(0)
		event.set_object_sequence_position(0, 103.83, -100.0, 195.7)
		event.set_camera_sequence_position(112.75, 131.05, 198.49)
		event.set_camera_sequence_look_at(163.01, 122.54, 302.27)
		event.move_camera_sequence(112.75, 131.05, 198.49, 87.37, 110.42, 341.57, 180)
		message.show_voiced_for(60220, 80)
		message.show_voiced_for(60230, 70)
		camera.wait_until_done()
		event.set_camera_sequence_position(124.82, 125.36, 251.04)
		event.set_camera_sequence_look_at(105.61, 114.01, 150.82)
		event.set_object_sequence_position(0, 103.83, 104.0, 195.7)
		event.set_object_sequence_motion(0, "考えポーズ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "考えポーズL", 4)
		wait.frames(60)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60240, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60250, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60260, -1, 10)
		event.set_object_sequence_motion(0, "ドニーを見る", 2)
		event.queue_object_sequence_next_motion(0, "ドニーを見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60270, -1, 10)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60280, -1, 10)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(0, "ドニーを見る会話", 2)
		event.queue_object_sequence_next_motion(0, "ドニーを見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60290, -1, 10)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(10, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60300, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60305, -1, 10)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_color(10, 128, 128, 128, 0, 30)
		event.set_object_sequence_motion(0, "考えポーズL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60310, -1, 10)
		event.set_event_sprite_draw_pass(0, 0)
		object.wait_until_done(0)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60320, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60330, -1, 10)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(11, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60340, -1, 10)
		event.set_object_sequence_color(11, 128, 128, 128, 0, 30)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(12, 128, 128, 128, 128, 30)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60350, -1, 10)
		event.set_object_sequence_color(12, 128, 128, 128, 0, 30)
		wait.frames(30)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_object_sequence_motion(1, "ミンツを見る戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60360, -1, 10)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "左を向く", 2)
		event.queue_object_sequence_next_motion(0, "左を向くL")
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, map_sound, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60370, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "ミンツを見る", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60380, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60385, -1, 10)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "うなづく", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60390, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60400, -1, 10)
		event.set_object_sequence_motion(1, "ミンツを見るL")
		event.set_object_sequence_motion(0, "工具を出す", 2)
		event.queue_object_sequence_next_motion(0, "工具を出すL", 6)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "武器おろし", 6)
		event.queue_object_sequence_next_motion(0, "武器おろしL", 4)
		event.play_object_sequence_sound(0, map_sound, 11)
		wait.frames(10)
		event.set_character_active(10)
		event.delay_object_sequence_texture_animation_track(1, 25)
		event.set_object_sequence_texture_animation(1, 1, "イィッ")
		event.set_object_sequence_texture_animation(0, 0, "真剣口")
		vm.wait(36)
		event.set_mouth_texture_animations(0, "通常口パク", "得意口")
		message.show_voiced_with_button_prompt(60410, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0, "得意口")
		event.set_object_sequence_texture_animation(0, 1, "真剣口")
		event.set_object_sequence_texture_animation(1, 0, "イィッ")
		wait.frames(20)
		event.set_object_sequence_motion(1, "ミンツを見る会話", 2)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60430, -1, 10)
		event.set_object_sequence_motion(1, "ミンツを見る戻り", 6)
		event.wait_object_sequence_motion_end(1)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, 112.5, 104.0, 138.09, 25)
		event.rotate_object_sequence(1, 0.0, -2.91, 0.0, 10)
		wait.frames(15)
		object.wait_until_done(1)
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
		wait.frames(80)
		wait.frames(20)
		object.wait_until_done(0)
		object.wait_until_done(1)
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
		wait.frames(100)
		event.set_object_handle_footstep_sound(1, 3)
		object.wait_until_done(1)
		event.move_object_sequence(1, 114.43, 104.0, 184.04, 25)
		event.rotate_object_sequence(1, 0.0, -0.78, 0.0, 25)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち", 2)
		event.queue_object_sequence_next_motion(1, "銃を渡す", 6)
		event.wait_object_sequence_motion_end(1)
		event.delay_object_sequence_sound_track(1, 60)
		event.play_object_sequence_sound(1, map_sound, 12)
		event.set_object_sequence_motion(0, "右向け右", 6)
		event.queue_object_sequence_next_motion(0, "右向け右L", 4)
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60450, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "銃を受け取る", 2)
		event.delay_object_sequence_motion_track(0, 1)
		event.queue_object_sequence_next_motion(0, "銃を受け取るL", 6)
		event.queue_object_sequence_next_motion(0, "銃を受け取るL2", 4)
		event.delay_object_sequence_sound_track(0, 12)
		event.play_object_sequence_sound(0, map_sound, 13)
		wait.frames(20)
		event.detach_character_from_frame(11)
		event.attach_character_to_frame(0, "gun_hand", 11)
		wait.frames(20)
		event.set_object_sequence_motion(1, "銃を渡す戻り", 6)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60460, -1, 10)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60470, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60475, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "すごいよ", 6)
		event.queue_object_sequence_next_motion(0, "すごいよL", 4)
		event.set_object_sequence_texture_animation(0, 0, "真剣口")
		vm.wait(60)
		event.set_mouth_texture_animations(0, "通常口パク", "得意口")
		message.show_voiced_with_button_prompt(60480, -1, 10)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60490, -1, 10)
		event.set_object_sequence_motion(1, "立ち")
		event.set_mouth_texture_animations(0, "通常口パク", "得意口")
		message.show_voiced_with_button_prompt(60500, -1, 10)
		camera.wait_until_done()
		object.wait_until_done(0)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(136.41, 122.25, 229.2)
		event.set_camera_sequence_look_at(102.5, 130.77, 197.18)
		event.move_camera_sequence(123.15, 123.01, 222.97, 110.99, 134.65, 195.81, 120)
		event.set_music_volume(0)
		event.play_sound_effect(gun_sound, 0)
		event.set_object_sequence_motion(0, "銃を掲げる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "銃を掲げるL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.play_object_sequence_sound(0, map_sound, 14)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, map_sound, 15)
		event.set_character_active(1, 12)
		event.set_object_sequence_motion(2, "発動", 6)
		event.wait_object_sequence_motion_end(2)
		object.wait_until_done(2)
		event.set_character_active(0, 12)
		inventory.announce_received(22, 1)
		message.set_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)] Mit [l1] gehst du in Position \n   und greifst mit (O) an.\n   Aber wenn du zu weit weg stehst,\n   sind deine Angriffe weniger wirksam."
		)
		message.show(0, -1, 8, 0, 0)
		message.set_window_mode(0, 7)
		event.set_message_draw_speed(0, 0)
		object.wait_until_done(0)
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
		event.play_sound_effect(map_sound, 18)
		event.set_object_sequence_motion(1, "レシーバーをあげる", 6)
		event.queue_object_sequence_next_motion(1, "レシーバーをあげるL", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60510, -1, 10)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "レシーバーをもらう", 6)
		event.queue_object_sequence_next_motion(0, "レシーバーをもらうL", 4)
		wait.frames(14)
		event.play_sound_effect(map_sound, 19)
		object.wait_until_done(0)
		event.detach_character_from_frame(13)
		event.attach_character_to_frame(0, "ef00", 13)
		event.set_object_sequence_motion(0, "レシーバーを下ろす", 6)
		event.queue_object_sequence_next_motion(0, "レシーバーを下ろすL", 4)
		event.set_object_sequence_motion(1, "レシーバーをあげる戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60520, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60530, -1, 10)
		inventory.announce_received(359, 1)
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
		message.show_voiced_with_button_prompt(60540, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60550, -1, 10)
		event.set_camera_sequence_position(-104.06, 146.74, 477.55)
		event.set_camera_sequence_look_at(16.01, 86.26, 244.13)
		event.play_object_sequence_sound(0, map_sound, 16)
		event.delay_object_sequence_sound_track(0, 30)
		event.play_object_sequence_sound(0, map_sound, 17)
		event.set_object_sequence_motion(0, "飛び降りる", 6)
		event.wait_object_sequence_motion_end(0)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-45.88, 52.01, 341.35)
		event.set_camera_sequence_look_at(16.98, 101.86, 233.55)
		event.set_object_sequence_position(1, 7.1, 104.0, 227.78)
		event.set_object_sequence_rotation(1, 0.0, -0.08, 0.0)
		event.set_object_sequence_motion(1, "下を見るL", 4)
		event.set_object_sequence_motion(0, "振り返る", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced_with_button_prompt(60560, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "振り返る戻り", 6)
		event.wait_object_sequence_motion_end(0)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "走り2")
		event.move_object_sequence(0, 0.0, 48.0, 600.0, 140)
		event.delay_object_sequence_motion_track(1, 120)
		event.set_object_sequence_motion(1, "下を見る会話")
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_for(60570, 200)
		event.set_camera_sequence_position(-15.79, 151.18, 139.2)
		event.set_camera_sequence_look_at(4.88, 115.54, 302.4)
		event.set_object_sequence_position(0, 0.0, 48.0, 400.0)
		event.move_object_sequence(0, 0.0, 48.0, 600.0, 60)
		message.show_voiced_for(60580, 50)
		object.wait_until_done(0)
		event.set_camera_sequence_position(0.0, 61.0, 700.0)
		event.set_camera_sequence_look_at(0.0, 29.0, 850.0)
		event.set_object_handle_footstep_sound(0, 15)
		event.set_object_sequence_position(0, 0.0, 0.0, 750.0)
		event.move_object_sequence(0, 0.0, 0.0, 830.0, 30)
		event.reset_object_sequence_dynamic_animation(0)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "旧・立ち")
		wait.frames(30)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-2.62, 29.33, 799.72)
		event.set_camera_sequence_look_at(-2.62, 22.33, 827.0)
		event.set_object_sequence_motion(0, "心配ないさ", 2)
		event.queue_object_sequence_next_motion(0, "心配ないさL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目パチ")
		vm.wait(88)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_with_button_prompt(60590, -1, 10)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_with_button_prompt(60595, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "心配ないさ戻り", 2)
		event.queue_object_sequence_next_motion(0, "旧･立ち", 4)
		object.wait_until_done(0)
		wait.frames(6)
		event.move_object_sequence(0, 0.0, 0.0, 1230.0, 120)
		event.set_object_sequence_motion(0, "走り2")
		event.move_camera_sequence(-2.62, 26.75, 843.0, -2.62, 24.35, 939.2, 120)
		event.set_object_handle_footstep_sound(0, 15)
		wait.frames(14)
		event.set_object_handle_footstep_sound(0, 2)
		wait.frames(76)
		event.fade_out_music(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
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

--- Has Donnie ask what Max will do next and plays the gun cutscene when Max chooses to hide in the channel; returns 1 when the cutscene played.
local function ask_what_to_do_next()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local donnie_x: f32 = 0
	local donnie_y: f32 = 0
	local donnie_z: f32 = 0
	local player_yaw: f32 = 0
	local yaw_to_donnie: f32 = 0
	local yaw_to_player: f32 = 0
	local angle_compare_result: s32 = 0
	local answer: any = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		message.set_window_mode(0, 7)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			player_yaw = out2 or player_yaw
		end
		do
			local out1, out2, out3 = event.get_character_position(8)
			donnie_x = out1 or donnie_x
			donnie_y = out2 or donnie_y
			donnie_z = out3 or donnie_z
		end
		yaw_to_donnie = event.get_direction_angle(player_x, player_y, player_z, donnie_x, donnie_y, donnie_z) or yaw_to_donnie
		yaw_to_player = event.get_direction_angle(donnie_x, donnie_y, donnie_z, player_x, player_y, player_z) or yaw_to_player
		angle_compare_result = event.compare_angles(player_yaw, yaw_to_donnie, 0.1) or angle_compare_result
		if angle_compare_result ~= 0 then
			event.rotate_object_sequence(0, 0.0, yaw_to_donnie, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		event.rotate_object_sequence(1, 0.0, yaw_to_player, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "立ち")
		step = 1
		wait.frames(20)
		event.open_voice_stream_wave(1, 60180)
		step = 2
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, "Und was machst du jetzt?")
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		step = 3
		message.say_bubble(0, -1, 8, 0, 0)
		event.close_voice_stream(1)
		message.set_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.open_message_window_2(0, "Ich werde mich hier verstecken.\nUnterirdischer Kanal ... ...")
		step = 4
		answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 0)
		message.set_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if answer == 1 then
			event.close_voice_stream(1)
			step = 5
			cutscene_donnie_gives_gun()
			return 1
		else
			event.open_voice_stream_wave(1, 60190)
			step = 6
			sound.wait_voice_stream_ready(1)
			event.play_voice_stream(1)
			event.open_message_window_2(0, "Ich werde mich hier verstecken.")
			step = 7
			message.say_bubble(0, -1, 0, 8, 0)
			event.close_voice_stream(1)
			event.open_voice_stream_wave(1, 60200)
			step = 8
			sound.wait_voice_stream_ready(1)
			event.play_voice_stream(1)
			event.open_message_window_2(0, "Bleib solang du willst.")
			step = 9
			message.say_bubble(0, -1, 8, 0, 0)
			event.close_voice_stream(1)
		end
		event.rotate_object_sequence(1, 0.0, 0.85, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "立ち")
		step = 10
		wait.frames(11)
		return 0
	end, function(received: { any })
		if step <= 5 then
			if step == 4 then
				answer = received[1] :: number
			end
			if step <= 1 then
				cutscene.skip_command(1)
			end
			if step <= 2 then
				message.show_bubble_and_close(0, -1, 8, 0, 0)
			end
			if step <= 3 then
				message.set_window_mode_stub(0, 1)
				answer = message.ask_choice_skipping(0, -1, 5, 256, 208, 2, 0)
			end
			if step <= 4 then
				message.set_window_mode_stub(0, 7)
				step = 5
				cutscene_donnie_gives_gun()
				return vm.continue_with(function()
					return 1
				end)
			end
			return 1
		end
		if step <= 10 then
			if step <= 6 then
				message.show_bubble_and_close(0, -1, 0, 8, 0)
			end
			if step <= 7 then
				cutscene.skip_command(1)
			end
			if step <= 8 then
				message.show_bubble_and_close(0, -1, 8, 0, 0)
			end
			if step <= 9 then
				wait.frames_skipping(11)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the cutscene in which Max and Donnie climb down into the channel and talk before walking to the hideout.
local function cutscene_arrive_in_channel()
	local map_sound: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		message.set_window_mode(0, 7)
		event.set_event_projection(618.0)
		event.load_map_sounds(1800)
		event.stop_music(0)
		wait.frames(6)
		event.load_music(108)
		event.play_music(0)
		event.enable_drama_skip()
		map_sound = event.load_sound_effect_file_2(1800) or map_sound
		underground_water_channel_event.place_donnie()
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
		sound.wait_voice_stream_ready(1)
		event.set_object_sequence_motion(0, "はしご降り", 6)
		event.set_object_sequence_motion(1, "はしご降り", 6)
		event.play_object_sequence_sound(1, map_sound, 8)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-173.98, 180.32, 173.33)
		event.set_camera_sequence_look_at(-478.87, 162.2, -4.22)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(60)
		camera.wait_until_done()
		event.delay_object_sequence_sound_track(1, 30)
		event.play_object_sequence_sound(1, map_sound, 9)
		wait.frames(16)
		event.play_voice_stream(1)
		wait.frames(100)
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
		wait.frames(20)
		message.show_voiced_with_button_prompt(60010, -1, 10)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60020, -1, 10)
		event.set_object_sequence_motion(1, "立ち")
		message.show_voiced_with_button_prompt(60030, -1, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "深呼吸目")
		event.set_object_sequence_texture_animation(0, 1, "深呼吸口")
		event.set_object_sequence_motion(0, "深呼吸", 6)
		event.queue_object_sequence_next_motion(0, "立ち2", 4)
		wait.frames(50)
		event.set_object_sequence_texture_animation(0, 0, "深呼吸口")
		event.set_mouth_texture_animations(0, "通常口パク", "デフォルト口")
		message.show_voiced_with_button_prompt(60040, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目パチ")
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60050, -1, 10)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60055, -1, 10)
		event.set_object_sequence_motion(0, "会話2", 2)
		event.queue_object_sequence_next_motion(0, "立ち2", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "デフォルト口")
		message.show_voiced_with_button_prompt(60060, -1, 10)
		event.set_camera_sequence_position(-416.96, 123.15, -56.77)
		event.set_camera_sequence_look_at(-445.66, 113.41, 7.28)
		event.set_object_sequence_motion(1, "指差し会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60070, -1, 10)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "会話2", 2)
		event.queue_object_sequence_next_motion(0, "立ち2", 4)
		message.show_voiced_with_button_prompt(60080, -1, 10)
		message.show_voiced_with_button_prompt(60090, -1, 10)
		message.show_voiced_with_button_prompt(60095, -1, 10)
		event.set_object_sequence_motion(0, "立ち2")
		event.set_object_sequence_motion(1, "腰に手", 2)
		event.wait_object_sequence_motion_end(1)
		event.set_object_sequence_motion(1, "腰に手L", 4)
		event.set_mouth_texture_animations(1, "口パク", "口閉じ")
		message.show_voiced_with_button_prompt(60100, -1, 10)
		object.wait_until_done(1)
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
		message.show_voiced_with_button_prompt(60110, -1, 10)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "旧・立ち", 4)
		event.set_camera_sequence_position(-82.68, 160.58, 85.07)
		event.set_camera_sequence_look_at(-54.97, 205.76, 261.35)
		event.move_camera_sequence(-82.68, 160.58, 85.07, 60.21, 145.99, 192.66, 300)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		message.show_voiced_for(60120, 150)
		message.show_voiced_for(60130, 100)
		camera.wait_until_done()
		event.set_camera_sequence_position(393.03, 191.08, 62.48)
		event.set_camera_sequence_look_at(89.13, 151.44, 51.64)
		event.move_camera_sequence(393.03, 191.08, 62.48, 125.13, 148.6, -81.82, 300)
		message.show_voiced_for(60140, 140)
		message.show_voiced_for(60150, 120)
		camera.wait_until_done()
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
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 60160)
		message.open(0, -1, 8, 0, 0)
		wait.frames(80)
		event.set_object_handle_footstep_sound(0, 3)
		wait.frames(30)
		event.set_object_handle_footstep_sound(1, 3)
		wait.frames(90)
		message.close(0)
		event.close_voice_stream(1)
		wait.frames(30)
		message.show_voiced_for(60170, 40)
		camera.wait_until_done()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
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
	wait.frames(30)
	event.apply_message_window_preset(0, 4)
	message.set_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Sprich mit Donny, dann geht's weiter.\n   Du kannst deinen Fortschritt am\n   Speicherpunkt speichern."
	)
	message.show(0, -1, 8, 0, 0)
	event.load_message_file(0, -1)
	message.set_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
end

--- Walks Max back to look at the water channel and has him say he will ask Donnie about it.
local function examine_water_channel()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_message_selection_top_line(0, 0)
	message.set_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	target_x = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + player_x)
	target_y = 0.0
	target_z = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + player_z)
	event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	event.set_object_sequence_motion(0, "歩き")
	i = 0
	while i < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		player_y = vm.f32(player_y + 30.0)
		event.set_camera_look_at(player_x, player_y, player_z)
		i = i + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	message.set_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Wo dieser Kanal wohl hinf[UNI00fc]hrt?\nIch werde Donny fragen.")
	message.show(0, -1, 5, 256, 208)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing because the script needs no load-time preparation.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = underground_water_channel_event.initialize_map

--- Places the player on entry, running into view when arriving from Palm Brinks, a dungeon or after a map error, or standing at the entrance otherwise.
function script.default_event()
	local story_flag: s32 = 0
	local memory_card_load: s32 = 0
	local previous_map: s32 = 0
	local previous_map_type: s32 = 0
	local step: number = 0
	return vm.guard(function()
		story_flag = event.get_save_flag(103) or story_flag
		event.set_save_control_bits(1, if story_flag == 0 then 1 else 0)
		underground_water_channel_event.initialize_map()
		memory_card_load = event.take_memory_card_load_state() or memory_card_load
		if memory_card_load == 1 then
			event.set_character_position(0, -112.0, 104.0, -114.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			previous_map = event.get_previous_map() or previous_map
			previous_map_type = event.get_map_type(previous_map) or previous_map_type
			if previous_map_type ~= -1 then
				if previous_map == 15 or previous_map_type == 7 or previous_map_type == 8 then
					step = 1
					underground_water_channel_event.run_into_view()
				else
					underground_water_channel_event.place_player_at_entrance()
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				step = 2
				underground_water_channel_event.run_into_view()
			end
		end
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				cutscene.noop()
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				underground_water_channel_event.wait_skippable_pause()
			end
			return 0
		end
		return nil
	end)
end

--- Marks the gun cutscene as pending and plays the prompt in which Donnie asks what Max will do.
function script.key_open()
	event.set_save_flag(4, 1)
	ask_what_to_do_next()
end

--- Starts the arrival cutscene for the first visit to the channel and resets the memo state.
function script.start_arrival_cutscene()
	underground_water_channel_event.hide_memo_if_owned()
	event.set_save_counter(5, 3)
	cutscene_arrive_in_channel()
end
script[151] = script.start_arrival_cutscene

--- Opens the menu, flagging the save data while the gun cutscene is pending.
function script.open_menu()
	local gun_cutscene_pending: s32 = 0
	gun_cutscene_pending = event.get_save_flag(4) or gun_cutscene_pending
	if gun_cutscene_pending == 1 then
		event.set_save_data_value(3, 1)
	end
	menu.open_with_fade()
	if gun_cutscene_pending == 1 then
		event.set_save_data_value(3, 0)
	end
end
script[400] = script.open_menu

--- Warns that Flotsam may be looking for Max before the story advances, then asks to go back to Palm Brinks.
function script.exit_to_palm_brinks()
	local flag_103: s32 = 0
	flag_103 = event.get_save_flag(103) or flag_103
	if flag_103 == 0 then
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Flotsam sucht noch nach mir.\nIch geh besser nicht zur[UNI00fc]ck nach\nPalm Brinks.")
		message.show(0, -1, 5, 256, 208)
	elseif underground_water_channel_event.ask_and_fade_out() ~= 0 then
		event.jump_to_map_3(-1, "m01", 100)
	end
end
script[500] = script.exit_to_palm_brinks

--- Lets the player pick a dungeon floor to enter, or makes Max look at the channel while the gun cutscene is pending.
function script.examine_dungeon_entrance()
	local gun_cutscene_pending: s32 = 0
	local dungeon_stage: s32 = 0
	local dungeon_floor: s32 = 0
	local flag_102: s32 = 0
	local georama_visit_count: s32 = 0
	gun_cutscene_pending = event.get_save_flag(4) or gun_cutscene_pending
	if gun_cutscene_pending == 1 then
		examine_water_channel()
	elseif underground_water_channel_event.ask_and_run_out() ~= 0 then
		event.set_dungeon_stage_id(0)
		event.open_event_menu(3, 0)
		vm.wait(3)
		do
			local _, out2, out3, _ = event.get_menu_results_4()
			dungeon_stage = out2 or dungeon_stage
			dungeon_floor = out3 or dungeon_floor
		end
		if dungeon_floor == 0 then
			underground_water_channel_event.run_into_view()
		else
			flag_102 = event.get_save_flag(102) or flag_102
			if dungeon_floor == 3 and flag_102 == 0 then
				dungeon_stage = 0
				georama_visit_count = event.get_dungeon_floor_info(dungeon_stage, dungeon_floor, 7) or georama_visit_count
				georama_visit_count = vm.i32(georama_visit_count + 1)
				event.set_dungeon_floor_info(dungeon_stage, dungeon_floor, 7, georama_visit_count)
				event.stop_music(0)
				event.skip_next_music_play()
				event.go_to_georama_edit(41, 500)
				return
			end
			if dungeon_floor == 6 then
				event.skip_next_music_load()
			end
			event.set_save_control_bits(1, 0)
			event.go_to_dungeon(0, dungeon_floor, 1010)
		end
	end
end
script[530] = script.examine_dungeon_entrance

--- Turns Max toward the memo, picks it up and announces the item.
function script.pick_up_memo()
	local memo_x: f32 = 0
	local memo_y: f32 = 0
	local memo_z: f32 = 0
	event.initialize_event()
	event.set_function_point_enabled("", "memo", 0)
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		memo_x = out1 or memo_x
		memo_y = out2 or memo_y
		memo_z = out3 or memo_z
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, memo_x, memo_y, memo_z, 10)
	wait.frames(10)
	event.attach_object_handle_to_map_part_2(1, "memo")
	event.set_object_handle_visible(1, 0)
	event.add_inventory_item(386)
	inventory.announce_received(386, 1)
	inventory.resolve_overflow_alt(1)
end
script[550] = script.pick_up_memo

--- Has Donnie ask what Max will do and, when Max chooses to hide, gives him the gun and receiver and starts the first dungeon; otherwise Donnie talks normally.
function script.talk_to_donnie()
	local gun_cutscene_pending: s32 = 0
	local step: number = 0
	return vm.guard(function()
		gun_cutscene_pending = event.get_save_flag(4) or gun_cutscene_pending
		if gun_cutscene_pending == 1 then
			step = 1
			if ask_what_to_do_next() ~= 0 then
				event.set_save_flag(4, 0)
				event.set_save_data_value(0, 2)
				event.add_inventory_item(22)
				event.equip_character_item(0, 22)
				event.add_inventory_item(359)
				event.set_time_of_day_advancing(1)
				event.stop_all_sounds()
				event.set_sound_reverb_enabled(0)
				event.show_chapter_title(1)
				step = 2
				vm.wait(2)
				event.set_sound_reverb_enabled(1)
				event.set_save_control_bits(1, 0)
				event.go_to_dungeon(0, -1, 1000)
				step = 3
				vm.wait(3)
			end
		else
			step = 4
			villager_dialogue.talk_to_triggered_villager()
		end
		return
	end, function(received: { any })
		if step <= 4 then
			if step == 1 then
				local _ = received[1] :: number
			end
			if step <= 3 then
				cutscene.play_talk_sequence_default()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_donnie

--- Stops the music, hides the memo and replays the arrival cutscene with the gun cutscene pending.
function script.restart_arrival_cutscene()
	local step: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.stop_environment_music()
		step = 1
		wait.frames(6)
		underground_water_channel_event.hide_memo_if_owned()
		event.set_save_flag(4, 1)
		step = 2
		cutscene_arrive_in_channel()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				wait.background_load_skipping()
				step = 2
				cutscene_arrive_in_channel()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[10070] = script.restart_arrival_cutscene

return script
