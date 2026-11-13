--!strict
--- Repair shop upstairs room with the tool and vacuum quest.

local vm = require("@lib/vm")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local repair_shop = require("@lib/event/repair_shop")
local wait = require("@lib/event/wait")

--- Turns the player toward the character in slot 9, who says the item is downstairs and to get to work.
local function tell_player_to_work()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_yaw: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local yaw: f32 = 0
	local turn_frames: s32 = 0
	local needs_turn: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 9)
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
		local out1, out2, out3 = event.get_character_position(9)
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	event.get_character_rotation(9)
	yaw = event.get_direction_angle(player_x, player_y, player_z, character_x, character_y, character_z) or yaw
	event.get_direction_angle(character_x, character_y, character_z, player_x, player_y, player_z)
	turn_frames = 0
	needs_turn = event.compare_angles(player_yaw, yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
		turn_frames = 20
	end
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(turn_frames)
	event.open_message_window_2(0, "[UNI00c8] sul tavolo al piano di sotto.\nMettiti al lavoro!")
	message.say_bubble(0, -1, 9, 0, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.initialize_map() end
script[99] = script.initialize_map

--- Sets up the room and places the player.
function script.default_event()
	repair_shop.set_up_starbre_room()
	event.take_memory_card_load_state()
	event.set_time_of_day_advancing(0)
	event.set_character_position(0, 49.9, 24.7, -68.2)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Says the requested work is unfinished.
function script.block_exit_before_work()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Non hai ancora terminato il lavoro\nche ti aveva chiesto Cedric.")
	message.show(0, -1, 5, 0, 0)
end
script[200] = script.block_exit_before_work

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Resets the counter and plays the ticket scene.
function script.cutscene_ticket()
	event.set_save_counter(5, 0)
	repair_shop.play_ticket_scene()
end
script[500] = script.cutscene_ticket

--- Offers to start repairing the vacuum if the tool is owned.
function script.examine_vacuum()
	local start_repair: s32 = 0
	local item_count: s32 = 0
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		start_repair = 0
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		item_count = event.get_owned_item_count(382) or item_count
		if item_count <= 0 then
			event.open_message_window_2(0, "Dunque... mi pare che quell'arnese\nfosse nel ripostiglio sul retro...")
			resume_step = 1
			message.show(0, -1, 5, 0, 0)
		else
			event.set_message_selection_top_line(0, 1)
			event.set_message_window_option(0, 0, 1)
			event.set_message_window_option(0, 1, 1)
			item_count = event.get_owned_item_count(386) or item_count
			if item_count <= 0 then
				event.open_message_window_2(
					0,
					"[UNI00c8] l'aspirapolvere di Gable.\nSembra ancora incompleto.\nBene, meglio darsi da fare!"
				)
				resume_step = 2
				choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if choice == 2 then
					start_repair = 1
				end
			else
				event.open_message_window_2(
					0,
					"[UNI00c8] l'aspirapolvere di Gable.\nOK! Ora lo aggiuster[UNI00f2]!\nMmh... lo far[UNI00f2] tra un po'!"
				)
				resume_step = 3
				choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if choice == 1 then
					start_repair = 1
				end
			end
			event.set_message_window_option(0, 0, 0)
			event.set_message_window_option(0, 1, 0)
			event.set_message_selection_top_line(0, 0)
		end
		event.set_message_bubble_tail(0, 1)
		if start_repair == 1 then
			resume_step = 4
			repair_shop.play_tool_work_scene()
			event.jump_to_map_3(-1, "m06", 151)
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 2 then
				choice = received[1] :: number
			end
			if resume_step == 3 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			if resume_step <= 2 then
				start_repair = 1
				choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			if resume_step <= 3 then
				local _ = choice == 2
				start_repair = 1
				resume_step = 4
				repair_shop.play_tool_work_scene()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "m06", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[501] = script.examine_vacuum

--- Plays the oversleeping scene and jumps to m08.
function script.cutscene_oversleeping()
	repair_shop.play_oversleeping_scene()
	event.jump_to_map_3(-1, "m08", 151)
end
script[502] = script.cutscene_oversleeping

--- Event 510, which map data, a script or the engine runs by number.
script.tell_player_to_work = tell_player_to_work
script[510] = script.tell_player_to_work

--- Walks to the cabinet and picks up the repair tool.
function script.pick_up_repair_tool()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	wait.frames(10)
	inventory.announce_received(382, 1)
	event.add_inventory_item(382)
	event.set_function_point_enabled("", "item1", 0)
end
script[520] = script.pick_up_repair_tool

--- Walks to the desk and picks up the memo.
function script.pick_up_memo()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	wait.frames(10)
	event.attach_object_handle_to_map_part_2(1, "memo")
	event.set_object_handle_visible(1, 0)
	inventory.announce_received(386, 1)
	event.add_inventory_item(386)
	event.set_function_point_enabled("", "item2", 0)
end
script[521] = script.pick_up_memo

--- Says the book cannot be read right now.
function script.examine_important_book()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Sembra ci sia un libro importante,\nma ancora non puoi dirlo.")
	message.show(0, -1, 5, 0, 0)
end
script[550] = script.examine_important_book

return script
