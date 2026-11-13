--!strict
--- Japanese-version dungeon victory finish scene.

local vm = require("@lib/vm")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local dungeon_victory = {}

--- Plays the victory pose and finish banner after a dungeon battle ends.
function dungeon_victory.play_victory_finish(draw_pass: s32)
	local language_code: s32 = 0
	local block: s32 = 0
	local sound_effect: s32 = 0
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local facing_angle: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.initialize_event()
		if draw_pass == 0 then
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
				"dungeon/image/senmetsu/usa/finish.img",
				"snd2/sp/sp_000.sound.json"
			)
		end
		step = 2
		vm.wait(2)
		step = 3
		wait.background_load()
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
			event.set_event_sprite_draw_pass(0, draw_pass)
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
			event.set_event_sprite_draw_pass(0, draw_pass)
		end
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_effect
		sound_bank = event.get_event_sound_bank(4) or sound_bank
		event.stop_sound_effect(sound_bank, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		do
			local out1, out2, out3 = event.get_camera_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		facing_angle = event.get_direction_angle(character_x, character_y, character_z, camera_x, camera_y, camera_z) or facing_angle
		facing_angle = vm.f32(facing_angle + vm.f32(0.4))
		facing_angle = event.wrap_angle(facing_angle) or facing_angle
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 16.0, character_z)
		event.set_camera_speed(14.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-4.0)
		event.set_follow_camera_distance(48.0)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "目パチ")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_rotation(0, 0.0, facing_angle, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.start_crossfade(30)
		event.stop_music(0)
		event.play_sound_effect(sound_effect, 0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "勝利のポーズ", 6)
		event.queue_object_sequence_next_motion(0, "勝利のポーズL", 6, 0.04)
		event.queue_object_sequence_next_motion(0, "余韻", 6)
		event.queue_object_sequence_next_motion(0, "余韻L", 4)
		event.set_object_sequence_scale(1, 1.0, 1.0, 0, 60)
		event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
		step = 4
		wait.for_frame_count(90)
		if language_code == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 154.0, 370.0, 0, 20)
		end
		event.set_mouth_texture_animations(0, "わらい口パク")
		step = 5
		sound.play_voice_for(8510170, -1)
		step = 6
		wait.for_frame_count(20)
	end, function(received: { any }): boolean
		if step <= 2 then
			wait.background_load_skipping()
		end
		if step <= 3 then
			facing_angle = vm.f32(facing_angle + vm.f32(0.4))
			wait.skip_frame_count(90)
		end
		if step <= 4 then
			sound.play_voice_for_skipping(8510170, -1)
		end
		if step <= 5 then
			wait.skip_frame_count(20)
		end
		return true
	end)
	step = 7
	vm.entry(7)
	event.cancel_drama_scene_skip()
	if draw_pass == 0 then
		event.show_dungeon_status_bar(1, 1.0)
	end
	event.set_camera_control_enabled(1)
	event.stop_port_sound_effects(7)
	event.stop_sound_effect(sound_effect, 0)
	event.load_music(193)
	event.play_music(0)
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

return dungeon_victory
