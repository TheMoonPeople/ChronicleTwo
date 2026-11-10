--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_d5c6856f()
	event.set_character_active(1, 0)
	event.delete_character(35)
	event.delete_character(33)
	event.delete_character(34)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

return helper_d5c6856f
