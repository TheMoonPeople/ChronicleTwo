--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_21e37ba4()
	local flag: s32 = 0
	event.initialize_event()
	flag = event.get_save_flag(202) or flag
	if flag == 0 then
		event.set_function_point_enabled("", "fc_event_202", 1)
	else
		event.set_function_point_enabled("", "fc_event_202", 0)
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.set_object_handle_visible(0, 0)
	end
end

return helper_21e37ba4
