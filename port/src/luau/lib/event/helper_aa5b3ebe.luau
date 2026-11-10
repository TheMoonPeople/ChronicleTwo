--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_aa5b3ebe(arg0: any)
	event.initialize_event()
	if arg0 == 0 then
		event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
		event.fade_in_screen(30)
		event.start_sub_game(3)
	else
		event.set_scene_exit_flag(1)
		event.fade_in_screen(30)
		return
	end
end

return helper_aa5b3ebe
