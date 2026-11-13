--!strict
--- Locomotive interior script with the crew scene, car doors and the collapse cutscene.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local inside_of_locomotive = require("@lib/event/inside_of_locomotive")
local map = require("@lib/event/map")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local sound_bank: s32 = 0

--- Plays the locomotive sound effects.
local function play_locomotive_sounds()
	event.play_sound_effect(sound_bank, 2)
	event.play_sound_effect(sound_bank, 8)
end

--- Loads and places the locomotive crew and starts the locomotive sounds.
local function place_locomotive_crew()
	event.initialize_event()
	sound_bank = 0
	event.load_map_sounds(2200)
	sound_bank = event.load_sound_effect_file_2(2200) or sound_bank
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "event/e200/e203/e203_starbre.gltf", "info", 9)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(1, 9)
	event.set_character_position(9, 5.62, 36.1, 39.9)
	event.set_character_rotation(9, 0.0, 3.04, 0.0)
	event.set_character_motion(9, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_vorneo.gltf", "info", 10)
	event.attach_object_handle_to_character(2, 10)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(1, 10)
	event.set_character_position(10, -38.37, 36.08, 32.88)
	event.set_character_rotation(10, 0.0, 1.48, 0.0)
	event.set_character_motion(10, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_tom.gltf", "info", 11)
	event.attach_object_handle_to_character(3, 11)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(1, 11)
	event.set_character_position(11, -1.81, 36.1, 72.51)
	event.set_character_rotation(11, 0.0, -0.48, 0.0)
	event.set_character_motion(11, "立ち", 4)
	event.set_object_handle_sound_bank(3, sound_bank)
	event.register_villager(9, 1)
	event.register_villager(10, 2)
	event.register_villager(11, 13, 65)
	event.set_scene_character_number(9, 1)
	event.set_scene_character_number(10, 2)
	event.set_scene_character_number(11, 13)
	play_locomotive_sounds()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

--- Places the crew and function points for the story state and fades in.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	inside_of_locomotive.show_characters_by_progress()
	inside_of_locomotive.disable_saving()
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		inside_of_locomotive.set_function_points_enabled(1)
		event.set_save_control_bits(1, 1)
	else
		inside_of_locomotive.set_function_points_enabled(0)
	end
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.set_character_position(0, 38.0, 36.1, -100.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
	end
	if flag == 1 and flag_2 == 0 then
		place_locomotive_crew()
	end
	event.fade_in_screen(30)
end

--- Shows the locomotive message after the button is released.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(64)
	message.show(0, 1002, 8, 450, 100)
	event.do_nothing(0)
end

--- Leaves through the front door to the station when the door is usable.
function script.exit_front_door()
	local can_use_door: s32 = 0
	print("-------event_200----------------------\n")
	can_use_door = train.is_door_usable(1)
	if can_use_door ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 1)
		event.fade_out_screen(0)
		event.stop_music(0)
		map.jump_to_station()
	end
end
script[200] = script.exit_front_door

--- Leaves through the rear door to the station when the door is usable.
function script.exit_rear_door()
	local can_use_door: s32 = 0
	print("-------event_201----------------------\n")
	can_use_door = train.is_door_usable(0)
	if can_use_door ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 0)
		event.fade_out_screen(0)
		event.stop_music(0)
		map.jump_to_station()
	end
end
script[201] = script.exit_rear_door

--- Goes back to the passenger car unless the crew scene is active.
function script.go_to_passenger_car()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.set_save_control_bits(1, 0)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_save_counter(0, 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_character_position(0, 0.0, 36.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.jump_to_map_2(-1, "s07")
	end
end
script[203] = script.go_to_passenger_car

--- Leaves the locomotive for the next area during the crew scene.
function script.leave_locomotive_for_s03()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(30)
		event.stop_sound_effect(sound_bank, 2)
		event.stop_sound_effect(sound_bank, 8)
		event.jump_to_map_3(-1, "s03", 501)
		vm.wait(1)
	end
end
script[204] = script.leave_locomotive_for_s03

--- Requests the town edit event at the front door when it is not usable.
function script.request_edit_at_front_door()
	local can_use_door: s32 = 0
	print("--------------------------event205-------------------------\n")
	can_use_door = train.is_door_usable(1)
	if can_use_door == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[205] = script.request_edit_at_front_door

--- Requests the town edit event at the rear door when it is not usable.
function script.request_edit_at_rear_door()
	local can_use_door: s32 = 0
	print("--------------------------event206-------------------------\n")
	can_use_door = train.is_door_usable(0)
	if can_use_door == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[206] = script.request_edit_at_rear_door

--- Requests the town edit event during the crew scene.
function script.request_edit_during_crew_scene()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event208-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[208] = script.request_edit_during_crew_scene

--- Requests the town edit event outside the crew scene.
function script.request_edit_outside_crew_scene()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event209-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[209] = script.request_edit_outside_crew_scene

--- Opens the menu with its save data value set.
function script.open_menu()
	event.set_save_data_value(3, 1)
	menu.open_with_fade()
	event.set_save_data_value(3, 0)
end
script[400] = script.open_menu

--- Places the crew and plays the picture scene.
function script.cutscene_picture_scene()
	inside_of_locomotive.disable_saving()
	inside_of_locomotive.set_function_points_enabled(1)
	place_locomotive_crew()
	inside_of_locomotive.play_picture_scene()
	event.set_save_control_bits(1, 1)
	play_locomotive_sounds()
	event.fade_in_screen(30)
end
script[501] = script.cutscene_picture_scene

--- Plays the collapse scene and goes to the next area.
function script.cutscene_collapse()
	inside_of_locomotive.play_collapse_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end
script[502] = script.cutscene_collapse

--- Shows what the crew member says to the player.
function script.talk_to_crew()
	local character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	message.set_window_mode(0, 1)
	if character_slot == 9 then
		event.open_message_window_2(0, "Tr[UNI00f6]del nicht rum.\nKlettere schnell die Leiter rauf!")
	end
	if character_slot == 10 then
		event.open_message_window_2(
			0,
			"Jetzt ist keine Zeit zum\nPlaudern! Klettere hoch, Max,\nund sieh nach, wie's drau[UNI00df]en aussieht!"
		)
	end
	if character_slot == 11 then
		event.open_message_window_2(
			0,
			"Den Ersch[UNI00fc]tterungen nach waren\nes wohl recht kleine Bomben.<page>Hoffentlich haben sie nichts\nWichtiges getroffen."
		)
	end
	cutscene.talk(character_slot, -1, 0, 0)
end
script[1000] = script.talk_to_crew

--- Replays the picture scene.
function script.replay_picture_scene()
	place_locomotive_crew()
	inside_of_locomotive.play_picture_scene()
	play_locomotive_sounds()
	event.fade_in_screen(30)
end
script[12030] = script.replay_picture_scene

--- Replays the collapse scene.
function script.replay_collapse_scene()
	inside_of_locomotive.play_collapse_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end
script[12050] = script.replay_collapse_scene

return script
