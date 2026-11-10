--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_acde31fa(arg0: s32)
	event.attach_object_handle_to_character(0, 1)
	event.attach_object_handle_to_character(1, 2)
	event.set_object_handle_visible(0, arg0)
	event.set_object_handle_visible(1, arg0)
	event.show_dungeon_status_bar(arg0, 1.0)
end

return helper_acde31fa
