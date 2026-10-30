--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_b440871b()
	event.initialize_sound_port(5)
	event.initialize_sound_port(8)
	event.initialize_sound_port(1)
	event.delete_character_extension_packs(0)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(8)
	event.delete_character(13)
	event.delete_event_image(0)
	event.delete_event_image(1)
	event.set_save_control_bits(1, 0)
end

return helper_b440871b
