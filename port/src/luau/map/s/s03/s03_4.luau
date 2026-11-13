--!strict
--- Event script for the train in the forest tunnel, covering the buggy chase sub-game, its game over retry prompt and Monica's fire magic cutscene.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local forest_tunnel = require("@lib/event/forest_tunnel")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Plays the train scene fading to black, then asks whether to try again or return to the title screen and returns the choice.
local function show_game_over_and_ask_retry()
	local sound_bank: s32 = 0
	local choice: any = 0
	local train_x: f32 = 0
	local train_y: f32 = 0
	local train_z: f32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.set_save_flag(205, 1)
		event.initialize_event()
		event.load_map_sounds(2206)
		sound_bank = event.load_sound_effect_file_2(2206) or sound_bank
		forest_tunnel.load_train_scene()
		event.stop_music(0)
		checkpoint = 1
		vm.wait(1)
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.play_sound_effect(sound_bank, 5)
		event.set_character_position(36, 102.27, 0.0, -305.63)
		event.set_character_rotation(36, 0.0, 0.0, 0.0)
		event.set_character_position(35, 44.05, 0.0, 60.82)
		event.set_character_scale(35, 2.0, 2.0, 2.0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 0, 0, 0, 0)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(11, 0)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.play_sound_effect(sound_bank, 1)
		event.attach_object_handle_to_map_part_2(10, "p01_s03t")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		do
			local out1, out2, out3 = event.get_object_handle_position(10)
			train_x = out1 or train_x
			train_y = out2 or train_y
			train_z = out3 or train_z
		end
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.move_object_sequence(10, 0.0, 51.92, 0.0, 60)
		event.rotate_object_sequence(10, 0.0, 0.0, -0.785, 60)
		event.set_camera_sequence_position(67.41, 107.89, 704.3)
		event.set_camera_sequence_look_at(59.64, 108.51, 271.98)
		event.move_camera_sequence_eased(58.28, 107.89, 196.59, 57.34, 108.51, 144.64, 50, 1, 0.4)
		checkpoint = 2
		wait.frames(45)
		event.set_object_sequence_color(11, 0, 0, 0, 255, 30)
		checkpoint = 3
		wait.frames(30)
		event.set_map_piece_character_motion("p01_s03t", "kikan-m", "停止")
		event.clear_effect_manager()
		forest_tunnel.unload_train_scene()
		event.set_object_sequence_position(10, train_x, train_y, train_z)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.stop_all_sounds()
		checkpoint = 4
		wait.frames(4)
		event.load_music(60)
		event.play_music(1)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "Riprova.\nTorna alla Schermata Titolo.")
		checkpoint = 5
		choice = message.ask_choice(0, -1, 8, 0, 0, 2, 0)
		event.set_character_active(1, 0)
		event.fade_out_screen(0)
		event.set_event_sprite_draw_pass(0, 0)
		return choice
	end, function(received: { any })
		if checkpoint <= 5 then
			if checkpoint == 5 then
				choice = received[1] :: number
			end
			if checkpoint <= 1 then
				wait.frames_skipping(45)
			end
			if checkpoint <= 2 then
				wait.frames_skipping(30)
			end
			if checkpoint <= 3 then
				cutscene.noop()
				wait.frames_skipping(4)
			end
			if checkpoint <= 4 then
				choice = message.open_choice_skipping(0, -1, 8, 0, 0, 2, 0)
			end
			return choice
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = cutscene.noop

--- Starts the train engine motion and places the player and camera inside the train.
function script.default_event()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	event.set_character_position(0, 0.0, 140.0, -420.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_position(0.0, 200.0, -260.0)
	event.set_camera_look_at(0.0, 170.0, -420.0)
	event.reset_follow_camera(0)
end

--- Waits briefly, then plays the taxi ride cutscene.
function script.key_open()
	wait.frames(30)
	forest_tunnel.play_taxi_ride_cutscene()
end

--- Plays the buggy chase cutscene and starts the sub-game.
function script.cutscene_buggy_chase()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	forest_tunnel.play_buggy_chase_cutscene()
	event.fade_in_screen(15)
	event.start_sub_game(3)
end
script[501] = script.cutscene_buggy_chase

--- Skips the next music load and jumps to map s08.
function script.leave_to_s08()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s08", 502)
	vm.wait(1)
end
script[502] = script.leave_to_s08

--- Plays Monica's fire magic cutscene and jumps to map s02.
function script.cutscene_monica_fire_magic()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	forest_tunnel.play_monica_fire_magic_cutscene()
	event.skip_next_music_play()
	event.jump_to_map_2(-1, "s02")
	vm.wait(2)
end
script[503] = script.cutscene_monica_fire_magic

--- Shows the game over choice and retries the sub-game or exits according to the answer.
function script.retry_or_exit_after_game_over()
	local choice: any = 0
	choice = show_game_over_and_ask_retry()
	forest_tunnel.retry_or_exit_train_game(choice)
end
script[512] = script.retry_or_exit_after_game_over

--- Plays the buggy chase cutscene and starts the sub-game without setting the engine motion first.
function script.cutscene_buggy_chase_again()
	forest_tunnel.play_buggy_chase_cutscene()
	event.fade_in_screen(15)
	event.start_sub_game(3)
end
script[12040] = script.cutscene_buggy_chase_again

--- Shows the game over choice and retries the sub-game or exits according to the answer.
function script.retry_or_exit_after_game_over_again()
	local choice: any = 0
	choice = show_game_over_and_ask_retry()
	forest_tunnel.retry_or_exit_train_game(choice)
end
script[12050] = script.retry_or_exit_after_game_over_again

--- Event 12060, which map data, a script or the engine runs by number.
script[12060] = forest_tunnel.play_monica_fire_magic_cutscene

--- Places the player and starts the train sub-game.
function script.start_train_sub_game()
	vm.wait(1)
	event.set_character_position(0, 0.0, 140.0, -420.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.start_sub_game(3)
end
script[22010] = script.start_train_sub_game

return script
