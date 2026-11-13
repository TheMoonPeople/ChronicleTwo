--!strict
--- Holds the helpers that place the quest NPC in the town i04 house h02.


local i04_house_h02 = {}

--- Loads the quest NPC and places it in the house.
function i04_house_h02.place_quest_npc()
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_npc_character(0, 4, 24, 28)
	event.set_character_position(28, 42.4, 123.8, -110.2)
	event.set_character_rotation(28, 0.0, -0.31, 0.0)
	event.set_character_motion(28, "立ち", 4)
	event.set_scene_character_number(28, 24)
	event.register_villager(28, 24)
	event.set_character_active(28)
end

--- Places the quest NPC when quest request 18 has status 1 and save counter 11 is zero.
function i04_house_h02.place_quest_npc_if_requested()
	local request_status: s32 = 0
	local save_counter: s32 = 0
	request_status = event.get_quest_request_status(0, 18) or request_status
	if request_status == 1 then
		save_counter = event.get_save_counter(11) or save_counter
		if save_counter == 0 then
			i04_house_h02.place_quest_npc()
		end
	end
end

return i04_house_h02
