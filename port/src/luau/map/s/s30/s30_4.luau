--!strict
--- Paznos bridge town with the jump gate, the counterattack briefing and the lift-off cutscene.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local paznos_bridge = require("@lib/event/paznos_bridge")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")
local workshop_villagers = require("@lib/event/italian/workshop_villagers")

--- Loads the flagged extra character.
local function load_extra_character()
	paznos_bridge.load_flagged_extra_character()
end

--- Lets the player choose a jump gate destination and warps there.
local function use_jump_gate(unused_argument: any)
	local option_count: s32 = 0
	local selected_option: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local sound_id: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 4)
	event.set_message_selection_top_line(0, 1)
	event.set_message_window_option(0, 0, 1)
	event.set_message_window_option(0, 1, 1)
	event.open_message_window_2(
		0,
		"Selezionare destinazione:\nTeletrasporto Nord\nTeletrasporto Est\nTeletrasporto Ovest\nDavanti al Varco temporale"
	)
	option_count = 4
	selected_option = message.ask_choice(0, -1, 8, 0, 0, option_count, 1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 1, 0)
	if selected_option == -1 then
		return
	end
	if vm.wrap(selected_option - 1) ~= 1 and vm.wrap(selected_option - 1) ~= 2 and vm.wrap(selected_option - 1) ~= 3 and vm.wrap(selected_option - 1) ~= 0 then
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("サンワープ２")
	event.create_effect_work_buffer(5)
	event.create_effect("サンワープ２")
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	event.set_effect_first_vector(x, y, z)
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 120)
	wait.frames(15)
	event.set_character_visible(0, 0, 1, 0.05)
	event.set_character_visible(1, 0, 1, 0.05)
	event.set_character_visible(2, 0, 1, 0.05)
	event.set_character_visible(3, 0, 1, 0.05)
	wait.frames(30)
	event.fade_out_screen(15)
	wait.frames(15)
	event.clear_effect_manager()
	event.set_character_visible(0, 1)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.set_character_visible(3, 1)
	event.set_save_counter(18, vm.wrap(selected_option - 1))
	event.jump_to_map_2(-1, "f04")
	vm.wait(5)
end

--- Has the character ask whether the party is ready and returns whether it is.
local function ask_ready_for_counterattack(character_slot: s32)
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local player_yaw: f32 = 0
	local character_yaw: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local needs_turn: s32 = 0
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		message.set_window_mode(0, 7)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(1, character_slot)
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
			local out1, out2, out3 = event.get_character_position(character_slot)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		do
			local _, out2, _ = event.get_character_rotation(character_slot)
			character_yaw = out2 or character_yaw
		end
		yaw = event.get_direction_angle(player_x, player_y, player_z, character_x, character_y, character_z) or yaw
		yaw_2 = event.get_direction_angle(character_x, character_y, character_z, player_x, player_y, player_z) or yaw_2
		needs_turn = event.compare_angles(player_yaw, yaw, 0.1) or needs_turn
		if needs_turn ~= 0 then
			event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		needs_turn = event.compare_angles(character_yaw, yaw_2, 0.1) or needs_turn
		if needs_turn ~= 0 then
			event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 1
		wait.frames(20)
		event.open_voice_stream_wave(1, 5400010)
		resume_step = 2
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
		event.open_message_window_2(0, "Il nostro contrattacco a Grifone\ndovrebbe iniziare tra poco.")
		resume_step = 3
		message.say_bubble(0, -1, character_slot, 0, 0)
		event.close_voice_stream(1)
		event.open_voice_stream_wave(1, 5400015)
		resume_step = 4
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, "Siete pronti?")
		resume_step = 5
		message.say_bubble(0, -1, character_slot, 0, 0)
		event.close_voice_stream(1)
		message.set_window_mode(0, 1)
		event.open_message_window_2(0, "S[UNI00ec].\nNo.")
		resume_step = 6
		choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
		if choice == 0 then
			return 1
		else
			message.set_window_mode(0, 7)
			event.open_voice_stream_wave(1, 5400020)
			resume_step = 7
			sound.wait_voice_stream_ready(1)
			event.play_voice_stream(1)
			event.set_mouth_motions(1, "会話", 0, "立ち", 0)
			event.open_message_window_2(0, "Le Truppe Golem ci stanno addosso.\nFaremmo meglio a sbrigarci.")
			resume_step = 8
			message.say_bubble(0, -1, character_slot, 0, 0)
			event.close_voice_stream(1)
			needs_turn = event.compare_angles(character_yaw, yaw_2, 0.1) or needs_turn
			if needs_turn ~= 0 then
				event.rotate_object_sequence(1, 0.0, character_yaw, 0.0, 10)
				event.set_object_sequence_motion(1, "歩き")
				event.delay_object_sequence_motion_track(1, 10)
			end
			event.set_object_sequence_motion(1, "立ち")
			resume_step = 9
			wait.frames(11)
			return 0
		end
	end, function(received: { any })
		if resume_step <= 6 then
			if resume_step == 6 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				cutscene.skip_command(1)
			end
			if resume_step <= 2 then
				paznos_bridge.update_talk_state(0, -1, character_slot, 0, 0)
			end
			if resume_step <= 3 then
				cutscene.skip_command(1)
			end
			if resume_step <= 4 then
				paznos_bridge.update_talk_state(0, -1, character_slot, 0, 0)
			end
			if resume_step <= 5 then
				message.set_window_mode_skipping(0, 1)
				choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
			end
			return 1
		end
		if resume_step <= 9 then
			if resume_step <= 7 then
				paznos_bridge.update_talk_state(0, -1, character_slot, 0, 0)
			end
			if resume_step <= 8 then
				wait.frames_skipping(11)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the Paznos lift-off movies and scenes then jumps to s29.
