--!strict
-- Shared event helper used by 95 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_79d90c82()
	local ball_col: s32 = 0
	ball_col = event.get_sphida_ball_color() or ball_col
	if ball_col == 0 then
		ball_col = 1
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	else
		ball_col = 0
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	end
	event.set_sphida_ball_color(ball_col)
end

return helper_79d90c82
