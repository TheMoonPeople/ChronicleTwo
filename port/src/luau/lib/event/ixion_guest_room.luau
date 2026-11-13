--!strict
--- Helpers for the Ixion guest room, including train passengers and reactions.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local object = vm.module("@lib/event/object")

local ixion_guest_room = {}

--- Loads the villagers currently riding the train, placing each one on a seat.
function ixion_guest_room.load_train_passengers()
	local train_stop: s32 = 0
	local next_slot: s32 = 0
	local villager_id: s32 = 0
	local party_status: s32 = 0
	local villager_train_stop: s32 = 0
	local extra_passenger_flag: s32 = 0
	train_stop = event.get_save_counter(0) or train_stop
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	next_slot = 8
	event.clear_local_event_counters()
	villager_id = 1
	while villager_id <= 25 do
		party_status = event.get_npc_party_status(villager_id) or party_status
		if party_status == 0 then
			villager_id = villager_id + 1
			continue
		end
		if bit32.band(party_status, 4) ~= 0 then
			villager_id = villager_id + 1
			continue
		end
		villager_train_stop = event.get_villager_training_value(0, villager_id) or villager_train_stop
		if train_stop ~= villager_train_stop then
			villager_id = villager_id + 1
			continue
		end
		event.load_npc_character(1, 5, villager_id, next_slot)
		character.sit_at_train_seat(next_slot, villager_id)
		event.set_local_event_counter(next_slot, villager_id)
		event.set_scene_character_number(next_slot, villager_id)
		if bit32.band(party_status, 1) ~= 0 then
			event.set_character_active(0, next_slot)
		else
			event.set_character_active(next_slot)
		end
		next_slot = vm.i32(next_slot + 1)
		villager_id = villager_id + 1
	end
	extra_passenger_flag = event.get_save_flag(254) or extra_passenger_flag
	if extra_passenger_flag ~= 0 and train_stop == 3 then
		event.load_character(5, "event/train/tp02_01a.gltf", "info", next_slot)
		event.set_character_position(next_slot, 0.0, 0.0, -200.0)
		event.set_character_rotation(next_slot, 0.0, 0.0, 0.0)
		event.set_character_motion(next_slot, "立ち", 4)
		event.set_local_event_counter(next_slot, 34)
		event.set_scene_character_number(next_slot, 34)
		event.set_character_active(next_slot)
	end
end

--- Turns the player character toward the camera, shakes their head, then turns back to the original facing and finishes the event.
function ixion_guest_room.shake_head_at_camera()
	local playable_character: s32 = 0
	local turn_back_delay: s32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.initialize_event()
	playable_character = event.get_playable_character() or playable_character
	if playable_character ~= 1 then
		turn_back_delay = 86
	else
		turn_back_delay = 64
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	event.turn_object_sequence_toward(0, camera_x, camera_y, camera_z, 6)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "だめだめ", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.delay_object_sequence_rotation_track(0, turn_back_delay)
	event.rotate_object_sequence(0, rotation_x, rotation_y, rotation_z, 6)
	object.wait_until_done(0)
	event.finish_event()
end

return ixion_guest_room
