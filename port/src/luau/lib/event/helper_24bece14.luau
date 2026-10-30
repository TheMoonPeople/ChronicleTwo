--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_24bece14()
	local argc: s32 = 0
	event.initialize_event()
	argc = event.get_item_count(386) or argc
	if 0 < argc then
		event.set_function_point_enabled("", "item2", 0)
		event.attach_object_handle_to_map_part_2(0, "memo")
		event.set_object_handle_visible(0, 0)
	end
end

return helper_24bece14
