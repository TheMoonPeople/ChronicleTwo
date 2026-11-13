--!strict
--- Ixion engine room with the train doors and cutscenes.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local ixion_engine_room = require("@lib/event/ixion_engine_room")
local map = require("@lib/event/map")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Fades the screen in.
function script.default_event()
	event.fade_in_screen(30)
end

--- Plays the e616 cutscene.
script.key_open = ixion_engine_room.play_e616_cutscene

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
		event.stop_music(0)
		map.jump_to_station()
	else
		event.play_sound_effect(sound_id, 108)
		character.shake_head()
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
		event.stop_music(0)
		map.jump_to_station()
	else
		event.play_sound_effect(sound_id, 108)
		character.shake_head()
	end
end
script[201] = script.use_door_0

--- Walks through the door to the guest room carriage.
function script.enter_guest_room()
	local sound_id: s32 = 0
	print("--------------------------event202-------------------------\n")
	character.turn_player_to_rotation(vm.f32(3.1415927))
	event.set_character_motion(0, "立ち")
	sound_id = event.get_sound_id(2) or sound_id
	event.play_sound_effect(sound_id, 94)
	event.fade_out_screen(30)
	wait.frames(30)
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.set_save_counter(0, 1)
	event.set_character_position(0, 0.0, -14.0, 235.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.stop_music(0)
	event.jump_to_map_2(-1, "s38")
end
script[202] = script.enter_guest_room

--- Plays the opening scene and jumps to s59.
function script.cutscene_intro_to_s59()
	ixion_engine_room.play_e600_intro_cutscene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s59", 500)
	vm.wait(2)
end
script[500] = script.cutscene_intro_to_s59

--- Plays the closing scene and jumps to s58.
function script.cutscene_closing_to_s58()
	ixion_engine_room.play_e600_closing_cutscene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s58", 500)
	vm.wait(2)
end
script[510] = script.cutscene_closing_to_s58

--- Plays the e648 scene and jumps to s11.
function script.cutscene_e648_to_s11()
	ixion_engine_room.play_e648_cutscene()
	event.jump_to_map_3(-1, "s11", 520)
	vm.wait(2)
end
script[520] = script.cutscene_e648_to_s11

--- Plays the e616 scene and jumps to s11.
function script.cutscene_e616_to_s11()
	ixion_engine_room.play_e616_cutscene()
	event.jump_to_map_3(-1, "s11", 599)
	vm.wait(2)
end
script[530] = script.cutscene_e616_to_s11

--- Replays the e648 scene and jumps to s11.
function script.replay_e648()
	ixion_engine_room.play_e648_cutscene()
	event.jump_to_map_3(-1, "s11", 520)
	vm.wait(2)
end
script[16480] = script.replay_e648

return script
