--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_fd981dba()
	event.initialize_sound_port(5)
	event.initialize_sound_port(8)
	event.initialize_sound_port(1)
	event.delete_character_extension_packs(0)
	event.delete_character(25)
	event.delete_character(26)
	event.delete_character(27)
	event.delete_character(28)
	event.delete_character(29)
	event.delete_character(30)
	event.delete_character(24)
	event.delete_character(8)
	event.set_save_control_bits(1, 0)
end

return helper_fd981dba
