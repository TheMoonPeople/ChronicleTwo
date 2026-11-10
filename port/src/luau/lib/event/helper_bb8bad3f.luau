--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_bb8bad3f()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_dungeon_pause_flags(1, 1)
		event.show_dungeon_status_bar(0, 0.033333335)
		at = 1
		wait_frames(30)
		event.fade_out_screen(30)
		at = 2
		wait_frames(30)
		event.clear_event_battle_monsters(-1)
		event.set_dungeon_pause_flags(16384, 0)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		event.add_hp_by_rate(1.0, 0)
		event.add_battle_weapon_durability(0, 999)
		var1 = event.load_sound_effect_file_2(1216) or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/opening/p4/op4ch1_1.txt")
		event.load_character_motion_pack(5, "event/opening/p4/p4_mints3.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 0)
		event.attach_object_handle_to_character(21, 2)
		event.set_object_handle_visible(21, 0)
		event.load_character(5, "event/opening/p4/light.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_frame_visible(2, "kusari", 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character_frame(7, 10, "light_rot")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.rotate_object_sequence(7, 0.01, 0.0, 0.0, -1)
		event.load_character(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
		event.load_character_motion_pack(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, var1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.set_object_handle_sound_bank(4, var1)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.set_object_handle_sound_bank(5, var1)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.copy_character(5, 11, 14)
		event.set_character_active(0, 14)
		event.load_character(5, "event/opening/p4/p4_people.gltf", "info", 15)
		event.set_character_active(15)
		event.set_character_position(15, 0.0, 0.0, -405.0)
		event.load_character(5, "event/opening/p4/up_kusari.gltf", "info", 18)
		event.set_character_active(18)
		event.attach_character_to_frame(10, "up_kusari", 18)
		event.load_character(5, "event/opening/p4/shuchusen.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(6, 8)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "event/opening/p4/p4_kemuri.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.set_character_position(20, 0.0, 10.0, 0.0)
		event.set_object_sequence_motion(4, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot2", 12)
		event.set_object_sequence_motion(5, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot3", 13)
		event.set_object_sequence_motion(3, "つかまりL", 4)
		event.attach_character_to_frame(10, "pierrot1", 11)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.attach_character_to_frame(10, "mints", 0)
		event.set_object_sequence_motion(0, "見上げるL", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.open_voice_stream_wave(1, 40060)
		at = 3
		helper_9cbdc640(1)
		event.set_character_motion(10, "落下", 6, 0.3)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
		event.play_sound_effect(var1, 33)
		event.keep_character_in_front_of_camera_sequence(8, 60.0, 30)
		event.set_character_active(8)
		event.set_character_active(18)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "落ちるー（３）")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.play_voice_stream(1)
		event.open_message_window_2(0, 40060)
		open_message(0, -1, 8, 0, 0)
		at = 4
		helper_917013c0(0, 30)
		close_message(0)
		event.set_message_bubble_screen_slot(0, 0)
		at = 5
		wait_objects(6)
		event.close_voice_stream(1)
		event.release_camera_sequence_follow_object()
		event.set_character_active(0, 8)
		event.set_camera_sequence_position(0.0, 18.46, -95.54)
		event.set_camera_sequence_look_at(0.0, 194.33, 107.78)
		event.move_camera_sequence(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_character_active(13)
		event.set_character_active(0, 18)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "落下", 6, 0.3)
		event.queue_object_sequence_next_motion(2, "停止", 4)
		event.play_sound_effect(var1, 27)
		at = 6
		wait_frames(14)
		event.set_object_sequence_motion(0, "飛び降りる", 2)
		event.queue_object_sequence_next_motion(0, "飛び降りるL", 6, 0.2)
		event.queue_object_sequence_next_motion(0, "ライトから着地", 6)
		event.wait_object_sequence_motion_end(0)
		event.delay_object_sequence_motion_track(0, 10)
		at = 7
		wait_frames(10)
		event.detach_character_from_frame(0)
		event.set_object_sequence_position(0, 0.0, 65.81, 94.16)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.jump_object_sequence(0, 0.0, 10.6, 6.0, -0.2, 30)
		at = 8
		wait_frames(5)
		event.set_character_active(20)
		event.set_character_motion(20, "けむり", 6)
		at = 9
		wait_objects(2)
		event.clear_object_sequence(7)
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, -46.01, 150.0, 50.48)
		event.set_object_sequence_rotation(3, 0.0, 2.42, 0.0)
		event.detach_character_from_frame(12)
		event.set_object_sequence_position(4, -48.62, 150.0, 60.52)
		event.set_object_sequence_rotation(4, 0.0, -2.42, 0.0)
		event.detach_character_from_frame(13)
		event.set_object_sequence_position(5, -35.87, 150.0, -54.34)
		event.set_object_sequence_rotation(5, 0.0, 0.38, 0.0)
		event.set_character_active(14)
		event.attach_object_handle_to_character(20, 14)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.set_object_sequence_position(20, 30.12, 150.0, -61.93)
		event.set_object_sequence_rotation(20, 0.0, -0.6, 0.0)
		at = 10
		wait_objects(0)
		event.set_camera_sequence_position(1.17, 26.95, -26.03)
		event.set_camera_sequence_look_at(1.17, 33.68, 4.49)
		event.set_object_sequence_position(0, 0.0, 10.0, 6.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "舞台上キョロキョロ", 6)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "拍手喝采（３）")
		event.set_object_sequence_texture_animation(0, 1, "開きからにこり")
		event.play_object_sequence_sound(0, var1, 28)
		at = 11
		wait_objects(0)
		event.set_camera_sequence_look_at(0.0, 33.68, 4.49)
		event.set_camera_sequence_angle_height_distance(0.9, 9.0, 50.0)
		event.move_camera_sequence_angle_height_distance(-0.9, 9.0, 50.0, 180)
		event.set_object_sequence_motion(0, "手を振る", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "感動（３）")
		event.set_object_sequence_texture_animation(0, 1, "うれし口（３）")
		at = 12
		wait_camera()
		event.set_camera_sequence_position(0.61, 45.86, -150.28)
		event.set_camera_sequence_look_at(0.57, 21.14, 5.95)
		event.set_character_active(0, 10)
		event.set_object_sequence_motion(20, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(20, "着地", 6)
		event.queue_object_sequence_next_motion(20, "立ち", 4)
		event.jump_object_sequence(20, 30.12, 8.8, -61.93, -0.2, 30)
		event.delay_object_sequence_sound_track(20, 30)
		event.play_object_sequence_sound(20, var1, 34)
		at = 13
		wait_frames(6)
		event.set_object_sequence_motion(3, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(3, "着地", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.jump_object_sequence(3, -46.01, 8.8, 50.48, -0.2, 30)
		event.delay_object_sequence_sound_track(3, 30)
		event.play_object_sequence_sound(3, var1, 34)
		at = 14
		wait_frames(4)
		event.set_object_sequence_motion(5, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(5, "着地", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 4)
		event.jump_object_sequence(5, -35.87, 8.8, -54.34, -0.2, 30)
		event.delay_object_sequence_sound_track(5, 30)
		event.play_object_sequence_sound(5, var1, 34)
		at = 15
		wait_frames(3)
		event.set_object_sequence_motion(4, "落下中", 6, 0.15)
		event.queue_object_sequence_next_motion(4, "着地", 6)
		event.queue_object_sequence_next_motion(4, "立ち", 4)
		event.jump_object_sequence(4, 48.62, 8.8, 60.52, -0.2, 30)
		event.delay_object_sequence_sound_track(4, 30)
		event.play_object_sequence_sound(4, var1, 34)
		at = 16
		wait_frames(20)
		event.set_object_sequence_motion(0, "キョロキョロ立ち")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		at = 17
		helper_1584c528(40080, 30)
		at = 18
		wait_frames(10)
		event.set_camera_sequence_position(-20.61, 33.01, -18.61)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_object_sequence_motion(0, "レンチを取り出す", 6)
		event.queue_object_sequence_next_motion(0, "レンチを取り出すL", 4)
		event.close_voice_stream(1)
		var2 = 0
		at = 19
		wait_frames(40 - var2)
		event.attach_object_handle_to_character(21, 1)
		event.set_object_handle_visible(21, 1)
		at = 20
		wait_frames(46)
		event.play_object_sequence_sound(0, var1, 35)
		at = 21
		wait_objects(0)
		at = 22
		wait_frames(30)
		event.set_camera_sequence_position(-4.51, 25.29, -32.6)
		event.set_camera_sequence_look_at(1.45, 30.1, 6.28)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.delay_object_sequence_sound_track(0, 4)
		event.play_object_sequence_sound(0, var1, 36)
		at = 23
		wait_objects(0)
		at = 24
		wait_frames(30)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 25
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(30)
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_705b02bc(0, 30)
		end
		if at <= 4 then
			helper_d16eef1e(0)
			helper_238b5abc(6)
		end
		if at <= 5 then
			wait_frames_skipping(14)
		end
		if at <= 6 then
			wait_frames_skipping(10)
		end
		if at <= 7 then
			wait_frames_skipping(5)
		end
		if at <= 8 then
			helper_238b5abc(2)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_344d6cd8()
		end
		if at <= 12 then
			wait_frames_skipping(6)
		end
		if at <= 13 then
			wait_frames_skipping(4)
		end
		if at <= 14 then
			wait_frames_skipping(3)
		end
		if at <= 15 then
			wait_frames_skipping(20)
		end
		if at <= 16 then
			helper_52aadc70(40080, 30)
		end
		if at <= 17 then
			wait_frames_skipping(10)
		end
		if at <= 18 then
			var2 = 0
			wait_frames_skipping(40 - var2)
		end
		if at <= 19 then
			wait_frames_skipping(46)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			wait_frames_skipping(30)
		end
		if at <= 22 then
			helper_238b5abc(0)
		end
		if at <= 23 then
			wait_frames_skipping(30)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 33)
	event.stop_sound_effect(var1, 27)
	event.stop_sound_effect(var1, 28)
	event.close_voice_stream(1)
	event.load_message_file(0, -1)
	event.load_map_sounds(1217)
	event.stop_port_sound_effects(4)
	for var3 = 0, 31 do
		event.clear_object_sequence(var3)
	end
	event.set_camera_look_at(0.0, 33.8, 6.0)
	event.set_camera_position(0.0, 38.8, 86.0)
	event.reset_follow_camera(0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(8)
	event.set_character_active(1, 0)
	event.detach_character_from_frame(0)
	event.set_character_position(0, 0.0, 8.8, 6.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "バトル立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(21, 1)
	event.set_object_handle_visible(21, 1)
	event.attach_object_handle_to_character(21, 2)
	event.set_object_handle_visible(21, 0)
	event.initialize_sound_port(4)
	event.assign_memory_stack(3)
	event.clear_memory_stack(3)
	event.load_dungeon_monster(600, 1)
	event.place_dungeon_monster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
	event.place_dungeon_monster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
	event.place_dungeon_monster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
	event.place_dungeon_monster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
	var0 = event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json") or var0
	event.play_sound_effect(var0, 0)
	at = 26
	vm.wait(26)
	event.set_dungeon_pause_flags(16384, 1)
	var4 = event.get_sound_id(4) or var4
	event.set_action_character_second_sound_bank(0, var4)
	event.copy_action_character_sound_to_parts(0)
	event.set_dungeon_pause_flags(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_bb8bad3f
