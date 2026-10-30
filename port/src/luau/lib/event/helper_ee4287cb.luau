--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_ee4287cb()
	event.set_character_active(1, 0)
	event.set_character_active(0, 33)
	event.set_character_active(0, 34)
	event.set_character_active(0, 35)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(37)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.set_event_sprite_draw_pass(3, 0)
	event.delete_event_image(0)
	event.delete_event_image(1)
end

return helper_ee4287cb
