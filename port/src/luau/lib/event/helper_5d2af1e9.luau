--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_5d2af1e9()
	local flag: s32 = 0
	flag = event.get_save_flag(372) or flag
	if flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p09_s04")
		event.set_object_handle_visible(0, 0)
	end
end

return helper_5d2af1e9
