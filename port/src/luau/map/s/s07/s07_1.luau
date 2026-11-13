--!strict
--- Train interior script for the passenger car doors, car-to-car movement and passenger talk.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local inside_of_train = require("@lib/event/inside_of_train")
local map = require("@lib/event/map")
local message = require("@lib/event/message")
local partner_talk = require("@lib/event/english/partner_talk")
local shop_greeting = require("@lib/event/english/shop_greeting")
local train = require("@lib/event/train")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

--- Loads the passengers and fades into the train car.
function script.default_event()
	cutscene.noop()
	event.initialize_event()
	print("##IN_START_EVENT################################\n")
	inside_of_train.load_passengers()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(1, 3)
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Shows the debug message for the square button.
function script.key_open()
	event.open_message_window_2(0, "キ(O)ター[l1]ー[r1]ー[l2]ー[r2]ー")
	message.show(0, -1, 8, 0, 0)
end

--- Leaves through the front door to the station when the door is usable.
function script.exit_front_door()
	local can_use_door: s32 = 0
	print("--------------------------event200-------------------------\n")
	can_use_door = train.is_door_usable(1)
	if can_use_door ~= 0 then
		event.set_save_counter(15, 1)
		event.fade_out_screen(0)
		character.delete_extra_slots()
		event.stop_music(0)
		map.jump_to_station()
	end
end
script[200] = script.exit_front_door

--- Leaves through the rear door to the station when the door is usable.
function script.exit_rear_door()
	local can_use_door: s32 = 0
	print("--------------------------event201-------------------------\n")
	can_use_door = train.is_door_usable(0)
	if can_use_door ~= 0 then
		event.set_save_counter(15, 0)
		event.fade_out_screen(0)
		character.delete_extra_slots()
		event.stop_music(0)
		map.jump_to_station()
	end
end
script[201] = script.exit_rear_door

--- Moves to the previous car, or to the next map from the first car.
function script.enter_previous_car()
	local car_index: s32 = 0
	print("--------------------------event202-------------------------\n")
	event.fade_out_screen(0)
	character.delete_extra_slots()
	car_index = event.get_save_counter(0) or car_index
	if car_index == 1 then
		event.set_save_counter(0, 0)
		event.set_character_position(0, 0.0, 36.0, -100.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.jump_to_map_2(-1, "s08")
	else
		car_index = vm.i32(car_index - 1)
		event.set_save_counter(0, car_index)
		inside_of_train.load_passengers()
		event.set_character_position(0, 0.0, 36.0, -235.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	end
end
script[202] = script.enter_previous_car

--- Moves to the next car unless this is the last one.
function script.enter_next_car()
	local car_index: s32 = 0
	print("--------------------------event203-------------------------\n")
	car_index = event.get_save_counter(0) or car_index
	if car_index ~= 3 then
		event.fade_out_screen(0)
		character.delete_extra_slots()
		car_index = vm.i32(car_index + 1)
		event.set_save_counter(0, car_index)
		inside_of_train.load_passengers()
		event.set_character_position(0, 0.0, 36.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	end
end
script[203] = script.enter_next_car

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

--- Does nothing besides printing a debug message.
function script.ignore_trigger()
	print("--------------------------event207-------------------------\n")
end
script[207] = script.ignore_trigger

--- Requests the town edit event in the last car.
function script.request_edit_in_last_car()
	local car_index: s32 = 0
	print("--------------------------event208-------------------------\n")
	car_index = event.get_save_counter(0) or car_index
	if car_index == 3 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end
script[208] = script.request_edit_in_last_car

--- Opens the shop when the character spoken to is the conductor, or the companion menu for any other character.
function script.talk_to_passenger()
	local character_slot: s32 = 0
	local npc_id: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	npc_id = event.get_local_event_counter(character_slot) or npc_id
	if npc_id == 34 then
		event.set_message_window_option(1, 10, 0)
		shop_greeting.greet_and_open_shop()
		event.set_message_window_option(1, 10, 128)
	else
		partner_talk.open_companion_menu(character_slot, 0)
	end
end
script[1000] = script.talk_to_passenger

return script
