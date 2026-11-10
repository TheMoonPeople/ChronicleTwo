--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_fe9d3952(arg0: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local language_code_2: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		helper_ce85b54c()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
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
			block = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or block
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
		var3 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var3
		var4 = event.get_event_sound_bank(4) or var4
		event.stop_sound_effect(var4, 0)
		event.stop_music(0)
		event.play_sound_effect(var3, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local out1, out2, out3 = event.get_camera_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		if arg0 == 2 then
			event.set_follow_camera_target_alternate(var5, var6 + 40.0, var7)
		else
			event.set_follow_camera_target_alternate(var5, var6 + 20.0, var7)
		end
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(10.0)
		event.set_follow_camera_distance(64.0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.turn_object_sequence_toward(0, pos_x, pos_y, pos_z, 10)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_scale(1, 1.0, 1.0, 0, 60)
		event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
		wait_frames(90)
		language_code_2 = event.get_language() or language_code_2
		if language_code_2 == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 214.0, 370.0, 0, 20)
		end
		wait_frames(70)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.set_camera_control_enabled(1)
	event.fade_in_screen(1)
	event.stop_sound_effect(var3, 0)
	event.load_music(193)
	event.play_music(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

return helper_fe9d3952
