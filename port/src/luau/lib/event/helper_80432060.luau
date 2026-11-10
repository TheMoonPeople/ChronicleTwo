--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_80432060()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var5: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(416, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		wait_frames(6)
		event.load_music(30)
		event.load_map_sounds(4809)
		var0 = event.load_sound_effect_file_2(4809) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e416/")
		event.load_message_file(0, 5, "e416_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e416_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e416_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		block = event.load_event_image_4(5, "e416telop01_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e416telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(7, 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 7)
		event.change_directory("")
		event.load_character(5, "event/e400/e410/e410_shigu.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e400/e410/mariometto_a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_character_to_frame(10, "metto_null", 11)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e416/e416_mints.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e416/e416_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_handle_position(0, -65.0, -38.28, 1157.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, -85.0, -38.13, 1157.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, -78.11, -15.13, 426.88)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "威嚇", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "赤目パチ")
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(3)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			var5 = out3 or var5
		end
		do
			local out1, out2, out3 = event.copy_vector(rot_x, rot_y, var5)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(4)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var5 = vm.f32(vector_z - vm.f32(3.1415927))
		var5 = event.wrap_angle(var5) or var5
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-228.84, 94.46, 882.3)
		event.set_camera_sequence_look_at(-94.17, 38.37, 1068.72)
		event.rotate_object_sequence_eased(3, rot_x, rot_y, var5, 40, 0, 0.5)
		event.delay_object_sequence_position_track(4, 80)
		event.move_object_sequence_eased(4, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		event.delay_object_sequence_position_track(0, 100)
		event.move_object_sequence(0, -65.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(0, 100)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(1, 110)
		event.move_object_sequence(1, -85.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(1, 110)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		at = 3
		wait_frames(30)
		event.play_sound_effect(var0, 0)
		at = 4
		wait_objects(1)
		at = 5
		wait_frames(10)
		event.set_camera_sequence_position(-70.27, 35.0, 783.66)
		event.set_camera_sequence_look_at(-73.25, 38.33, 674.48)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(5, 128, 128, 128, 128, 30)
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_position(0, -50.18, 3.08, 671.54)
		event.set_object_sequence_rotation(0, 0.0, -2.9, 0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -96.49, 3.79, 674.91)
		event.set_object_sequence_rotation(1, 0.0, 2.78, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.play_music(0)
		at = 6
		helper_4116e6bb(4160010)
		event.set_event_sprite_draw_pass(0, 0)
		event.stop_sound_effect(var0, 1)
		event.set_camera_sequence_position(-29.56, 15.56, 642.62)
		event.set_camera_sequence_look_at(-64.62, 25.05, 676.95)
		event.set_object_sequence_motion(0, "間抜け立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, -78.55, 3.48, 677.41)
		event.set_object_sequence_rotation(1, 0.0, 2.3, 0.0)
		event.set_object_sequence_motion(1, "指差し", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "指差し会話", 6)
		event.queue_object_sequence_next_motion(1, "指差しＬ", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 7
		helper_4116e6bb(4160020)
		at = 8
		wait_objects(1)
		event.set_object_sequence_motion(0, "うん！", 2)
		event.queue_object_sequence_next_motion(0, "間抜け立ち", 4)
		at = 9
		wait_frames(10)
		event.play_sound_effect(var0, 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(4160030)
		at = 11
		wait_objects(0)
		event.fade_out_screen(30)
		at = 12
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(6)
		end
		if at <= 2 then
			var5 = vm.f32(vector_z - vm.f32(3.1415927))
			wait_frames_skipping(30)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			wait_frames_skipping(10)
		end
		if at <= 5 then
			helper_8cd371d7(4160010)
		end
		if at <= 6 then
			helper_8cd371d7(4160020)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			wait_frames_skipping(10)
		end
		if at <= 9 then
			helper_8cd371d7(4160030)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.stop_sound_effect(var0, 1)
	event.stop_sound_effect(var0, 2)
	event.set_event_sprite_draw_pass(0, 0)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_rotation(3, vector_x, vector_y, vector_z)
	event.set_object_handle_position(4, pos_x, pos_y, pos_z)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	event.set_character_position(0, -96.2, 1.8, 851.5)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_look_at(-96.2, 31.8, 851.5)
	event.set_camera_position(-96.2, 41.8, 951.5)
	event.reset_follow_camera(0)
	at = 14
	vm.wait(14)
	event.load_dungeon_monster(516, 1)
	event.load_dungeon_monster(1001, 0)
	event.place_dungeon_monster(516, -78.11, -15.13, 426.88, 0.0, 0.0, 0.0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_80432060
