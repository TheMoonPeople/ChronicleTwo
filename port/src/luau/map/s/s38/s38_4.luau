--!strict
--- Ixion guest room carriages with doors between carriages and passengers.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local ixion_guest_room = require("@lib/event/ixion_guest_room")
local map = require("@lib/event/map")
local partner_talk = require("@lib/event/italian/partner_talk")
local shop_greeting = require("@lib/event/italian/shop_greeting")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Loads the passengers and fades in.
function script.default_event()
	cutscene.noop()
	event.initialize_event()
	print("##IN_START_EVENT################################\n")
	ixion_guest_room.load_train_passengers()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(1, 3)
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Exits to the station through train door 1 when it is usable and otherwise shakes the head.
function script.use_door_1()
	local sound_id: s32 = 0
	local door_usable: s32 = 0
	print("--------------------------event200-------------------------\n")
	character.turn_player_to_rotation(vm.f32(-1.5707964))
	sound_id = event.get_sound_id(2) or sound_id
	door_usable = train.is_door_usable(1)
	if door_usable ~= 0 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(sound_id, 94)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_save_counter(15, 1)
		character.delete_extra_slots()
		event.stop_music(0)
		map.jump_to_station()
	else
		ixion_guest_room.shake_head_at_camera()
	end
end
script[200] = script.use_door_1

--- Exits to the station through train door 0 when it is usable and otherwise shakes the head.
function script.use_door_0()
	local sound_id: s32 = 0
	local door_usable: s32 = 0
	print("--------------------------event201-------------------------\n")
	character.turn_player_to_rotation(vm.f32(1.5707964))
	sound_id = event.get_sound_id(2) or sound_id
	door_usable = train.is_door_usable(0)
	if door_usable ~= 0 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(sound_id, 94)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_save_counter(15, 0)
		character.delete_extra_slots()
		event.stop_music(0)
		map.jump_to_station()
	else
		ixion_guest_room.shake_head_at_camera()
	end
end
script[201] = script.use_door_0

--- Walks to the previous carriage or the engine room.
function script.go_to_previous_carriage()
	local sound_id: s32 = 0
	local carriage_index: s32 = 0
	print("--------------------------event202-------------------------\n")
	character.turn_player_to_rotation(0.0)
	event.set_character_motion(0, "立ち")
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 94)
	event.fade_out_screen(30)
	wait.frames(30)
	character.delete_extra_slots()
	carriage_index = event.get_save_counter(0) or carriage_index
	if carriage_index == 1 then
		event.set_save_counter(0, 0)
		event.set_character_position(0, 0.0, -22.4, -207.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.jump_to_map_2(-1, "s37")
	else
		carriage_index = vm.i32(carriage_index - 1)
		event.set_save_counter(0, carriage_index)
		ixion_guest_room.load_train_passengers()
		event.set_character_position(0, 0.0, -14.0, -235.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	end
end
script[202] = script.go_to_previous_carriage

--- Walks to the next carriage unless this is the last.
function script.go_to_next_carriage()
	local sound_id: s32 = 0
	local carriage_index: s32 = 0
	print("--------------------------event203-------------------------\n")
	character.turn_player_to_rotation(vm.f32(3.1415927))
	event.set_character_motion(0, "立ち")
	sound_id = event.get_sound_id(2) or sound_id
	carriage_index = event.get_save_counter(0) or carriage_index
	if carriage_index ~= 3 then
		event.set_character_motion(0, "立ち")
		event.play_sound_effect(sound_id, 94)
		event.fade_out_screen(30)
		wait.frames(30)
		character.delete_extra_slots()
		carriage_index = vm.i32(carriage_index + 1)
		event.set_save_counter(0, carriage_index)
		ixion_guest_room.load_train_passengers()
		event.set_character_position(0, 0.0, -14.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
		event.initialize_event()
		event.close_message_window(1)
		event.fade_in_screen(30)
		event.finish_event()
	else
		ixion_guest_room.shake_head_at_camera()
	end
end
script[203] = script.go_to_next_carriage

--- Opens the shop for the shopkeeper or the companion menu for another passenger.
function script.talk_to_passenger()
	local character_slot: s32 = 0
	local character_counter: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	character_counter = event.get_local_event_counter(character_slot) or character_counter
	if character_counter == 34 then
		event.set_message_window_option(1, 10, 0)
		shop_greeting.greet_and_open_shop()
		event.set_message_window_option(1, 10, 128)
	else
		partner_talk.open_companion_menu(character_slot, 0)
	end
end
script[1000] = script.talk_to_passenger

return script
