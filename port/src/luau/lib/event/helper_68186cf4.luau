--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_68186cf4(arg0: s32)
	event.initialize_event()
	event.attach_object_handle_to_map_part_3(0, "p01_s06", "s06_02-a0")
	event.attach_object_handle_to_map_part_3(1, "p01_s06", "s06_03-a0")
	if arg0 ~= 0 then
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_visible(1, 1)
	else
		event.set_object_handle_visible(0, 0)
		event.set_object_handle_visible(1, 0)
	end
end

return helper_68186cf4