local function cutscene_paznos_liftoff()
	local sound_bank: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		vm.entry(1)
		event.set_save_flag(540, 1)
		resume_step = 2
		paznos_bridge.play_event_540_scene_2()
		resume_step = 3
		vm.wait(3)
		event.set_character_active(0, 8)
		event.load_music(116)
		event.play_music(0)
		event.set_movie_caption(0, 0)
		event.set_movie_caption(1, 0, 570, "Paznos...decollato!", 60)
		event.set_movie_caption(0, 1)
		event.load_map_sounds(5513)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.fade_in_screen(10)
		event.play_movie(5, "movie/e54001.mp4", 0)
		resume_step = 4
		vm.wait(4)
		event.set_movie_caption(0, 0)
		event.fade_out_screen(0)
		resume_step = 5
		paznos_bridge.play_event_540_scene_3()
		resume_step = 6
		vm.wait(6)
		event.stop_all_sound_effects()
		event.fade_in_screen(10)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.play_movie(5, "movie/e54002.mp4", 0)
		resume_step = 7
		vm.wait(7)
		event.fade_out_screen(0)
		resume_step = 8
		paznos_bridge.play_event_540_scene_4()
		resume_step = 9
		vm.wait(9)
		event.stop_all_sound_effects()
		sound_bank = event.get_event_sound_bank(4) or sound_bank
		event.play_sound_effect(sound_bank, 11)
		event.fade_in_screen(10)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.play_movie(5, "movie/e54003.mp4", 0)
		resume_step = 10
		vm.wait(10)
		event.stop_sound_effect(sound_bank, 11)
		event.fade_out_screen(0)
		resume_step = 11
		paznos_bridge.play_event_540_scene_5()
		resume_step = 12
		vm.wait(12)
		event.stop_all_sound_effects()
		event.fade_in_screen(10)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.play_movie(5, "movie/e54004.mp4")
		resume_step = 13
		vm.wait(13)
		event.fade_out_screen(0)
		resume_step = 14
		paznos_bridge.play_event_540_scene_6()
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s29", 600)
		return
	end, function(received: { any })
		if resume_step <= 14 then
			if resume_step <= 1 then
				resume_step = 2
				paznos_bridge.play_event_540_scene_2()
				return vm.continue_with(function()
					resume_step = 3
					vm.wait(3)
					event.set_character_active(0, 8)
					event.load_music(116)
					event.play_music(0)
					event.set_movie_caption(0, 0)
					event.set_movie_caption(1, 0, 570, "Paznos...decollato!", 60)
					event.set_movie_caption(0, 1)
					event.load_map_sounds(5513)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.fade_in_screen(10)
					event.play_movie(5, "movie/e54001.mp4", 0)
					resume_step = 4
					vm.wait(4)
					event.set_movie_caption(0, 0)
					event.fade_out_screen(0)
					resume_step = 5
					paznos_bridge.play_event_540_scene_3()
					resume_step = 6
					vm.wait(6)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54002.mp4", 0)
					resume_step = 7
					vm.wait(7)
					event.fade_out_screen(0)
					resume_step = 8
					paznos_bridge.play_event_540_scene_4()
					resume_step = 9
					vm.wait(9)
					event.stop_all_sound_effects()
					sound_bank = event.get_event_sound_bank(4) or sound_bank
					event.play_sound_effect(sound_bank, 11)
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54003.mp4", 0)
					resume_step = 10
					vm.wait(10)
					event.stop_sound_effect(sound_bank, 11)
					event.fade_out_screen(0)
					resume_step = 11
					paznos_bridge.play_event_540_scene_5()
					resume_step = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					resume_step = 13
					vm.wait(13)
					event.fade_out_screen(0)
					resume_step = 14
					paznos_bridge.play_event_540_scene_6()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if resume_step <= 4 then
				resume_step = 5
				paznos_bridge.play_event_540_scene_3()
				return vm.continue_with(function()
					resume_step = 6
					vm.wait(6)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54002.mp4", 0)
					resume_step = 7
					vm.wait(7)
					event.fade_out_screen(0)
					resume_step = 8
					paznos_bridge.play_event_540_scene_4()
					resume_step = 9
					vm.wait(9)
					event.stop_all_sound_effects()
					sound_bank = event.get_event_sound_bank(4) or sound_bank
					event.play_sound_effect(sound_bank, 11)
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54003.mp4", 0)
					resume_step = 10
					vm.wait(10)
					event.stop_sound_effect(sound_bank, 11)
					event.fade_out_screen(0)
					resume_step = 11
					paznos_bridge.play_event_540_scene_5()
					resume_step = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					resume_step = 13
					vm.wait(13)
					event.fade_out_screen(0)
					resume_step = 14
					paznos_bridge.play_event_540_scene_6()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if resume_step <= 7 then
				resume_step = 8
				paznos_bridge.play_event_540_scene_4()
				return vm.continue_with(function()
					resume_step = 9
					vm.wait(9)
					event.stop_all_sound_effects()
					sound_bank = event.get_event_sound_bank(4) or sound_bank
					event.play_sound_effect(sound_bank, 11)
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54003.mp4", 0)
					resume_step = 10
					vm.wait(10)
					event.stop_sound_effect(sound_bank, 11)
					event.fade_out_screen(0)
					resume_step = 11
					paznos_bridge.play_event_540_scene_5()
					resume_step = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					resume_step = 13
					vm.wait(13)
					event.fade_out_screen(0)
					resume_step = 14
					paznos_bridge.play_event_540_scene_6()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if resume_step <= 10 then
				resume_step = 11
				paznos_bridge.play_event_540_scene_5()
				return vm.continue_with(function()
					resume_step = 12
					vm.wait(12)
					event.stop_all_sound_effects()
					event.fade_in_screen(10)
					event.assign_memory_stack(5)
					event.clear_memory_stack(5)
					event.play_movie(5, "movie/e54004.mp4")
					resume_step = 13
					vm.wait(13)
					event.fade_out_screen(0)
					resume_step = 14
					paznos_bridge.play_event_540_scene_6()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			if resume_step <= 13 then
				resume_step = 14
				paznos_bridge.play_event_540_scene_6()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s29", 600)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.load_extra_character = load_extra_character
script[99] = script.load_extra_character

--- Places the player and fades in.
function script.default_event()
	load_extra_character()
	character.place_standing_and_reset_cloth(-155.0, vm.f32(76.3), -205.0, vm.f32(0.9))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Opens the jump gate destination menu.
function script.examine_jump_gate()
	use_jump_gate(4)
end
script[560] = script.examine_jump_gate

--- Plays the first lift-off scene and jumps to f04.
function script.cutscene_lift_off_scene_1()
	paznos_bridge.play_event_540_scene_1()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f04", 601)
end
script[600] = script.cutscene_lift_off_scene_1

--- Plays the third lift-off scene and jumps to s55.
function script.cutscene_lift_off_scene_3()
	paznos_bridge.play_event_540_scene_3()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 601)
end
script[601] = script.cutscene_lift_off_scene_3

--- Plays the fourth lift-off scene and jumps to s55.
function script.cutscene_lift_off_scene_4()
	paznos_bridge.play_event_540_scene_4()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 602)
end
script[602] = script.cutscene_lift_off_scene_4

--- Plays the fifth lift-off scene and jumps to s55.
function script.cutscene_lift_off_scene_5()
	paznos_bridge.play_event_540_scene_5()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s55", 603)
end
script[603] = script.cutscene_lift_off_scene_5

--- Plays the sixth lift-off scene and jumps to s29.
function script.cutscene_lift_off_scene_6()
	paznos_bridge.play_event_540_scene_6()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s29", 600)
end
script[604] = script.cutscene_lift_off_scene_6

--- Plays the seventh lift-off scene and jumps to s10.
function script.cutscene_lift_off_scene_7()
	paznos_bridge.play_event_540_scene_7()
	event.jump_to_map_3(-1, "s10", 510)
end
script[605] = script.cutscene_lift_off_scene_7

--- Plays the first gate scene and jumps to d06b01.
function script.cutscene_gate_scene_1()
	paznos_bridge.play_event_640_scene_1()
	event.jump_to_map_3(-1, "d06b01", 600)
	vm.wait(2)
end
script[610] = script.cutscene_gate_scene_1

--- Plays the second gate scene and jumps to s32.
function script.cutscene_gate_scene_2()
	paznos_bridge.play_event_640_scene_2()
	event.jump_to_map_3(-1, "s32", 610)
	vm.wait(2)
end
script[620] = script.cutscene_gate_scene_2

--- Plays the third gate scene and jumps to s32.
function script.cutscene_gate_scene_3()
	paznos_bridge.play_event_640_scene_3()
	event.jump_to_map_3(-1, "s32", 620)
	vm.wait(2)
end
script[630] = script.cutscene_gate_scene_3

--- Plays the fourth gate scene and jumps to s32.
function script.cutscene_gate_scene_4()
	paznos_bridge.play_event_640_scene_4()
	event.jump_to_map_3(-1, "s32", 630)
	vm.wait(2)
end
script[640] = script.cutscene_gate_scene_4

--- Plays the fifth gate scene and jumps to s32.
function script.cutscene_gate_scene_5()
	paznos_bridge.play_event_640_scene_5()
	event.jump_to_map_3(-1, "s32", 640)
	vm.wait(2)
end
script[650] = script.cutscene_gate_scene_5

--- Starts the counterattack briefing for the commander or runs a villager conversation.
function script.talk_to_villager()
	local npc_id: s32 = 0
	local character_slot: s32 = 0
	local flag_536: s32 = 0
	local flag_540: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		if npc_id == 400 then
			flag_536 = event.get_save_flag(536) or flag_536
			flag_540 = event.get_save_flag(540) or flag_540
			if flag_536 == 1 and flag_540 == 0 then
				resume_step = 1
				if ask_ready_for_counterattack(character_slot) == 1 then
					event.fade_out_music(15)
					event.fade_out_screen(15)
					resume_step = 2
					wait.frames(15)
					resume_step = 3
					cutscene_paznos_liftoff()
				end
			else
				resume_step = 4
				workshop_villagers.talk_to_villager()
			end
		else
			resume_step = 5
			workshop_villagers.talk_to_villager()
		end
		return
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step <= 1 then
				wait.frames_skipping(15)
			end
			if resume_step <= 2 then
				resume_step = 3
				cutscene_paznos_liftoff()
				return vm.continue_with(function()
					return
				end)
			end
			if resume_step <= 3 then
				paznos_bridge.update_talk_characters()
			end
			if resume_step <= 4 then
				paznos_bridge.update_talk_characters()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_villager

--- Sets the lift-off flags and replays the lift-off cutscene.
function script.replay_liftoff()
	event.set_save_flag(536, 1)
	event.set_save_flag(540, 0)
	load_extra_character()
	cutscene_paznos_liftoff()
end
script[15400] = script.replay_liftoff

return script
