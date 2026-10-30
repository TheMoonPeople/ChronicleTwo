--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_camera = require("@lib/event/wait_camera")

--- Helper function.
local function helper_2f6f8a35()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local block: s32 = 0
	local language_code: s32 = 0
	local language_code_2: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			var3 = out2 or var3
		end
		event.set_event_world_coordinate(var0, var1, var2, var3)
		event.load_character_motion_pack(5, "dungeon/chara/c02a_win.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		var6 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var6
		var7 = event.get_event_sound_bank(4) or var7
		event.stop_sound_effect(var7, 0)
		event.stop_music(0)
		event.play_sound_effect(var6, 0)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			block = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", block)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 228, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 255, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
		else
			block = event.load_event_image_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", block)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 512, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 512, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
		end
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_motion(0, "勝利のポーズ", 6)
		event.queue_object_sequence_next_motion(0, "勝利のポーズL", 6, 0.04)
		event.queue_object_sequence_next_motion(0, "余韻", 6)
		event.queue_object_sequence_next_motion(0, "余韻L", 4)
		event.clear_camera_sequence()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(160)
		event.add_camera_sequence_path_point(-21.28, 37.75, 24.27, -2.96, 23.12, 7.37)
		event.add_camera_sequence_path_point(-28.52, 37.89, 34.83, -2.96, 21.14, 7.37)
		event.add_camera_sequence_path_point(-28.68, 24.7, 45.16, -2.96, 19.14, 7.37)
		event.add_camera_sequence_path_point(-22.33, 14.47, 62.16, -2.96, 17.14, 7.37)
		event.add_camera_sequence_path_point(1.46, 10.46, 71.87, -2.96, 16.14, 7.37)
		event.add_camera_sequence_path_point(30.68, 10.46, 61.53, -2.96, 15.14, 7.37)
		event.add_camera_sequence_path_point(38.91, 13.26, 35.51, 4.6, 14.7, -11.02)
		event.start_camera_sequence_path()
		event.move_camera_sequence(36.58, 13.26, 32.4, 4.6, 14.7, -11.02, 60)
		event.set_object_sequence_scale(1, 1.0, 1.0, 0, 60)
		event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
		helper_888ab2a3(90)
		language_code_2 = event.get_language() or language_code_2
		if language_code_2 == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 154.0, 370.0, 0, 20)
		end
		wait_camera()
		helper_888ab2a3(20)
		event.play_music(0)
		event.release_camera_sequence_follow_object()
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.fade_in_screen(1)
	event.stop_sound_effect(var6, 0)
	event.play_music(0)
	event.release_camera_sequence_follow_object()
	event.delete_character_extension_packs(0)
	event.reset_object_handle_dynamic_animation(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

return helper_2f6f8a35
