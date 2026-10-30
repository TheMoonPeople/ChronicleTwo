--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_7d755610()
	for var0 = 0, 17 do
		event.delete_character(8 + var0)
	end
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
end

return helper_7d755610
