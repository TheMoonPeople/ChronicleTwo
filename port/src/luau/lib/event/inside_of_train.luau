--!strict
--- Passenger setup for the Inside of Train map.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")

local inside_of_train = {}

--- Loads the NPCs assigned to the current train car and places them at their seats.
function inside_of_train.load_passengers()
	local train_car: s32 = 0
	local character_slot: s32 = 0
	local npc_id: s32 = 0
	local chapter: s32 = 0
	local save_counter_1: s32 = 0
	local party_status: s32 = 0
	local assigned_car: s32 = 0
	local flag_254: s32 = 0
	train_car = event.get_save_counter(0) or train_car
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	character_slot = 8
	event.clear_local_event_counters()
	npc_id = 1
	while npc_id <= 25 do
		chapter = event.get_chapter() or chapter
		if npc_id == 1 then
			save_counter_1 = event.get_save_counter(1) or save_counter_1
			if chapter ~= 8 or save_counter_1 ~= 1 then
				npc_id = npc_id + 1
				continue
			end
		end
		if chapter < 5 then
			if npc_id == 2 or npc_id == 13 then
				npc_id = npc_id + 1
				continue
			end
		end
		party_status = event.get_npc_party_status(npc_id) or party_status
		if party_status == 0 then
			npc_id = npc_id + 1
			continue
		end
		if bit32.band(party_status, 4) ~= 0 then
			npc_id = npc_id + 1
			continue
		end
		assigned_car = event.get_villager_training_value(0, npc_id) or assigned_car
		if train_car ~= assigned_car then
			npc_id = npc_id + 1
			continue
		end
		event.load_npc_character(1, 5, npc_id, character_slot)
		character.sit_at_train_seat(character_slot, npc_id)
		event.set_local_event_counter(character_slot, npc_id)
		event.set_scene_character_number(character_slot, npc_id)
		if bit32.band(party_status, 1) ~= 0 then
			event.set_character_active(0, character_slot)
		else
			event.set_character_active(character_slot)
		end
		character_slot = vm.i32(character_slot + 1)
		npc_id = npc_id + 1
	end
	flag_254 = event.get_save_flag(254) or flag_254
	if flag_254 ~= 0 and train_car == 3 then
		event.load_character(5, "event/train/tp02_01a.gltf", "info", character_slot)
		event.set_character_position(character_slot, 0.0, 56.0, -200.0)
		event.set_character_rotation(character_slot, 0.0, 0.0, 0.0)
		event.set_character_motion(character_slot, "立ち", 4)
		event.set_local_event_counter(character_slot, 34)
		event.set_scene_character_number(character_slot, 34)
		event.set_character_active(character_slot)
	end
end

return inside_of_train
