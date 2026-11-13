--!strict
--- Staging for the dungeon system scripts: extermination victory scenes, miss gestures, running away and the robot breakdown.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local dungeon_system_scripts_message = vm.module("@lib/event/dungeon_system_scripts_message")
local minigame = vm.module("@lib/event/minigame")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local dungeon_system_scripts_cutscene = {}

--- Does nothing; kept as a placeholder step in the dungeon scripts.
function dungeon_system_scripts_cutscene.noop(unused_value: s32) end

--- Plays the playable character's victory scene after a dungeon extermination and shows the closing messages.
function dungeon_system_scripts_cutscene.play_extermination_clear_event()
	local playable_character: s32 = 0
	local is_e3: s32 = 0
	local stage_id: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local closing_position_x: f32 = 0
	local closing_position_y: f32 = 0
	local closing_position_z: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		character.set_idle_motion()
		if playable_character == 0 then
			resume_step = 1
			dungeon_system_scripts_cutscene.play_max_victory()
		end
		if playable_character == 1 then
			resume_step = 2
			dungeon_system_scripts_cutscene.play_monica_victory()
		end
		if playable_character == 2 or playable_character == 3 then
			resume_step = 3
			dungeon_system_scripts_cutscene.play_follow_camera_victory(playable_character)
		end
		is_e3 = event.is_e3_version() or is_e3
		if is_e3 ~= 1 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			event.get_dungeon_floor()
			if stage_id ~= 3 then
				minigame.set_up_sphida_course(0)
				do
					local out1, out2, out3 = event.get_previous_camera_next_position()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.set_camera_position(position_x, position_y, position_z)
				do
					local out1, out2, out3 = event.get_previous_camera_next_look_at()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.set_camera_look_at(position_x, position_y, position_z)
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				resume_step = 4
				dungeon_system_scripts_message.show_and_wait(0, 2100, 8, 0, 0)
				event.set_message_window_mode(0, 1)
				event.set_message_draw_speed(0, 0)
			end
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			closing_position_x = out1 or closing_position_x
			closing_position_y = out2 or closing_position_y
			closing_position_z = out3 or closing_position_z
		end
		event.set_camera_position(closing_position_x, closing_position_y, closing_position_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			closing_position_x = out1 or closing_position_x
			closing_position_y = out2 or closing_position_y
			closing_position_z = out3 or closing_position_z
		end
		event.set_camera_look_at(closing_position_x, closing_position_y, closing_position_z)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		resume_step = 5
		dungeon_system_scripts_message.show_and_wait(0, 2130, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step <= 1 then
				resume_step = 2
				dungeon_system_scripts_cutscene.play_monica_victory()
				return vm.continue_with(function()
					if playable_character == 2 or playable_character == 3 then
						resume_step = 3
						dungeon_system_scripts_cutscene.play_follow_camera_victory(playable_character)
					end
					is_e3 = event.is_e3_version() or is_e3
					if is_e3 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							minigame.set_up_sphida_course(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_position(position_x, position_y, position_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_look_at(position_x, position_y, position_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							resume_step = 4
							dungeon_system_scripts_message.show_and_wait(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						closing_position_x = out1 or closing_position_x
						closing_position_y = out2 or closing_position_y
						closing_position_z = out3 or closing_position_z
					end
					event.set_camera_position(closing_position_x, closing_position_y, closing_position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						closing_position_x = out1 or closing_position_x
						closing_position_y = out2 or closing_position_y
						closing_position_z = out3 or closing_position_z
					end
					event.set_camera_look_at(closing_position_x, closing_position_y, closing_position_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					resume_step = 5
					dungeon_system_scripts_message.show_and_wait(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				dungeon_system_scripts_cutscene.play_follow_camera_victory(playable_character)
				return vm.continue_with(function()
					is_e3 = event.is_e3_version() or is_e3
					if is_e3 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							minigame.set_up_sphida_course(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_position(position_x, position_y, position_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_look_at(position_x, position_y, position_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							resume_step = 4
							dungeon_system_scripts_message.show_and_wait(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						closing_position_x = out1 or closing_position_x
						closing_position_y = out2 or closing_position_y
						closing_position_z = out3 or closing_position_z
					end
					event.set_camera_position(closing_position_x, closing_position_y, closing_position_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						closing_position_x = out1 or closing_position_x
						closing_position_y = out2 or closing_position_y
						closing_position_z = out3 or closing_position_z
					end
					event.set_camera_look_at(closing_position_x, closing_position_y, closing_position_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					resume_step = 5
					dungeon_system_scripts_message.show_and_wait(0, 2130, 8, 0, 0)
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if resume_step <= 3 then
				dungeon_system_scripts_cutscene.noop(0)
				dungeon_system_scripts_message.finish_on_skip(0, 2100, 8, 0, 0)
			end
			if resume_step <= 4 then
				dungeon_system_scripts_message.finish_on_skip(0, 2130, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the victory scene for the remaining characters with a follow camera and the finish banner.
function dungeon_system_scripts_cutscene.play_follow_camera_victory(playable_character: s32)
	local image_block: s32 = 0
	local image_language: s32 = 0
	local victory_sound: s32 = 0
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local banner_language: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		character.set_idle_motion()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		image_language = event.get_language() or image_language
		if image_language == 0 then
			image_block = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or image_block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", image_block)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 228, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 255, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
		else
			image_block = event.load_event_image_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or image_block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", image_block)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 512, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 512, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
		end
		victory_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or victory_sound
		sound_bank = event.get_event_sound_bank(4) or sound_bank
		event.stop_sound_effect(sound_bank, 0)
		event.stop_music(0)
		event.play_sound_effect(victory_sound, 0)
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
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		if playable_character == 2 then
			event.set_follow_camera_target_alternate(character_x, character_y + 40.0, character_z)
		else
			event.set_follow_camera_target_alternate(character_x, character_y + 20.0, character_z)
		end
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(10.0)
		event.set_follow_camera_distance(64.0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.turn_object_sequence_toward(0, camera_x, camera_y, camera_z, 10)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_scale(1, 1.0, 1.0, 0, 60)
		event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
		wait.for_frame_count(90)
		banner_language = event.get_language() or banner_language
		if banner_language == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 154.0, 370.0, 0, 20)
		end
		wait.for_frame_count(70)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.set_camera_control_enabled(1)
	event.fade_in_screen(1)
	event.stop_sound_effect(victory_sound, 0)
	event.play_music(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

--- Plays the first character's victory pose with a follow camera and the finish banner.
function dungeon_system_scripts_cutscene.play_max_victory()
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local character_rotation_y: f32 = 0
	local victory_sound: s32 = 0
	local image_block: s32 = 0
	local image_language: s32 = 0
	local banner_language: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.enable_drama_skip()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			character_rotation_y = out2 or character_rotation_y
		end
		event.set_event_world_coordinate(character_x, character_y, character_z, character_rotation_y)
		victory_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or victory_sound
		event.load_character_motion_pack(5, "dungeon/chara/c01b_win.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.stop_music(0)
		event.play_sound_effect(victory_sound, 0)
		event.set_object_sequence_motion(0, "勝利のポーズ", 6)
		event.delay_object_sequence_motion_track(0, 1)
		event.queue_object_sequence_next_motion(0, "勝利のポーズL", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 2.8, -5.0, 70.0, "", 1)
		event.move_camera_sequence_angle_height_distance(-0.24, -5.0, 70.0, 120)
		event.slow_down_camera_sequence_angle(0.9, 30)
		event.wait_object_sequence_motion_end(0)
		image_language = event.get_language() or image_language
		if image_language == 0 then
			image_block = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or image_block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", image_block)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 228, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 255, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
		else
			image_block = event.load_event_image_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or image_block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", image_block)
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
		wait.for_frame_count(90)
		banner_language = event.get_language() or banner_language
		if banner_language == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 154.0, 370.0, 0, 20)
		end
		camera.wait_until_done()
		wait.for_frame_count(20)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(victory_sound, 0)
	event.play_music(0)
	event.release_camera_sequence_follow_object()
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the no-good miss gesture for the first two characters and waits one frame for the others.
function dungeon_system_scripts_cutscene.play_miss_gesture()
	local playable_character: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if playable_character == 2 or playable_character == 3 then
		vm.wait(1)
		event.finish_event()
		return
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	event.turn_object_sequence_toward(0, camera_x, camera_y, camera_z, 6)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "だめだめ", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	object.wait_until_done(0)
	event.finish_event()
end

--- Plays the no-good miss gesture for the first two characters and waits one or two frames for the others.
function dungeon_system_scripts_cutscene.play_miss_gesture_short_wait()
	local playable_character: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if playable_character == 2 then
		vm.wait(1)
		event.finish_event()
		return
	end
	if playable_character == 3 then
		vm.wait(2)
		event.finish_event()
		return
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	event.turn_object_sequence_toward(0, camera_x, camera_y, camera_z, 6)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "だめだめ", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	object.wait_until_done(0)
	event.finish_event()
end

--- Plays the second character's victory pose with a sweeping camera path and the finish banner.
function dungeon_system_scripts_cutscene.play_monica_victory()
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local character_rotation_y: f32 = 0
	local victory_sound: s32 = 0
	local sound_bank: s32 = 0
	local image_block: s32 = 0
	local image_language: s32 = 0
	local banner_language: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			character_rotation_y = out2 or character_rotation_y
		end
		event.set_event_world_coordinate(character_x, character_y, character_z, character_rotation_y)
		event.load_character_motion_pack(5, "dungeon/chara/c02a_win.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		victory_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or victory_sound
		sound_bank = event.get_event_sound_bank(4) or sound_bank
		event.stop_sound_effect(sound_bank, 0)
		event.stop_music(0)
		event.play_sound_effect(victory_sound, 0)
		image_language = event.get_language() or image_language
		if image_language == 0 then
			image_block = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or image_block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", image_block)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 228, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 255, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
		else
			image_block = event.load_event_image_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or image_block
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", image_block)
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
		wait.for_frame_count(90)
		banner_language = event.get_language() or banner_language
		if banner_language == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 154.0, 370.0, 0, 20)
		end
		camera.wait_until_done()
		wait.for_frame_count(20)
		event.play_music(0)
		event.release_camera_sequence_follow_object()
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.fade_in_screen(1)
	event.stop_sound_effect(victory_sound, 0)
	event.play_music(0)
	event.release_camera_sequence_follow_object()
	event.delete_character_extension_packs(0)
	event.reset_object_handle_dynamic_animation(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

--- Plays the robot breakdown effect and music, then opens the character change menu or ends the demo.
function dungeon_system_scripts_cutscene.play_robot_breakdown_event()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	local music_number: s32 = 0
	local music_volume: f32 = 0
	local current_character: s32 = 0
	local is_e3: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 then
		event.set_character_motion(0, "故障", 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("ロボ故障")
		event.create_effect_work_buffer(5)
	end
	sound_bank = event.get_event_sound_bank(4) or sound_bank
	event.stop_sound_effect(sound_bank, 0)
	event.set_dungeon_pause_flags(17, 1)
	event.create_effect("ロボ故障")
	music_number = event.get_active_music_number() or music_number
	music_volume = vm.bits_float(event.get_music_master_volume()) or music_volume
	event.stop_music(0)
	event.start_background_file_loads_1("snd2/bgm/bg_060.sound.json")
	wait.for_frame_count(4)
	wait.background_load()
	event.load_music_pack(60)
	event.play_music(0)
	current_character = event.get_playable_character() or current_character
	dungeon_system_scripts_message.show_character_text(current_character)
	if playable_character == 2 or playable_character == 3 then
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.clear_effect_manager()
		event.open_dungeon_character_change_menu(-1)
		vm.wait(5)
	else
		is_e3 = event.is_e3_version() or is_e3
		if is_e3 == 1 then
			event.fade_out_screen(30)
			wait.for_frame_count(30)
			event.set_scene_exit_flag(1)
			return
		else
			event.run_dungeon_debug_command(0)
		end
	end
	event.stop_music(0)
	event.clear_effect_manager()
	event.set_dungeon_pause_flags(17, 1)
	wait.for_frame_count(4)
	event.load_music(music_number)
	event.play_music(0)
	event.set_music_master_volume(music_volume)
	event.play_sound_effect(sound_bank, 0)
	event.set_dungeon_pause_flags(17, 0)
	event.finish_event()
end

--- Makes the player run away from a fixed camera and fades the screen out.
function dungeon_system_scripts_cutscene.run_away_and_fade_out()
	local world_x: f32 = 0
	local world_y: f32 = 0
	local world_z: f32 = 0
	local facing_angle: f32 = 0
	event.initialize_event()
	world_x, world_y, world_z, facing_angle =
		object.get_trigger_placement(world_x, world_y, world_z, facing_angle)
	facing_angle = vm.f32(facing_angle + vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_event_world_coordinate(world_x, world_y, world_z, facing_angle)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.reset_object_sequence_dynamic_animation(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(56.71, 54.78, -129.16)
	event.set_camera_sequence_look_at(-1.53, 22.52, 48.82)
	event.move_object_sequence(0, 0.0, 0.0, 155.0, 40)
	event.set_object_sequence_motion(0, "走り", 4)
	wait.for_frame_count(10)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.finish_event()
end

return dungeon_system_scripts_cutscene
