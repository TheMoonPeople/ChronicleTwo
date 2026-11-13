--!strict
--- Event script for the Channel Reservoir stage map s01, with the train, the dungeon gate prompt and the walk-back warnings.

local vm = require("@lib/vm")
local channel_reservoir = require("@lib/event/channel_reservoir")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Moves the train map part off screen until its save flag is set.
local function hide_train()
	local train_arrived_flag: s32 = 0
	train_arrived_flag = event.get_save_flag(202) or train_arrived_flag
	if train_arrived_flag == 0 then
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_position(0, 0.0, 0.0, -2000.0)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.hide_train = hide_train
script[99] = script.hide_train

--- Hides the train and starts the intro walk or restores the player after the menu.
function script.default_event()
	local intro_seen_flag: s32 = 0
	hide_train()
	intro_seen_flag = event.get_save_flag(201) or intro_seen_flag
	if intro_seen_flag == 0 then
		event.set_dungeon_floor_info(0, 8, 7, 1)
		event.set_dungeon_floor_info(0, 8, 5, 2)
		channel_reservoir.play_mints_walk_intro()
	else
		channel_reservoir.walk_player_back_from_menu()
	end
	channel_reservoir.initialize_map()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = channel_reservoir.play_train_flyby_opening

--- Fades to white and jumps to map g02.
function script.exit_to_g02()
	event.fade_out_screen(30, 255.0, 255.0, 255.0)
	wait.frames(30)
	event.jump_to_map_2(-1, "g02")
end
script[160] = script.exit_to_g02

--- Plays the train boarding cutscene and jumps to map s08.
function script.board_train_to_s08()
	local stage: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		stage = 1
		wait.frames(30)
		stage = 2
		channel_reservoir.play_train_boarding_cutscene()
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s08", 501)
		stage = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if stage <= 3 then
			if stage <= 1 then
				stage = 2
				channel_reservoir.play_train_boarding_cutscene()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s08", 501)
					stage = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[501] = script.board_train_to_s08

--- Grants stage supplies and plays the intro walk.
function script.cutscene_mints_walk_with_supplies()
	inventory.grant_stage_supplies(2)
	channel_reservoir.play_mints_walk_intro()
	channel_reservoir.initialize_map()
end
script[502] = script.cutscene_mints_walk_with_supplies

--- Asks whether to enter, either running into the dungeon floor selection or walking back, returning 1 on entry.
function script.ask_enter_dungeon_gate()
	local answer: any = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_motion(0, "立ち", 4)
	answer = message.ask_yes_no(5, 55)
	if answer == 0 then
		event.set_camera_sequence_position(-637.75, 234.47, 94.15)
		event.set_camera_sequence_look_at(-573.29, 154.14, -234.77)
		event.set_object_sequence_position(0, -571.45, 132.37, -243.31)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_camera_sequence(-637.75, 234.47, 94.15, -561.56, 145.42, -381.61, 45)
		event.move_object_sequence(0, -570.49, 132.37, -362.93, 45)
		wait.frames(15)
		event.fade_out_screen(30)
		wait.frames(30)
		channel_reservoir.select_dungeon_floor()
		return 1
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	x = vm.f32(x + vm.f32(30.0 * vm.sin(0.0)))
	z = vm.f32(z + vm.f32(30.0 * vm.cos(0.0)))
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 15)
	event.move_object_sequence(0, x, y, z, 45)
	for i = 0, 44 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_camera_sequence_look_at(x, y + 30.0, z)
		vm.wait(5)
	end
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	return 0
end
script[600] = script.ask_enter_dungeon_gate

--- Walks the player back and says it is dangerous to continue and suggests the train.
function script.warn_dangerous_path()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	x = vm.f32(x + vm.f32(30.0 * vm.sin(vm.f32(3.1415927))))
	z = vm.f32(z + vm.f32(30.0 * vm.cos(vm.f32(3.1415927))))
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 15)
	event.move_object_sequence(0, x, y, z, 45)
	for i = 0, 44 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		event.set_camera_sequence_look_at(x, y + 30.0, z)
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Von hier zu laufen ist\ngef[UNI00e4]hrlich.\nFahren wir Zug.")
	message.show(0, -1, 5, 0, 0)
	event.set_message_bubble_tail(0, 1)
end
script[601] = script.warn_dangerous_path

--- Plays the train boarding cutscene.
function script.board_train()
	local stage: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		stage = 1
		wait.frames(30)
		stage = 2
		channel_reservoir.play_train_boarding_cutscene()
		return
	end, function(received: { any })
		if stage <= 2 then
			if stage <= 1 then
				stage = 2
				channel_reservoir.play_train_boarding_cutscene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[610] = script.board_train

--- Event 12010, which map data, a script or the engine runs by number.
script[12010] = channel_reservoir.play_mints_walk_intro

--- Plays the train boarding cutscene, fades out and jumps to map s08.
function script.board_train_to_s08_with_fade()
	local stage: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.fade_out_screen(30)
		stage = 1
		wait.frames(30)
		stage = 2
		channel_reservoir.play_train_boarding_cutscene()
		event.fade_out_screen(30)
		stage = 3
		wait.frames(30)
		event.skip_next_music_load()
		event.jump_to_map_3(-1, "s08", 501)
		stage = 4
		vm.wait(4)
		return
	end, function(received: { any })
		if stage <= 4 then
			if stage <= 1 then
				stage = 2
				channel_reservoir.play_train_boarding_cutscene()
				return vm.continue_with(function()
					event.fade_out_screen(30)
					stage = 3
					wait.frames(30)
					event.skip_next_music_load()
					event.jump_to_map_3(-1, "s08", 501)
					stage = 4
					vm.wait(4)
					return
				end)
			end
			if stage <= 2 then
				wait.frames_skipping(30)
			end
			return 0
		end
		return nil
	end)
end
script[12020] = script.board_train_to_s08_with_fade

return script
