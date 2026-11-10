--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_4bd79732 = require("@lib/event/helper_4bd79732")
local helper_ec06cf84 = require("@lib/event/helper_ec06cf84")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_6c8af328(value: s32)
	local language_code: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		if value == 0 then
			event.show_dungeon_status_bar(0, 1.0)
		end
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.start_background_file_loads_3(
				"dungeon/chara/c02a_win.gltf",
				"textures/dungeon/image/senmetsu/finish.json",
				"snd2/sp/sp_000.sound.json"
			)
		else
			event.start_background_file_loads_3(
				"dungeon/chara/c02a_win.gltf",
				"textures/dungeon/image/senmetsu/finish_1.json",
				"snd2/sp/sp_000.sound.json"
			)
		end
		at = 2
		vm.wait(2)
		at = 3
		helper_479dc9e9()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character_motion_pack(5, "dungeon/chara/c02a_win.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
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
			event.set_event_sprite_draw_pass(0, value)
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
			event.set_event_sprite_draw_pass(0, value)
		end
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		var3 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var3
		var4 = event.get_event_sound_bank(4) or var4
		event.stop_sound_effect(var4, 0)
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
		var11 = event.get_direction_angle(var5, var6, var7, pos_x, pos_y, pos_z) or var11
		var11 = vm.f32(var11 + vm.f32(0.4))
		var11 = event.wrap_angle(var11) or var11
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(var5, var6 + 16.0, var7)
		event.set_camera_speed(14.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-4.0)
		event.set_follow_camera_distance(48.0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "目パチ")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_rotation(0, 0.0, var11, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.start_crossfade(30)
		event.stop_music(0)
		event.play_sound_effect(var3, 0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "勝利のポーズ", 6)
		event.queue_object_sequence_next_motion(0, "勝利のポーズL", 6, 0.04)
		event.queue_object_sequence_next_motion(0, "余韻", 6)
		event.queue_object_sequence_next_motion(0, "余韻L", 4)
		event.set_object_sequence_scale(1, 1.0, 1.0, 0, 60)
		event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
		at = 4
		wait_frames(90)
		if language_code == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 214.0, 370.0, 0, 20)
		end
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 5
		helper_4bd79732(8510170, -1)
		at = 6
		wait_frames(20)
	end, function(received: { any }): boolean
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			var11 = vm.f32(var11 + vm.f32(0.4))
			wait_frames_skipping(90)
		end
		if at <= 4 then
			helper_ec06cf84(8510170, -1)
		end
		if at <= 5 then
			wait_frames_skipping(20)
		end
		return true
	end)
	at = 7
	vm.entry(7)
	event.cancel_drama_scene_skip()
	if value == 0 then
		event.show_dungeon_status_bar(1, 1.0)
	end
	event.set_camera_control_enabled(1)
	event.stop_port_sound_effects(7)
	event.stop_sound_effect(var3, 0)
	event.load_music(193)
	event.play_music(0)
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

return helper_6c8af328
