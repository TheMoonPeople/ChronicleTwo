--!strict
--- Runs the secret room on its dungeon floor: the research note, the vase puzzle, the door to the next floor and the sun scene.

local vm = require("@lib/vm")
local alexandras_room = require("@lib/event/alexandras_room")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Stops the music, loads the room sounds, opens the revealed passage when its save flag is set and hides the other characters.
local function set_up_secret_room()
	local passage_revealed_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7686)
	passage_revealed_flag = event.get_save_flag(708) or passage_revealed_flag
	if passage_revealed_flag == 1 then
		event.set_function_point_enabled("", "e708", 0)
		event.attach_object_handle_to_map_part_2(0, "p06s50")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_2(0, "p04s50")
		event.set_object_handle_rotation(0, 0.0, -1.22, 0.0)
		event.attach_object_handle_to_map_part_2(1, "p05s50")
		event.set_object_handle_rotation(1, 0.0, 1.22, 0.0)
	end
	event.set_dungeon_pause_flags(8192, 1)
	event.set_character_change_unmasked(2, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_save_control_bits(1, 1)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Shows Max's idea search or Monica's monster research note after reading the book.
function script.show_research_note()
	local playable_character: s32 = 0
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(
			0,
			"-- Recherche d'Id[UNI00e9]es de Max --\nDans ce livre, Max apprend qu'il\npourrait cr[UNI00e9]er quelque chose avec :\n  ●une arme\n  ●une colonne lunaire\n  ●des bois de cerf"
		)
	else
		event.open_message_window_2(
			0,
			"-- [UNI00c9]tude des monstres de Monica --\nDans ce document, Monica apprend\nque le Carreau aime beaucoup\nceci : les diamants"
		)
	end
	message.show_and_wait(0, -1, 8, 0, 0)
end
script[0] = script.show_research_note

script.set_up_secret_room = set_up_secret_room
script[99] = script.set_up_secret_room

--- Sets up the room, places the character and camera in front of the door and fades in.
function script.default_event()
	set_up_secret_room()
	character.place_standing_and_reset_cloth(0.0, 0.0, 200.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 200.0)
	event.set_camera_position(0.0, 40.0, 320.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Resets the event and shakes the camera briefly.
function script.key_open()
	event.initialize_event()
	event.clear_camera_sequence()
	event.shake_camera_sequence(0.0, 1.0, 0.0, 16)
	camera.wait_until_done()
end

--- Leaves the room for the dungeon when the scene confirmation succeeds.
function script.leave_room_to_dungeon()
	if alexandras_room.confirm_scene_start(2) ~= 0 then
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
		event.set_dungeon_pause_flags(8192, 0)
		event.reset_action_character_motion(0)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d06/d06.stb", 1000)
	end
end
script[200] = script.leave_room_to_dungeon

--- Descends to the next floor through the door once the passage is revealed, or says the door is shut.
function script.enter_door_to_next_floor()
	local passage_revealed_flag: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	passage_revealed_flag = event.get_save_flag(708) or passage_revealed_flag
	if passage_revealed_flag == 1 then
		if alexandras_room.confirm_scene_start(1) ~= 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor = event.get_dungeon_floor() or floor
			next_floor = event.get_dungeon_next_floor(floor, 0) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			event.set_character_visible(1, 1)
			event.set_character_visible(2, 1)
			event.set_dungeon_pause_flags(8192, 0)
			event.reset_action_character_motion(0)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(3, 1)
			event.set_save_control_bits(1, 0)
			event.load_event_script("d06/d06.stb", 1000)
		end
	else
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "La porte est verrouill[UNI00e9]e.\nCette pi[UNI00e8]ce renfermerait-elle\nun secret ?")
		message.show_and_wait(0, -1, 5, 0, 0)
	end
end
script[210] = script.enter_door_to_next_floor

--- Handles the strange flower vase, using the item menu and playing the sun scene when the right item is used.
function script.examine_flower_vase()
	local playable_character: s32 = 0
	local interaction_stage: s32 = 0
	local item: s32 = 0
	local answer: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 or playable_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if playable_character == 2 then
				checkpoint = 1
				message.show_and_wait(0, 22, 5, 256, 208)
			else
				checkpoint = 2
				message.show_and_wait(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		interaction_stage = event.get_triggered_event_data_2(6) or interaction_stage
		if interaction_stage == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "Il y a un vase [UNI00e9]trange.\n(Pour ouvrir le menu : (#))")
			checkpoint = 3
			answer = message.ask_confirmation(0, -1, 5, 256, 208, answer)
			if answer == 1 then
				interaction_stage = 2
			end
		end
		if interaction_stage == 2 then
			event.open_use_item_menu(374)
			checkpoint = 4
			vm.wait(4)
			item = vmhost.used_item() or item
			if item > 0 then
				if item == 374 then
					event.show_dungeon_status_bar(0, 1.0)
					event.attach_object_handle_to_map_part_2(0, "p06s50")
					event.set_object_handle_visible(0, 1)
					event.set_function_point_enabled("", "e708", 0)
					event.set_function_point_enabled("", "next_floor", 1)
					event.fade_out_screen(3, 255, 255, 255)
					checkpoint = 5
					wait.frames(3)
					event.fade_in_screen(8)
					checkpoint = 6
					wait.frames(10)
					event.fade_out_screen(3, 255, 255, 255)
					checkpoint = 7
					wait.frames(3)
					event.fade_in_screen(8)
					checkpoint = 8
					wait.frames(20)
					event.fade_out_screen(30, 255, 255, 255)
					checkpoint = 9
					wait.frames(30)
					checkpoint = 10
					alexandras_room.play_andrea_sun_scene()
					character.place_standing_and_reset_cloth(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				else
					checkpoint = 11
					character.shake_head()
				end
			end
		end
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				message.show_and_wait_skipping(0, 23, 5, 256, 208)
			end
			return 0
		end
		if checkpoint <= 10 then
			if checkpoint == 3 then
				answer = received[2] :: number
			end
			if checkpoint <= 3 then
				local _ = interaction_stage == 1
				interaction_stage = 2
			end
			if checkpoint <= 4 then
				wait.frames_skipping(3)
			end
			if checkpoint <= 5 then
				wait.frames_skipping(10)
			end
			if checkpoint <= 6 then
				wait.frames_skipping(3)
			end
			if checkpoint <= 7 then
				wait.frames_skipping(20)
			end
			if checkpoint <= 8 then
				wait.frames_skipping(30)
			end
			if checkpoint <= 9 then
				checkpoint = 10
				alexandras_room.play_andrea_sun_scene()
				return vm.continue_with(function()
					character.place_standing_and_reset_cloth(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			cutscene.ignore_coordinates(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
			return 0
		end
		if checkpoint <= 11 then
			return 0
		end
		return nil
	end)
end
script[500] = script.examine_flower_vase

--- Runs the defeat sequence with a silent message when the party is defeated.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_player_defeated

--- Hides the party characters and plays the Andrea sun scene.
function script.cutscene_andrea_sun()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	alexandras_room.play_andrea_sun_scene()
end
script[17080] = script.cutscene_andrea_sun

return script
