--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_9c20c95c()
	local var0: s32 = 0
	var0 = event.get_quest_request_status(0, 0) or var0
	if var0 ~= 2 then
		return
	end
	var0 = event.get_quest_request_status(0, 18) or var0
	if var0 ~= 0 then
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

return helper_9c20c95c
