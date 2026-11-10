--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_bfd51d93()
	event.change_directory("chara/")
	event.load_character(5, "p03_37a.gltf", "info", 13)
	event.load_character(5, "p03_38a.gltf", "info", 14)
	event.load_character(5, "p03_39a.gltf", "info", 15)
	event.load_character(5, "p03_20a.gltf", "info", 16)
	event.load_character(5, "p03_22a.gltf", "info", 17)
	event.load_character(5, "p03_24a.gltf", "info", 18)
	event.change_directory("")
	for var0 = 0, 5 do
		event.set_character_active(1, 13 + var0)
		event.attach_object_handle_to_character(5 + var0, 13 + var0)
		event.clear_object_sequence(5 + var0)
		event.set_object_sequence_object(5 + var0, 5 + var0)
	end
end

return helper_bfd51d93
