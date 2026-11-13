--!strict
--- Holds the helper that places the quest NPC in the town i04 house h05.


local i04_house_h05 = {}

--- Places the quest NPC when quest request 0 has status 2 and quest request 18 has status 0.
function i04_house_h05.place_quest_npc_if_ready()
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		return
	end
	request_status = event.get_quest_request_status(0, 18) or request_status
	if request_status ~= 0 then
		return
	end
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_npc_character(0, 4, 24, 28)
	event.set_character_position(28, 95.1, 96.2, 118.0)
	event.set_character_rotation(28, 0.0, -2.79, 0.0)
	event.set_character_motion(28, "立ち", 4)
	event.set_scene_character_number(28, 24)
	event.register_villager(28, 24)
	event.set_character_active(28)
end

return i04_house_h05
