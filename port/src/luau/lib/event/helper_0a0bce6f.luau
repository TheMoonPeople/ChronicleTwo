--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_0a0bce6f(arg0: s32, arg1: s32)
	event.attach_object_handle_to_map_part_3(0, "p07_f03i04", "f03i04_07-m")
	event.set_object_handle_visible(0, arg0)
	event.attach_object_handle_to_map_part_3(1, "p05_f03i04", "f03i04_05-m")
	event.set_object_handle_visible(1, arg1)
end

return helper_0a0bce6f
