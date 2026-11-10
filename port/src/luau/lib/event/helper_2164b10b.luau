--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_2164b10b()
	local var0: s32 = 0
	event.attach_object_handle_to_map_part_2(0, "p06_e03h03-0")
	event.attach_object_handle_to_map_part_2(1, "p07_e03h03-0")
	var0 = event.get_save_data_value(6) or var0
	if var0 == 1 then
		event.set_object_handle_visible(0, 0)
		event.set_object_handle_visible(1, 1)
	else
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_visible(1, 0)
	end
end

return helper_2164b10b
