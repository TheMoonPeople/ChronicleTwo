--!strict
--- Event helpers shared by the g00 town shared data map.


local g00_town_shared_data = {}

--- Clears memory stack 4, runs georama command 1 with argument 24 and activates character 24.
function g00_town_shared_data.spawn_georama_character()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.run_georama_command(1, 24)
	event.set_character_active(24)
end

return g00_town_shared_data
