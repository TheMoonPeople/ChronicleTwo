--!strict
--- Runs dungeon floor bookkeeping and the party defeat sequence.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local party = vm.module("@lib/event/party")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local dungeon = {}

--- Asks whether to leave and fades out when confirmed, returning 1 when leaving.
function dungeon.confirm_exit()
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_step = 1
		answer = message.ask_yes_no(4, -1)
		if answer == 0 then
			event.fade_out_screen(30)
			resume_step = 2
			wait.for_frame_count(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		return nil
	end)
end

--- Asks whether to leave and fades out when confirmed, returning 1 when leaving, using wait_frames.
function dungeon.confirm_exit_variant()
	local answer: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_step = 1
		answer = message.ask_yes_no(4, -1)
		if answer == 0 then
			event.fade_out_screen(30)
			resume_step = 2
			wait.frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			if resume_step <= 1 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Runs the game over sequence after the party is defeated and returns 1 when the party revives.
function dungeon.handle_defeat(revive_party: s32, voice_id: s32)
	local battle_pause_flags: s32 = 0
	local is_boss_floor: s32 = 0
	local battle_bgm_sound_id: s32 = 0
	local battle_bgm_playing: s32 = 0
	local battle_bgm_volume: s32 = 0
	local playable_character: s32 = 0
	local change_state: s32 = 0
	local image_block: s32 = 0
	local partner_change_state: s32 = 0
	local is_debug_enabled: s32 = 0
	local saved_music_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		battle_pause_flags = event.get_dungeon_pause_flags(16384) or battle_pause_flags
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16384, 1)
		end
		is_boss_floor = event.is_dungeon_boss_floor() or is_boss_floor
		event.save_music_status(-1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			battle_bgm_sound_id = event.get_event_sound_bank(4) or battle_bgm_sound_id
			battle_bgm_playing = event.get_sound_effect_status(battle_bgm_sound_id, 0) or battle_bgm_playing
			battle_bgm_volume = event.get_battle_music_volume() or battle_bgm_volume
			event.stop_sound_effect(battle_bgm_sound_id, 0)
			print("---------------------------------------------BATTLE BGM STOP\n")
		end
		event.stop_music(0)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 or playable_character == 1 then
			event.set_character_texture_animation(0, 0, "目パチ")
			event.set_character_texture_animation(0, 1, "死に")
		end
		if playable_character == 2 then
			event.set_action_character_motion(0, "故障", 6)
			event.initialize_effect_manager(5, 1)
			event.load_effect_base("ロボ故障")
			event.create_effect_work_buffer(5)
			event.create_effect("ロボ故障")
		end
		change_state = 0
		if playable_character == 2 then
			change_state = event.get_character_change_state(0) or change_state
			if change_state == 0 then
				change_state = event.get_character_change_state(1) or change_state
			end
		end
		if playable_character == 0 then
			change_state = event.get_character_change_state(1) or change_state
		end
		if playable_character == 1 then
			change_state = event.get_character_change_state(0) or change_state
		end
		if playable_character == 3 then
			change_state = event.get_character_change_state(1) or change_state
			if change_state == 0 then
				change_state = event.get_character_change_state(0) or change_state
			end
		end
		event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
		resume_step = 1
		wait.for_frame_count(30)
		event.show_dungeon_status_bar(0, 0.06666667)
		resume_step = 2
		wait.background_load()
		event.load_music_pack(60)
		if change_state == 1 or change_state ~= 1 and voice_id < 0 then
			event.play_music(0)
		end
		resume_step = 3
		wait.for_frame_count(30)
		event.set_dungeon_pause_flags(1, 1)
		event.reset_dungeon_collision_primitives()
		if change_state ~= 1 then
			image_block = event.load_event_image_4(5, "textures/dungeon/image/gameover.json", 1) or image_block
			if voice_id >= 0 then
				resume_step = 4
				sound.play_voice_line_stopping(voice_id, -1)
				resume_step = 5
				wait.for_frame_count(10)
				event.play_music(0)
			end
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "gameover1", image_block)
			event.set_event_sprite_color(0, 128, 128, 128, 128)
			event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
			event.set_event_sprite_size(0, 576, 128)
			event.set_event_sprite_position(0, -320, 208)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.move_object_sequence(0, 288, 208, 0.0, 20)
			resume_step = 6
			wait.for_frame_count(30)
			event.reset_event_sprite(1)
			event.set_event_sprite_type(1, 0)
			event.set_event_sprite_texture(1, "gameover1", image_block)
			event.set_event_sprite_color(1, 128, 128, 128, 0)
			event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
			event.set_event_sprite_size(1, 576, 64)
			event.set_event_sprite_position(1, 256, 208)
			event.set_event_sprite_draw_pass(1, 1)
			event.attach_object_handle_to_sprite(1, 1)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
			resume_step = 7
			wait.for_frame_count(120)
			while true do
				if wait.get_button_state(0) ~= 0 then
					break
				end
				resume_step = 8
				vm.wait(8)
			end
		elseif playable_character == 3 then
			partner_change_state = event.get_character_change_state(1) or partner_change_state
			if partner_change_state == 0 then
				resume_step = 9
				message.show_defeat_message(1)
			else
				resume_step = 10
				message.show_defeat_message(4)
			end
		elseif playable_character == 0 or playable_character == 2 then
			resume_step = 11
			message.show_defeat_message(playable_character)
		else
			resume_step = 12
			message.show_defeat_message(1)
		end
		is_debug_enabled = event.get_debug_flag() or is_debug_enabled
		if is_debug_enabled == 1 then
			event.run_dungeon_debug_command(0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			if playable_character == 0 or playable_character == 1 then
				event.set_character_texture_animation(0, 0, "死に")
				event.set_character_texture_animation(0, 1, "目パチ")
			end
			event.reset_action_character_motion(0, 4)
		elseif change_state == 1 then
			event.fade_out_screen(30)
			resume_step = 13
			wait.for_frame_count(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.open_dungeon_character_change_menu(-1)
			resume_step = 14
			vm.wait(14)
			event.fade_out_screen(0)
		else
			event.fade_out_music(30)
			event.fade_out_screen(30)
			resume_step = 15
			wait.for_frame_count(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.stop_music(0)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_event_sprite_draw_pass(1, 0)
			event.delete_event_image(1)
			if revive_party == 1 then
				event.add_hp_by_rate(1.0, 0)
				event.add_battle_weapon_durability(0, 999)
				event.add_battle_weapon_durability(1, 999)
				event.run_dungeon_event(-1)
				event.clear_event_battle_monsters(-1)
				event.set_dungeon_pause_flags(1, 0)
				event.finish_event()
				return 1
			else
				event.set_scene_exit_flag(1)
				event.finish_event()
				return 0
			end
		end
		event.stop_music(0)
		resume_step = 16
		wait.for_frame_count(4)
		saved_music_number = event.get_saved_music_number() or saved_music_number
		event.load_music(saved_music_number)
		print("---------------------------------------------DEAD RELOAD_BGM = ", saved_music_number, "\n")
		print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
		event.restore_music_status(-1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			if battle_bgm_playing == 1 then
				print("---------------------------------------------BATTLE BGM PLAY\n")
				event.play_sound_effect(battle_bgm_sound_id, 0)
				event.set_sound_effect_volume(battle_bgm_sound_id, 0, battle_bgm_volume)
			end
		end
		event.set_camera_control_enabled(1)
		event.show_dungeon_status_bar(1, 1.0)
		if is_debug_enabled ~= 1 then
			event.fade_in_screen(10)
		end
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16385, 0)
		else
			event.set_dungeon_pause_flags(1, 0)
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if resume_step <= 15 then
			if resume_step <= 1 then
				wait.background_load_skipping()
			end
			if resume_step <= 2 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 3 then
				sound.play_voice_for_skipping(voice_id, -1)
			end
			if resume_step <= 4 then
				wait.skip_frame_count(10)
			end
			if resume_step <= 5 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 6 then
				wait.skip_frame_count(120)
			end
			if resume_step <= 8 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 9 then
				local _ = party.get_change_state_skipping(0)
				message.show_defeat_message_skipping(4)
			end
			if resume_step <= 10 then
				message.show_defeat_message_skipping(playable_character)
			end
			if resume_step <= 11 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 12 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 14 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_step <= 16 then
			print("---------------------------------------------DEAD RELOAD_BGM = ", saved_music_number, "\n")
			print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
			print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
			print("---------------------------------------------BATTLE BGM PLAY\n")
			return 0
		end
		return nil
	end)
end

--- Runs the defeat sequence without a voice line and returns 1 when the party revives.
function dungeon.handle_defeat_silent(revive_party: s32)
	return dungeon.handle_defeat(revive_party, -1)
end

--- Runs the defeat sequence with a voice line.
function dungeon.handle_defeat_voiced(revive_party: s32, voice_id: s32)
	return dungeon.handle_defeat(revive_party, voice_id)
end

--- Runs the game over sequence with the boss defeat dialogue and returns 1 when the party revives.
function dungeon.handle_defeat_with_dialogue(revive_party: s32, voice_id: s32)
	local battle_pause_flags: s32 = 0
	local is_boss_floor: s32 = 0
	local battle_bgm_sound_id: s32 = 0
	local battle_bgm_playing: s32 = 0
	local battle_bgm_volume: s32 = 0
	local playable_character: s32 = 0
	local change_state: s32 = 0
	local image_block: s32 = 0
	local partner_change_state: s32 = 0
	local is_debug_enabled: s32 = 0
	local saved_music_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		battle_pause_flags = event.get_dungeon_pause_flags(16384) or battle_pause_flags
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16384, 1)
		end
		is_boss_floor = event.is_dungeon_boss_floor() or is_boss_floor
		event.save_music_status(-1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			battle_bgm_sound_id = event.get_event_sound_bank(4) or battle_bgm_sound_id
			battle_bgm_playing = event.get_sound_effect_status(battle_bgm_sound_id, 0) or battle_bgm_playing
			battle_bgm_volume = event.get_battle_music_volume() or battle_bgm_volume
			event.stop_sound_effect(battle_bgm_sound_id, 0)
			print("---------------------------------------------BATTLE BGM STOP\n")
		end
		event.stop_music(0)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 or playable_character == 1 then
			event.set_character_texture_animation(0, 0, "目パチ")
			event.set_character_texture_animation(0, 1, "死に")
		end
		if playable_character == 2 then
			event.set_action_character_motion(0, "故障", 6)
			event.initialize_effect_manager(5, 1)
			event.load_effect_base("ロボ故障")
			event.create_effect_work_buffer(5)
			event.create_effect("ロボ故障")
		end
		change_state = 0
		if playable_character == 2 then
			change_state = event.get_character_change_state(0) or change_state
			if change_state == 0 then
				change_state = event.get_character_change_state(1) or change_state
			end
		end
		if playable_character == 0 then
			change_state = event.get_character_change_state(1) or change_state
		end
		if playable_character == 1 then
			change_state = event.get_character_change_state(0) or change_state
		end
		if playable_character == 3 then
			change_state = event.get_character_change_state(1) or change_state
			if change_state == 0 then
				change_state = event.get_character_change_state(0) or change_state
			end
		end
		event.start_background_file_loads_3(
			"snd2/bgm/bg_060.sound.json",
			"textures/dungeon/image/gameover/gameover_1.json",
			"event/boss_btl_lose_1.txt"
		)
		resume_step = 1
		wait.frames(30)
		event.show_dungeon_status_bar(0, 0.06666667)
		resume_step = 2
		wait.background_load()
		event.load_music_pack(60)
		if change_state == 1 or change_state ~= 1 and voice_id < 0 then
			event.play_music(0)
		end
		resume_step = 3
		wait.frames(30)
		event.set_dungeon_pause_flags(1, 1)
		event.reset_dungeon_collision_primitives()
		if change_state ~= 1 then
			image_block = event.load_event_image_4(5, "textures/dungeon/image/gameover/gameover_1.json", 1) or image_block
			if voice_id >= 0 then
				message.set_window_mode(0, 7)
				event.load_message_file(0, 5, "event/boss_btl_lose_1.txt")
				resume_step = 4
				message.show_voiced_with_button_prompt(voice_id, -1, 10)
				resume_step = 5
				wait.frames(10)
				event.load_message_file(0, -1)
				event.play_music(0)
			end
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "gameover1", image_block)
			event.set_event_sprite_color(0, 128, 128, 128, 128)
			event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
			event.set_event_sprite_size(0, 576, 128)
			event.set_event_sprite_position(0, -320, 208)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.move_object_sequence(0, 288, 208, 0.0, 20)
			resume_step = 6
			wait.frames(30)
			event.reset_event_sprite(1)
			event.set_event_sprite_type(1, 0)
			event.set_event_sprite_texture(1, "gameover1", image_block)
			event.set_event_sprite_color(1, 128, 128, 128, 0)
			event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
			event.set_event_sprite_size(1, 576, 64)
			event.set_event_sprite_position(1, 256, 208)
			event.set_event_sprite_draw_pass(1, 1)
			event.attach_object_handle_to_sprite(1, 1)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
			resume_step = 7
			wait.frames(120)
			while true do
				if wait.get_button_state(0) ~= 0 then
					break
				end
				resume_step = 8
				vm.wait(8)
			end
		elseif playable_character == 3 then
			partner_change_state = event.get_character_change_state(1) or partner_change_state
			if partner_change_state == 0 then
				resume_step = 9
				message.show_defeat_message(1)
			else
				resume_step = 10
				message.show_defeat_message(4)
			end
		elseif playable_character == 0 or playable_character == 2 then
			resume_step = 11
			message.show_defeat_message(playable_character)
		else
			resume_step = 12
			message.show_defeat_message(1)
		end
		is_debug_enabled = event.get_debug_flag() or is_debug_enabled
		if is_debug_enabled == 1 then
			event.run_dungeon_debug_command(0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			if playable_character == 0 or playable_character == 1 then
				event.set_character_texture_animation(0, 0, "死に")
				event.set_character_texture_animation(0, 1, "目パチ")
			end
			event.reset_action_character_motion(0, 4)
		elseif change_state == 1 then
			event.fade_out_screen(30)
			resume_step = 13
			wait.frames(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.open_dungeon_character_change_menu(-1)
			resume_step = 14
			vm.wait(14)
			event.fade_out_screen(0)
		else
			event.fade_out_music(30)
			event.fade_out_screen(30)
			resume_step = 15
			wait.frames(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.stop_music(0)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_event_sprite_draw_pass(1, 0)
			event.delete_event_image(1)
			if revive_party == 1 then
				event.add_hp_by_rate(1.0, 0)
				event.add_battle_weapon_durability(0, 999)
				event.add_battle_weapon_durability(1, 999)
				event.run_dungeon_event(-1)
				event.clear_event_battle_monsters(-1)
				event.set_dungeon_pause_flags(1, 0)
				event.finish_event()
				return 1
			else
				event.set_scene_exit_flag(1)
				event.finish_event()
				return 0
			end
		end
		event.stop_music(0)
		resume_step = 16
		wait.frames(4)
		saved_music_number = event.get_saved_music_number() or saved_music_number
		event.load_music(saved_music_number)
		print("---------------------------------------------DEAD RELOAD_BGM = ", saved_music_number, "\n")
		print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
		event.restore_music_status(-1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			if battle_bgm_playing == 1 then
				print("---------------------------------------------BATTLE BGM PLAY\n")
				event.play_sound_effect(battle_bgm_sound_id, 0)
				event.set_sound_effect_volume(battle_bgm_sound_id, 0, battle_bgm_volume)
			end
		end
		event.set_camera_control_enabled(1)
		event.show_dungeon_status_bar(1, 1.0)
		if is_debug_enabled ~= 1 then
			event.fade_in_screen(10)
		end
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16385, 0)
		else
			event.set_dungeon_pause_flags(1, 0)
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if resume_step <= 15 then
			if resume_step <= 1 then
				wait.background_load_skipping()
			end
			if resume_step <= 2 then
				wait.frames_skipping(30)
			end
			if resume_step <= 3 then
				message.set_window_mode_skipping(0, 7)
				message.show_voiced_then_hold_skipping(voice_id, -1, 10)
			end
			if resume_step <= 4 then
				wait.frames_skipping(10)
			end
			if resume_step <= 5 then
				wait.frames_skipping(30)
			end
			if resume_step <= 6 then
				wait.frames_skipping(120)
			end
			if resume_step <= 8 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 9 then
				local _ = party.get_change_state_skipping(0)
				message.show_defeat_message_skipping(4)
			end
			if resume_step <= 10 then
				message.show_defeat_message_skipping(playable_character)
			end
			if resume_step <= 11 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 12 then
				wait.frames_skipping(30)
			end
			if resume_step <= 14 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_step <= 16 then
			print("---------------------------------------------DEAD RELOAD_BGM = ", saved_music_number, "\n")
			print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
			print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
			print("---------------------------------------------BATTLE BGM PLAY\n")
			return 0
		end
		return nil
	end)
end

--- Runs the defeat sequence with dialogue and no voice line.
function dungeon.handle_defeat_with_dialogue_silent(revive_party: s32)
	return dungeon.handle_defeat_with_dialogue(revive_party, -1)
end

--- Runs the defeat sequence with dialogue and a voice line.
function dungeon.handle_defeat_with_dialogue_voiced(revive_party: s32, voice_id: s32)
	return dungeon.handle_defeat_with_dialogue(revive_party, voice_id)
end

--- Adds one to the counter stored in slot 7 of a dungeon floor's info.
function dungeon.increment_floor_counter(stage_id: s32, floor_index: s32)
	local counter: s32 = 0
	counter = event.get_dungeon_floor_info(stage_id, floor_index, 7) or counter
	counter = vm.i32(counter + 1)
	event.set_dungeon_floor_info(stage_id, floor_index, 7, counter)
end

--- Accepts a stage and floor and does nothing; this stands in for dungeon.increment_floor_counter when events are skipped.
function dungeon.increment_floor_counter_skipping(stage_id: s32, floor_index: s32)
	local counter: s32 = 0
	counter = counter + 1
end

--- Shows the finish banner and sound over a follow camera on the player, then restores the dungeon music and camera.
function dungeon.play_finish_banner(camera_variant: s32)
	local texture_bank: s32 = 0
	local language_code: s32 = 0
	local victory_sound: s32 = 0
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local banner_language_code: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		character.reset_action_motion()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			texture_bank = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or texture_bank
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", texture_bank)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 228, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 255, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
		else
			texture_bank = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or texture_bank
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", texture_bank)
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
		if camera_variant == 2 then
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
		wait.frames(90)
		banner_language_code = event.get_language() or banner_language_code
		if banner_language_code == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 214.0, 370.0, 0, 20)
		end
		wait.frames(70)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.set_camera_control_enabled(1)
	event.fade_in_screen(1)
	event.stop_sound_effect(victory_sound, 0)
	event.load_music(193)
	event.play_music(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

--- Plays Max's dungeon victory pose with the finish banner, voice line, camera and music.
function dungeon.play_max_victory(draw_pass: s32)
	local language_code: s32 = 0
	local texture_bank: s32 = 0
	local victory_sound: s32 = 0
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local facing_angle: f32 = 0
	local progress: number = 0
	vm.section(function()
		progress = 1
		vm.entry(1)
		event.initialize_event()
		if draw_pass == 0 then
			event.show_dungeon_status_bar(0, 1.0)
		end
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.start_background_file_loads_3(
				"dungeon/chara/c01b_win.gltf",
				"textures/dungeon/image/senmetsu/finish.json",
				"snd2/sp/sp_000.sound.json"
			)
		else
			event.start_background_file_loads_3(
				"dungeon/chara/c01b_win.gltf",
				"textures/dungeon/image/senmetsu/finish_1.json",
				"snd2/sp/sp_000.sound.json"
			)
		end
		progress = 2
		vm.wait(2)
		progress = 3
		wait.background_load()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character_motion_pack(5, "dungeon/chara/c01b_win.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if language_code == 0 then
			texture_bank = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or texture_bank
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", texture_bank)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 228, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 255, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, draw_pass)
		else
			texture_bank = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or texture_bank
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", texture_bank)
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
		victory_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or victory_sound
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
		event.play_sound_effect(victory_sound, 0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "勝利のポーズ", 6)
		event.queue_object_sequence_next_motion(0, "勝利のポーズL", 4)
		event.set_object_sequence_scale(1, 1.0, 1.0, 0, 60)
		event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
		progress = 4
		wait.frames(90)
		if language_code == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 214.0, 370.0, 0, 20)
		end
		event.set_mouth_texture_animations(0, "わらい口パク")
		progress = 5
		sound.play_voice_line(8500160, -1)
		progress = 6
		wait.frames(20)
	end, function(received: { any }): boolean
		if progress <= 2 then
			wait.background_load_skipping()
		end
		if progress <= 3 then
			facing_angle = vm.f32(facing_angle + vm.f32(0.4))
			wait.frames_skipping(90)
		end
		if progress <= 4 then
			sound.play_voice_line_skipping(8500160, -1)
		end
		if progress <= 5 then
			wait.frames_skipping(20)
		end
		return true
	end)
	progress = 7
	vm.entry(7)
	event.cancel_drama_scene_skip()
	if draw_pass == 0 then
		event.show_dungeon_status_bar(1, 1.0)
	end
	event.set_camera_control_enabled(1)
	event.stop_port_sound_effects(7)
	event.stop_sound_effect(victory_sound, 0)
	event.load_music(193)
	event.play_music(0)
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

--- Plays Monica's dungeon victory pose with the finish banner, voice line, camera and music.
function dungeon.play_monica_victory(draw_pass: s32)
	local language_code: s32 = 0
	local texture_bank: s32 = 0
	local victory_sound: s32 = 0
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local facing_angle: f32 = 0
	local progress: number = 0
	vm.section(function()
		progress = 1
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
				"textures/dungeon/image/senmetsu/finish_1.json",
				"snd2/sp/sp_000.sound.json"
			)
		end
		progress = 2
		vm.wait(2)
		progress = 3
		wait.background_load()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character_motion_pack(5, "dungeon/chara/c02a_win.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if language_code == 0 then
			texture_bank = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or texture_bank
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", texture_bank)
			event.set_event_sprite_position(0, 256, 206)
			event.set_event_sprite_size(0, 228, 64)
			event.set_event_sprite_texture_rect(0, 0, 0, 255, 64)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, draw_pass)
		else
			texture_bank = event.load_event_image_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or texture_bank
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "senmetu", texture_bank)
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
		victory_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or victory_sound
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
		event.play_sound_effect(victory_sound, 0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "勝利のポーズ", 6)
		event.queue_object_sequence_next_motion(0, "勝利のポーズL", 6, 0.04)
		event.queue_object_sequence_next_motion(0, "余韻", 6)
		event.queue_object_sequence_next_motion(0, "余韻L", 4)
		event.set_object_sequence_scale(1, 1.0, 1.0, 0, 60)
		event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
		progress = 4
		wait.frames(90)
		if language_code == 0 then
			event.move_object_sequence(1, 134.0, 370.0, 0, 20)
		else
			event.move_object_sequence(1, 214.0, 370.0, 0, 20)
		end
		event.set_mouth_texture_animations(0, "わらい口パク")
		progress = 5
		sound.play_voice_line(8510170, -1)
		progress = 6
		wait.frames(20)
	end, function(received: { any }): boolean
		if progress <= 2 then
			wait.background_load_skipping()
		end
		if progress <= 3 then
			facing_angle = vm.f32(facing_angle + vm.f32(0.4))
			wait.frames_skipping(90)
		end
		if progress <= 4 then
			sound.play_voice_line_skipping(8510170, -1)
		end
		if progress <= 5 then
			wait.frames_skipping(20)
		end
		return true
	end)
	progress = 7
	vm.entry(7)
	event.cancel_drama_scene_skip()
	if draw_pass == 0 then
		event.show_dungeon_status_bar(1, 1.0)
	end
	event.set_camera_control_enabled(1)
	event.stop_port_sound_effects(7)
	event.stop_sound_effect(victory_sound, 0)
	event.load_music(193)
	event.play_music(0)
	event.delete_character_extension_packs(0)
	event.delete_event_image(0)
	event.start_crossfade(10)
	event.finish_event()
end

--- Plays the defeat music and game-over screen, then revives the party, opens the character change menu or leaves the scene.
function dungeon.run_defeat_sequence(revive: any, voice: any)
	local battle_pause_flags: s32 = 0
	local is_boss_floor: s32 = 0
	local sound_bank: s32 = 0
	local battle_bgm_status: s32 = 0
	local battle_bgm_volume: s32 = 0
	local playable_character: s32 = 0
	local can_change_character: s32 = 0
	local image_block: s32 = 0
	local change_state: s32 = 0
	local debug_flag: s32 = 0
	local music_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		battle_pause_flags = event.get_dungeon_pause_flags(16384) or battle_pause_flags
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16384, 1)
		end
		is_boss_floor = event.is_dungeon_boss_floor() or is_boss_floor
		event.save_music_status(-1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			sound_bank = event.get_event_sound_bank(4) or sound_bank
			battle_bgm_status = event.get_sound_effect_status(sound_bank, 0) or battle_bgm_status
			battle_bgm_volume = event.get_battle_music_volume() or battle_bgm_volume
			event.stop_sound_effect(sound_bank, 0)
			print("---------------------------------------------BATTLE BGM STOP\n")
		end
		event.stop_music(0)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 or playable_character == 1 then
			event.set_character_texture_animation(0, 0, "目パチ")
			event.set_character_texture_animation(0, 1, "死に")
		end
		if playable_character == 2 then
			event.set_action_character_motion(0, "故障", 6)
			event.initialize_effect_manager(5, 1)
			event.load_effect_base("ロボ故障")
			event.create_effect_work_buffer(5)
			event.create_effect("ロボ故障")
		end
		can_change_character = 0
		if playable_character == 2 then
			can_change_character = event.get_character_change_state(0) or can_change_character
			if can_change_character == 0 then
				can_change_character = event.get_character_change_state(1) or can_change_character
			end
		end
		if playable_character == 0 then
			can_change_character = event.get_character_change_state(1) or can_change_character
		end
		if playable_character == 1 then
			can_change_character = event.get_character_change_state(0) or can_change_character
		end
		if playable_character == 3 then
			can_change_character = event.get_character_change_state(1) or can_change_character
			if can_change_character == 0 then
				can_change_character = event.get_character_change_state(0) or can_change_character
			end
		end
		event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
		resume_step = 1
		wait.for_frame_count(30)
		event.show_dungeon_status_bar(0, 0.06666667)
		resume_step = 2
		wait.background_load()
		event.load_music_pack(60)
		if can_change_character == 1 or can_change_character ~= 1 and voice < 0 then
			event.play_music(0)
		end
		resume_step = 3
		wait.for_frame_count(30)
		event.set_dungeon_pause_flags(1, 1)
		event.reset_dungeon_collision_primitives()
		if can_change_character ~= 1 then
			image_block = event.load_event_image_4(5, "textures/dungeon/image/gameover.json", 1) or image_block
			if voice >= 0 then
				resume_step = 4
				sound.play_voice_for(voice, -1)
				resume_step = 5
				wait.for_frame_count(10)
				event.play_music(0)
			end
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "gameover1", image_block)
			event.set_event_sprite_color(0, 128, 128, 128, 128)
			event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
			event.set_event_sprite_size(0, 576, 128)
			event.set_event_sprite_position(0, -320, 208)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.move_object_sequence(0, 288, 208, 0.0, 20)
			resume_step = 6
			wait.for_frame_count(30)
			event.reset_event_sprite(1)
			event.set_event_sprite_type(1, 0)
			event.set_event_sprite_texture(1, "gameover1", image_block)
			event.set_event_sprite_color(1, 128, 128, 128, 0)
			event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
			event.set_event_sprite_size(1, 576, 64)
			event.set_event_sprite_position(1, 256, 208)
			event.set_event_sprite_draw_pass(1, 1)
			event.attach_object_handle_to_sprite(1, 1)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
			resume_step = 7
			wait.for_frame_count(120)
			while true do
				if wait.get_button_state(0) ~= 0 then
					break
				end
				resume_step = 8
				vm.wait(8)
			end
		elseif playable_character == 3 then
			change_state = event.get_character_change_state(1) or change_state
			if change_state == 0 then
				resume_step = 9
				message.show_defeat_message(1)
			else
				resume_step = 10
				message.show_defeat_message(4)
			end
		elseif playable_character == 0 or playable_character == 2 then
			resume_step = 11
			message.show_defeat_message(playable_character)
		else
			resume_step = 12
			message.show_defeat_message(1)
		end
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 1 then
			event.run_dungeon_debug_command(0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			if playable_character == 0 or playable_character == 1 then
				event.set_character_texture_animation(0, 0, "死に")
				event.set_character_texture_animation(0, 1, "目パチ")
			end
			event.reset_action_character_motion(0, 4)
		elseif can_change_character == 1 then
			event.fade_out_screen(30)
			resume_step = 13
			wait.for_frame_count(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.open_dungeon_character_change_menu(-1)
			resume_step = 14
			vm.wait(14)
			event.fade_out_screen(0)
		else
			event.fade_out_music(30)
			event.fade_out_screen(30)
			resume_step = 15
			wait.for_frame_count(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.stop_music(0)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_event_sprite_draw_pass(1, 0)
			event.delete_event_image(1)
			if revive == 1 then
				event.add_hp_by_rate(1.0, 0)
				event.add_battle_weapon_durability(0, 999)
				event.add_battle_weapon_durability(1, 999)
				event.run_dungeon_event(-1)
				event.clear_event_battle_monsters(-1)
				event.set_dungeon_pause_flags(1, 0)
				event.finish_event()
				return 1
			else
				event.set_scene_exit_flag(1)
				event.finish_event()
				return 0
			end
		end
		event.stop_music(0)
		resume_step = 16
		wait.for_frame_count(4)
		music_number = event.get_saved_music_number() or music_number
		event.load_music(music_number)
		print("---------------------------------------------DEAD RELOAD_BGM = ", music_number, "\n")
		print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
		event.restore_music_status(-1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			if battle_bgm_status == 1 then
				print("---------------------------------------------BATTLE BGM PLAY\n")
				event.play_sound_effect(sound_bank, 0)
				event.set_sound_effect_volume(sound_bank, 0, battle_bgm_volume)
			end
		end
		event.set_camera_control_enabled(1)
		event.show_dungeon_status_bar(1, 1.0)
		if debug_flag ~= 1 then
			event.fade_in_screen(10)
		end
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16385, 0)
		else
			event.set_dungeon_pause_flags(1, 0)
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if resume_step <= 15 then
			if resume_step <= 1 then
				wait.background_load_skipping()
			end
			if resume_step <= 2 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 3 then
				sound.play_voice_for_skipping(voice, -1)
			end
			if resume_step <= 4 then
				wait.skip_frame_count(10)
			end
			if resume_step <= 5 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 6 then
				wait.skip_frame_count(120)
			end
			if resume_step <= 8 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 9 then
				local _ = party.get_change_state_skipping(0)
				message.show_defeat_message_skipping(4)
			end
			if resume_step <= 10 then
				message.show_defeat_message_skipping(playable_character)
			end
			if resume_step <= 11 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 12 then
				wait.skip_frame_count(30)
			end
			if resume_step <= 14 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		if resume_step <= 16 then
			print("---------------------------------------------DEAD RELOAD_BGM = ", music_number, "\n")
			print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
			print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
			print("---------------------------------------------BATTLE BGM PLAY\n")
			return 0
		end
		return nil
	end)
end

--- Runs the party defeat sequence without a voice line.
function dungeon.run_defeat_sequence_silent(revive: s32)
	return dungeon.run_defeat_sequence(revive, -1)
end

--- Plays the defeat music, game-over screen and defeat message, then revives the party, opens the character change menu or leaves the scene.
function dungeon.run_defeat_sequence_with_message(revive: any, voice: any)
	local battle_pause_flags: s32 = 0
	local is_boss_floor: s32 = 0
	local sound_bank: s32 = 0
	local battle_bgm_status: s32 = 0
	local battle_bgm_volume: s32 = 0
	local playable_character: s32 = 0
	local can_change_character: s32 = 0
	local image_block: s32 = 0
	local change_state: s32 = 0
	local debug_flag: s32 = 0
	local music_number: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		battle_pause_flags = event.get_dungeon_pause_flags(16384) or battle_pause_flags
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16384, 1)
		end
		is_boss_floor = event.is_dungeon_boss_floor() or is_boss_floor
		event.save_music_status(-1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			sound_bank = event.get_event_sound_bank(4) or sound_bank
			battle_bgm_status = event.get_sound_effect_status(sound_bank, 0) or battle_bgm_status
			battle_bgm_volume = event.get_battle_music_volume() or battle_bgm_volume
			event.stop_sound_effect(sound_bank, 0)
			print("---------------------------------------------BATTLE BGM STOP\n")
		end
		event.stop_music(0)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 or playable_character == 1 then
			event.set_character_texture_animation(0, 0, "目パチ")
			event.set_character_texture_animation(0, 1, "死に")
		end
		if playable_character == 2 then
			event.set_action_character_motion(0, "故障", 6)
			event.initialize_effect_manager(5, 1)
			event.load_effect_base("ロボ故障")
			event.create_effect_work_buffer(5)
			event.create_effect("ロボ故障")
		end
		can_change_character = 0
		if playable_character == 2 then
			can_change_character = event.get_character_change_state(0) or can_change_character
			if can_change_character == 0 then
				can_change_character = event.get_character_change_state(1) or can_change_character
			end
		end
		if playable_character == 0 then
			can_change_character = event.get_character_change_state(1) or can_change_character
		end
		if playable_character == 1 then
			can_change_character = event.get_character_change_state(0) or can_change_character
		end
		if playable_character == 3 then
			can_change_character = event.get_character_change_state(1) or can_change_character
			if can_change_character == 0 then
				can_change_character = event.get_character_change_state(0) or can_change_character
			end
		end
		event.start_background_file_loads_3(
			"snd2/bgm/bg_060.sound.json",
			"textures/dungeon/image/gameover/gameover_1.json",
			"event/boss_btl_lose_1.txt"
		)
		resume_step = 1
		wait.frames(30)
		event.show_dungeon_status_bar(0, 0.06666667)
		resume_step = 2
		wait.background_load()
		event.load_music_pack(60)
		if can_change_character == 1 or can_change_character ~= 1 and voice < 0 then
			event.play_music(0)
		end
		resume_step = 3
		wait.frames(30)
		event.set_dungeon_pause_flags(1, 1)
		event.reset_dungeon_collision_primitives()
		if can_change_character ~= 1 then
			image_block = event.load_event_image_4(5, "textures/dungeon/image/gameover/gameover_1.json", 1) or image_block
			if voice >= 0 then
				message.set_window_mode(0, 7)
				event.load_message_file(0, 5, "event/boss_btl_lose_1.txt")
				resume_step = 4
				message.show_voiced_then_hold(voice, -1, 10)
				resume_step = 5
				wait.frames(10)
				event.load_message_file(0, -1)
				event.play_music(0)
			end
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "gameover1", image_block)
			event.set_event_sprite_color(0, 128, 128, 128, 128)
			event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
			event.set_event_sprite_size(0, 576, 128)
			event.set_event_sprite_position(0, -320, 208)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.move_object_sequence(0, 288, 208, 0.0, 20)
			resume_step = 6
			wait.frames(30)
			event.reset_event_sprite(1)
			event.set_event_sprite_type(1, 0)
			event.set_event_sprite_texture(1, "gameover1", image_block)
			event.set_event_sprite_color(1, 128, 128, 128, 0)
			event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
			event.set_event_sprite_size(1, 576, 64)
			event.set_event_sprite_position(1, 256, 208)
			event.set_event_sprite_draw_pass(1, 1)
			event.attach_object_handle_to_sprite(1, 1)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
			resume_step = 7
			wait.frames(120)
			while true do
				if wait.get_button_state(0) ~= 0 then
					break
				end
				resume_step = 8
				vm.wait(8)
			end
		elseif playable_character == 3 then
			change_state = event.get_character_change_state(1) or change_state
			if change_state == 0 then
				resume_step = 9
				message.show_defeat_message(1)
			else
				resume_step = 10
				message.show_defeat_message(4)
			end
		elseif playable_character == 0 or playable_character == 2 then
			resume_step = 11
			message.show_defeat_message(playable_character)
		else
			resume_step = 12
			message.show_defeat_message(1)
		end
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 1 then
			event.run_dungeon_debug_command(0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			if playable_character == 0 or playable_character == 1 then
				event.set_character_texture_animation(0, 0, "死に")
				event.set_character_texture_animation(0, 1, "目パチ")
			end
			event.reset_action_character_motion(0, 4)
		elseif can_change_character == 1 then
			event.fade_out_screen(30)
			resume_step = 13
			wait.frames(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.open_dungeon_character_change_menu(-1)
			resume_step = 14
			vm.wait(14)
			event.fade_out_screen(0)
		else
			event.fade_out_music(30)
			event.fade_out_screen(30)
			resume_step = 15
			wait.frames(30)
			if playable_character == 2 then
				event.clear_effect_manager()
			end
			event.stop_music(0)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_event_sprite_draw_pass(1, 0)
			event.delete_event_image(1)
			if revive == 1 then
				event.add_hp_by_rate(1.0, 0)
				event.add_battle_weapon_durability(0, 999)
				event.add_battle_weapon_durability(1, 999)
				event.run_dungeon_event(-1)
				event.clear_event_battle_monsters(-1)
				event.set_dungeon_pause_flags(1, 0)
				event.finish_event()
				return 1
			else
				event.set_scene_exit_flag(1)
				event.finish_event()
				return 0
			end
		end
		event.stop_music(0)
		resume_step = 16
		wait.frames(4)
		music_number = event.get_saved_music_number() or music_number
		event.load_music(music_number)
		print("---------------------------------------------DEAD RELOAD_BGM = ", music_number, "\n")
		print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
		event.restore_music_status(-1)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(1)
		if battle_pause_flags ~= 16384 and is_boss_floor ~= 1 then
			if battle_bgm_status == 1 then
				print("---------------------------------------------BATTLE BGM PLAY\n")
				event.play_sound_effect(sound_bank, 0)
				event.set_sound_effect_volume(sound_bank, 0, battle_bgm_volume)
			end
		end
		event.set_camera_control_enabled(1)
		event.show_dungeon_status_bar(1, 1.0)
		if debug_flag ~= 1 then
			event.fade_in_screen(10)
		end
		if battle_pause_flags ~= 16384 then
			event.set_dungeon_pause_flags(16385, 0)
		else
			event.set_dungeon_pause_flags(1, 0)
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if resume_step <= 15 then
			if resume_step <= 1 then
				wait.background_load_skipping()
			end
			if resume_step <= 2 then
				wait.frames_skipping(30)
			end
			if resume_step <= 3 then
				message.set_window_mode_skipping(0, 7)
				message.show_voiced_then_hold_skipping(voice, -1, 10)
			end
			if resume_step <= 4 then
				wait.frames_skipping(10)
			end
			if resume_step <= 5 then
				wait.frames_skipping(30)
			end
			if resume_step <= 6 then
				wait.frames_skipping(120)
			end
			if resume_step <= 8 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 9 then
				local _ = party.get_change_state_skipping(0)
				message.show_defeat_message_skipping(4)
			end
			if resume_step <= 10 then
				message.show_defeat_message_skipping(playable_character)
			end
			if resume_step <= 11 then
				message.show_defeat_message_skipping(1)
			end
			if resume_step <= 12 then
				wait.frames_skipping(30)
			end
			if resume_step <= 14 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if resume_step <= 16 then
			print("---------------------------------------------DEAD RELOAD_BGM = ", music_number, "\n")
			print("---------------------------------------------BOSS BATTLE = ", is_boss_floor, "\n")
			print("---------------------------------------------PAUSE BATTLE BGM = ", battle_pause_flags, "\n")
			print("---------------------------------------------BATTLE BGM PLAY\n")
			return 0
		end
		return nil
	end)
end

--- Runs the party defeat sequence with its message file but without a voice line.
function dungeon.run_defeat_sequence_with_message_silent(revive: s32)
	return dungeon.run_defeat_sequence_with_message(revive, -1)
end

--- Resets the dungeon subject counter and shows the floor episode title.
function dungeon.show_floor_title()
	event.reset_dungeon_subject_counter(-1)
	event.show_floor_episode_title(1)
end

--- Replays the waits of the defeat sequence with dialogue after a skip and returns 1.
function dungeon.skip_defeat_dialogue_sequence(revive_party: s32, voice_id: s32)
	local playable_character: s32 = 0
	print("---------------------------------------------BATTLE BGM STOP\n")
	wait.frames_skipping(30)
	wait.background_load_skipping()
	wait.frames_skipping(30)
	message.set_window_mode_skipping(0, 7)
	message.show_voiced_then_hold_skipping(voice_id, -1, 10)
	wait.frames_skipping(10)
	wait.frames_skipping(30)
	wait.frames_skipping(120)
	local _ = party.get_change_state_skipping(0)
	message.show_defeat_message_skipping(1)
	message.show_defeat_message_skipping(4)
	message.show_defeat_message_skipping(playable_character)
	message.show_defeat_message_skipping(1)
	wait.frames_skipping(30)
	wait.frames_skipping(30)
	return 1
end

--- Replays the defeat dialogue sequence waits without a voice line.
function dungeon.skip_defeat_dialogue_sequence_silent(revive_party: s32)
	return dungeon.skip_defeat_dialogue_sequence(revive_party, -1)
end

--- Replays the defeat dialogue sequence waits with a voice line.
function dungeon.skip_defeat_dialogue_sequence_voiced(revive_party: s32, voice_id: s32)
	return dungeon.skip_defeat_dialogue_sequence(revive_party, voice_id)
end

--- Replays the waits of the defeat sequence after a skip and returns 1.
function dungeon.skip_defeat_sequence(revive_party: s32, voice_id: s32)
	local playable_character: s32 = 0
	print("---------------------------------------------BATTLE BGM STOP\n")
	wait.skip_frame_count(30)
	wait.background_load_skipping()
	wait.skip_frame_count(30)
	sound.play_voice_for_skipping(voice_id, -1)
	wait.skip_frame_count(10)
	wait.skip_frame_count(30)
	wait.skip_frame_count(120)
	local _ = party.get_change_state_skipping(0)
	message.show_defeat_message_skipping(1)
	message.show_defeat_message_skipping(4)
	message.show_defeat_message_skipping(playable_character)
	message.show_defeat_message_skipping(1)
	wait.skip_frame_count(30)
	wait.skip_frame_count(30)
	return 1
end

--- Replays the defeat sequence waits without a voice line.
function dungeon.skip_defeat_sequence_silent(revive_party: s32)
	return dungeon.skip_defeat_sequence(revive_party, -1)
end

--- Replays the defeat sequence waits with a voice line.
function dungeon.skip_defeat_sequence_voiced(revive_party: s32, voice_id: s32)
	return dungeon.skip_defeat_sequence(revive_party, voice_id)
end

--- Plays the monster-leaves-chest camera shot at the dungeon event point and then places the monster there.
function dungeon.spawn_monster_from_chest(monster_id: s32, locate_param: s32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_y: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	event.start_crossfade(15)
	event.set_nearest_treasure_box_state(0)
	event.set_character_active(0, 0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		x = out1 or x
		y = out2 or y
		z = out3 or z
		rotation_y = out4 or rotation_y
	end
	event.set_event_world_coordinate(x, y, z, rotation_y)
	event.copy_monster_to_scene_character(5, monster_id, 12)
	event.set_character_active(12)
	event.set_character_position(12, x, y, z)
	event.set_character_rotation(12, 0.0, rotation_y, 0.0)
	event.set_character_motion(12, "閉め", 4)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.frames(15)
	event.set_character_motion(12, "出現", 6)
	wait.frames(36)
	event.delete_character(12, 0)
	event.set_character_active(0, 12)
	event.place_dungeon_monster(monster_id, x, y, z, 0.0, rotation_y, 0.0, locate_param)
	event.set_character_active(1, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Plays the sequence in which a monster bursts out of a treasure chest and places it in the dungeon. Its waits are one frame longer.
function dungeon.spawn_monster_from_chest_with_extra_frames(monster_id: s32, spawn_param: s32)
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_angle: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	event.start_crossfade(15)
	event.set_nearest_treasure_box_state(0)
	event.set_character_active(0, 0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		event_point_x = out1 or event_point_x
		event_point_y = out2 or event_point_y
		event_point_z = out3 or event_point_z
		event_point_angle = out4 or event_point_angle
	end
	event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_angle)
	event.copy_monster_to_scene_character(5, monster_id, 12)
	event.set_character_active(12)
	event.set_character_position(12, event_point_x, event_point_y, event_point_z)
	event.set_character_rotation(12, 0.0, event_point_angle, 0.0)
	event.set_character_motion(12, "閉め", 4)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	event.set_character_motion(12, "出現", 6)
	wait.for_frame_count(36)
	event.delete_character(12, 0)
	event.set_character_active(0, 12)
	event.place_dungeon_monster(monster_id, event_point_x, event_point_y, event_point_z, 0.0, event_point_angle, 0.0, spawn_param)
	event.set_character_active(1, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Plays the talk message of the monster the player is facing, pausing the dungeon meanwhile.
function dungeon.talk_to_monster()
	local monster_slot: s32 = 0
	local text: s32 = 0
	local loading_pending: s32 = 0
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	do
		local out1, out2 = event.get_monster_talk_data_2()
		monster_slot = out1 or monster_slot
		text = out2 or text
	end
	if text < 0 then
		vm.wait(1)
		return
	end
	event.set_dungeon_pause_flags(4096, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.preload_monster_talk_messages()
	while true do
		loading_pending = event.is_background_load_pending() or loading_pending
		if loading_pending == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.load_monster_talk_messages(0, 5)
	event.open_message_window_2(0, text)
	cutscene.talk(monster_slot, -1, 0, 1)
	event.load_message_file(0, -1)
	event.set_dungeon_pause_flags(4096, 0)
end

return dungeon
