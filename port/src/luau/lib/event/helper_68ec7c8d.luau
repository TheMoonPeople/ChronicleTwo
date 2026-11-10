--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_68ec7c8d()
	local argc: s32 = 0
	argc = event.get_owned_item_count(386) or argc
	if argc >= 1 then
		event.set_function_point_enabled("", "memo", 0)
		event.attach_object_handle_to_map_part_2(0, "memo")
		event.set_object_handle_visible(0, 0)
	end
end

return helper_68ec7c8d
