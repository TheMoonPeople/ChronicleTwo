--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_camera = require("@lib/event/wait_camera")

--- Helper function.
local function helper_99d04251()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: s32 = 0
	local block: s32 = 0
	local language_code: s32 = 0
	local language_code_2: s32 = 0
	vm.section(function()
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
		var6 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var6
		event.load_character_motion_pack(5, "dungeon/chara/c01b_win.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.stop_music(0)
		event.play_sound_effect(var6, 0)
		event.set_object_sequence_motion(0, "勝利のポーズ", 6)
		event.delay_object_sequence_motion_track(0, 1)
		event.queue_object_sequence_next_motion(0, "勝利のポーズL", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 2.8, -5.0, 70.0, "", 1)
		event.move_camera_sequence_angle_height_distance(-0.24, -5.0, 70.0, 120)
		event.slow_down_camera_sequence_angle(0.9, 30)
		event.wait_object_sequence_motion_end(0)
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
		event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
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
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var6, 0)
	event.play_music(0)
	event.release_camera_sequence_follow_object()
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	event.start_crossfade(15)
	event.finish_event()
end

return helper_99d04251
