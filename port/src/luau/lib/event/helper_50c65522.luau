--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_50c65522()
	event.set_character_active(1, 0)
	event.delete_character(11)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_event_image(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

return helper_50c65522
