--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_18c31a0e()
	event.set_character_active(1, 0)
	event.set_character_active(0, 9)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
end

return helper_18c31a0e
